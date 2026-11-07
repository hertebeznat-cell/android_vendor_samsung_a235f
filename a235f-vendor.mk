#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# The vendor partition is the untouched SEZB1 image (BoardConfigVendor.mk).
# odm is built from the stock SEZB1 odm files plus additions the AOSP
# framework needs (bluetooth-audio).
#

A235F_VENDOR_PATH := vendor/samsung/a235f

# Stock SEZB1 odm: SKU NFC permissions and VINTF manifests, media profiles,
# and /vendor/ueventd.rc (Android 11 location) as /odm/etc/ueventd.rc, which
# ueventd imports.
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(A235F_VENDOR_PATH)/proprietary/odm,$(TARGET_COPY_OUT_ODM))

# AOSP Bluetooth Audio HAL 2.0 for A2DP (stock vendor only has Samsung's).
PRODUCT_PACKAGES += \
    a235f_android.hardware.bluetooth.audio@2.0-impl \
    a235f_audio.bluetooth.default \
    a235f_libbluetooth_audio_session

