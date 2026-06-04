#
# Copyright (C) 2024-2026 The Evolution X Project
# SPDX-License-Identifier: Apache-2.0
#
# Vendor product makefile for Samsung Galaxy A23 (SM-A235F)
# Auto-generated from stock vendor.img and odm.img extraction.
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/samsung/a235f

# ============================================================
# Vendor partition blobs
# ============================================================

# Audio HALs and effects
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/soundfx,$(TARGET_COPY_OUT_VENDOR)/lib/soundfx) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/soundfx,$(TARGET_COPY_OUT_VENDOR)/lib64/soundfx)

# Display / GPU (Adreno)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/egl,$(TARGET_COPY_OUT_VENDOR)/lib/egl) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/egl,$(TARGET_COPY_OUT_VENDOR)/lib64/egl)

# Firmware
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/firmware,$(TARGET_COPY_OUT_VENDOR)/firmware)

# Hardware Abstraction Layer modules
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib/hw,$(TARGET_COPY_OUT_VENDOR)/lib/hw) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/lib64/hw,$(TARGET_COPY_OUT_VENDOR)/lib64/hw)

# Vendor binaries
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/bin,$(TARGET_COPY_OUT_VENDOR)/bin)

# Vendor shared libraries (lib + lib64)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/vendor/lib,$(TARGET_COPY_OUT_VENDOR)/lib) \
    $(call find-copy-subdir-files,*.so,$(LOCAL_PATH)/proprietary/vendor/lib64,$(TARGET_COPY_OUT_VENDOR)/lib64)

# Vendor configuration files (includes etc/init, etc/permissions, etc.)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/etc,$(TARGET_COPY_OUT_VENDOR)/etc)

# Vendor apps (APKs)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/vendor/app,$(TARGET_COPY_OUT_VENDOR)/app)

# ============================================================
# ODM partition blobs
# ============================================================

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/odm/etc,$(TARGET_COPY_OUT_ODM)/etc)
