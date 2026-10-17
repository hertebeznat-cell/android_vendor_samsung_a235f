#!/usr/bin/env python3
"""Read-only source/install checks; does not compile, fetch, or use a device.

This deliberately does not claim ELF ABI, SELinux or VINTF compatibility with
an Android platform that has not been synced and built.
"""
import collections
from pathlib import Path
import re
import struct
import sys
import xml.etree.ElementTree as ET
import zipfile


def audit(vendor):
    vendor = Path(vendor).resolve()
    root = vendor.parents[2]
    errors = []
    copied = collections.defaultdict(list)
    makefile = (vendor / 'a235f-vendor.mk').read_text(encoding='utf-8-sig')
    for number, line in enumerate(makefile.splitlines(), 1):
        line = line.split('#', 1)[0].strip().rstrip('\\').strip()
        if len(line.split()) != 1 or line.count(':') != 1:
            continue
        source, destination = line.split(':')
        for partition in ('VENDOR', 'ODM', 'PRODUCT', 'SYSTEM_EXT'):
            destination = destination.replace('$(TARGET_COPY_OUT_' + partition + ')',
                                              partition.lower())
        copied[destination].append(f'a235f-vendor.mk:{number}')
        path = root / source
        if not path.is_file():
            errors.append(f'Missing copy source: {source}')
            continue
        # Detect swapped ARM/ARM64 inputs without running the Android linker.
        with path.open('rb') as stream:
            header = stream.read(64)
        if header[:4] == b'\x7fELF':
            endian = '<' if header[5] == 1 else '>'
            machine = struct.unpack_from(endian + 'H', header, 18)[0]
            if (destination.startswith('vendor/lib64/') and
                    not destination.startswith('vendor/lib64/rfsa/') and machine != 183):
                errors.append(f'Non-AArch64 ELF installed in lib64: {destination}')
            if (destination.startswith('vendor/lib/') and
                    not destination.startswith('vendor/lib/rfsa/') and
                    destination != 'vendor/lib/libsn100u_fw.so' and machine != 40):
                errors.append(f'Non-ARM ELF installed in lib: {destination}')
        # NXP intentionally stores its AArch64 firmware/data library under lib,
        # and RFSA directories contain Hexagon DSP ELFs even below lib64.

    for destination, owners in copied.items():
        if len(owners) != 1:
            errors.append(f'Duplicate copy destination {destination}: {owners}')

    bp = (vendor / 'Android.bp').read_text(encoding='utf-8-sig')
    modules = re.findall(r'(?ms)^(\w+)\s*\{\n(.*?)^\}', bp)
    names = collections.Counter()
    installed = set(copied)
    for kind, body in modules:
        name = re.search(r'\bname:\s*"([^"]+)"', body)
        if name:
            names[name.group(1)] += 1
        source = re.search(r'\b(?:src|apk):\s*"([^"]+)"', body)
        if not source:
            continue
        source = source.group(1)
        path = vendor / source
        if not path.is_file():
            errors.append(f'Missing {kind} source: {source}')
            continue
        if source.startswith('proprietary/odm/'):
            if not re.search(r'\bdevice_specific:\s*true', body):
                errors.append(f'ODM module installs outside ODM: {source}')
        if kind == 'vintf_fragment':
            destination = 'vendor/etc/vintf/manifest/' + path.name
        elif kind == 'prebuilt_etc_xml':
            partition = 'odm' if re.search(r'\bdevice_specific:\s*true', body) else 'vendor'
            subdir = re.search(r'\bsub_dir:\s*"([^"]+)"', body)
            destination = partition + '/etc/' + (subdir.group(1) + '/' if subdir else '') + path.name
        else:
            destination = None
        if destination:
            if destination in installed:
                errors.append(f'Multiple installers for {destination}')
            installed.add(destination)
        if kind == 'android_app_import':
            if not zipfile.is_zipfile(path):
                errors.append(f'Invalid APK container: {source}')
            else:
                with zipfile.ZipFile(path) as archive:
                    if 'AndroidManifest.xml' not in archive.namelist():
                        errors.append(f'APK has no AndroidManifest.xml: {source}')
    for name, count in names.items():
        if count != 1:
            errors.append(f'Duplicate Soong module name: {name}')

    services = collections.defaultdict(list)
    for destination in copied:
        if not destination.startswith('vendor/etc/init/') or not destination.endswith('.rc'):
            continue
        source = vendor / 'proprietary' / destination
        if not source.is_file():
            continue
        text = source.read_text(encoding='utf-8-sig')
        for block in re.finditer(r'(?m)^service\s+(\S+)[^\n]*\n((?:[ \t]+[^\n]*\n|\n)*)', text):
            services[block.group(1)].append((destination, bool(re.search(
                r'(?m)^\s+override\s*$', block.group(2)))))
    for name, definitions in services.items():
        # Samsung intentionally overrides some imported Qualcomm definitions.
        if len(definitions) > 1 and not any(override for _, override in definitions):
            errors.append(f'Duplicate init service without override: {name}: {definitions}')

    for path in (vendor / 'proprietary').rglob('*.xml'):
        try:
            ET.parse(path)
        except ET.ParseError as error:
            errors.append(f'Invalid XML {path.relative_to(vendor)}: {error}')
    return errors


if __name__ == '__main__':
    findings = audit(Path(__file__).resolve().parents[1])
    for finding in findings:
        print('ERROR:', finding)
    if not findings:
        print('Vendor source/install checks passed; platform ABI and boot remain unverified.')
    sys.exit(bool(findings))
