#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Untouched SEZB1 (A235FXXSEEZB1) vendor and odm images. They are stored as
# verified xz parts and rebuilt on demand by tools/assemble_images.py.
#

A235F_VENDOR_PATH := vendor/samsung/a235f

BOARD_PREBUILT_VENDORIMAGE := $(A235F_VENDOR_PATH)/images/vendor.img
BOARD_PREBUILT_ODMIMAGE := $(A235F_VENDOR_PATH)/images/odm.img

# Kati caches $(wildcard), so test with the shell. assemble_images.py verifies
# every part and the rebuilt images against images/SHA256SUMS.
A235F_IMAGES_PRESENT = $(shell test -f $(BOARD_PREBUILT_VENDORIMAGE) -a -f $(BOARD_PREBUILT_ODMIMAGE) && echo true)
ifneq ($(A235F_IMAGES_PRESENT),true)
$(info a235f: assembling stock vendor/odm images)
$(shell python3 $(A235F_VENDOR_PATH)/tools/assemble_images.py >&2)
ifneq ($(A235F_IMAGES_PRESENT),true)
$(error a235f: stock images missing; run python3 $(A235F_VENDOR_PATH)/tools/assemble_images.py)
endif
endif
