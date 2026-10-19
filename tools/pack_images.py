#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
"""Split stock SEZB1 vendor/odm images into xz parts below GitHub's file limit.

Run once on a workstation: pack_images.py <dir with vendor.img odm.img> <out dir>
"""
import hashlib
import lzma
import pathlib
import sys

PART_SIZE = 95 * 1024 * 1024
IMAGES = ('vendor.img', 'odm.img')


def main(source, out):
    source, out = pathlib.Path(source), pathlib.Path(out)
    out.mkdir(parents=True, exist_ok=True)
    sums = []
    for name in IMAGES:
        raw = (source / name).read_bytes()
        sums.append(f'{hashlib.sha256(raw).hexdigest()}  {name}')
        packed = lzma.compress(raw, preset=6)
        for index in range(0, len(packed), PART_SIZE):
            part = f'{name}.xz.{index // PART_SIZE:02d}'
            data = packed[index:index + PART_SIZE]
            (out / part).write_bytes(data)
            sums.append(f'{hashlib.sha256(data).hexdigest()}  {part}')
        print(f'{name}: {len(raw)} -> {len(packed)} bytes', flush=True)
    (out / 'SHA256SUMS').write_text('\n'.join(sums) + '\n')


if __name__ == '__main__':
    main(*sys.argv[1:3])
