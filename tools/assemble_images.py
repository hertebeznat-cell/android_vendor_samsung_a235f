#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
"""Rebuild the stock vendor/odm images from their verified xz parts.

Idempotent: images already matching SHA256SUMS are left alone. Exits non-zero
on any checksum mismatch so the build never uses a damaged image.
"""
import hashlib
import lzma
import pathlib
import sys

IMAGES = pathlib.Path(__file__).resolve().parent.parent / 'images'


def sha256(path):
    digest = hashlib.sha256()
    with open(path, 'rb') as stream:
        for block in iter(lambda: stream.read(1 << 20), b''):
            digest.update(block)
    return digest.hexdigest()


def main():
    sums = {}
    for line in (IMAGES / 'SHA256SUMS').read_text().splitlines():
        digest, name = line.split()
        sums[name] = digest
    for image in (name for name in sums if name.endswith('.img')):
        target = IMAGES / image
        if target.is_file() and sha256(target) == sums[image]:
            continue
        parts = sorted(name for name in sums if name.startswith(image + '.xz.'))
        decompressor = lzma.LZMADecompressor()
        temporary = target.with_suffix('.img.tmp')
        with open(temporary, 'wb') as output:
            for part in parts:
                if sha256(IMAGES / part) != sums[part]:
                    sys.exit(f'a235f: checksum mismatch for {part}')
                output.write(decompressor.decompress((IMAGES / part).read_bytes()))
        if not decompressor.eof or sha256(temporary) != sums[image]:
            temporary.unlink()
            sys.exit(f'a235f: rebuilt {image} does not match SHA256SUMS')
        temporary.replace(target)
        print(f'a235f: assembled {image}', file=sys.stderr)


if __name__ == '__main__':
    main()
