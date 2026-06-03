#
# Copyright (C) 2024-2026 The Evolution X Project
# SPDX-License-Identifier: Apache-2.0
#
# Vendor product makefile for Samsung Galaxy A23 (SM-A235F)
#
# NOTE: This file provides the framework for copying proprietary blobs.
# Blobs must first be extracted using extract-files.sh from the device tree.
# Until blobs are extracted, this file serves as a skeleton.

PRODUCT_SOONG_NAMESPACES += \
    vendor/samsung/a235f

# Prebuilt APKs (extract from stock firmware)
# PRODUCT_PACKAGES += \
#     SamsungCamera \
#     SamsungGallery

# Audio
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/soundfx,$(TARGET_COPY_OUT_VENDOR)/lib/soundfx) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/soundfx,$(TARGET_COPY_OUT_VENDOR)/lib64/soundfx)

# Display / GPU
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/egl,$(TARGET_COPY_OUT_VENDOR)/lib/egl) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/egl,$(TARGET_COPY_OUT_VENDOR)/lib64/egl)

# Firmware
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/firmware,$(TARGET_COPY_OUT_VENDOR)/firmware)

# HALs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/hw,$(TARGET_COPY_OUT_VENDOR)/lib/hw) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/hw,$(TARGET_COPY_OUT_VENDOR)/lib64/hw)

# Vendor binaries
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/bin,$(TARGET_COPY_OUT_VENDOR)/bin)

# Vendor libraries
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/vendor/lib,$(TARGET_COPY_OUT_VENDOR)/lib) \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/vendor/lib64,$(TARGET_COPY_OUT_VENDOR)/lib64)

# Vendor configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/etc,$(TARGET_COPY_OUT_VENDOR)/etc)

# System libraries (if needed)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/system/lib,$(TARGET_COPY_OUT_SYSTEM)/lib) \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/system/lib64,$(TARGET_COPY_OUT_SYSTEM)/lib64)
