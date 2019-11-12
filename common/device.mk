# Copyright (C) 2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Houdini support
TARGET_SUPPORTS_64_BIT_APPS := true
$(call inherit-product, device/intel/cic/common/houdini.mk)

PRODUCT_PACKAGES += libhoudini Houdini
PRODUCT_PROPERTY_OVERRIDES += ro.dalvik.vm.isa.arm=x86 ro.enable.native.bridge.exec=1

ENABLE_NATIVEBRIDGE_64BIT := false
ifeq ($(BOARD_USE_64BIT_USERSPACE),true)
  ENABLE_NATIVEBRIDGE_64BIT = true
else
  ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
    ENABLE_NATIVEBRIDGE_64BIT = true
  endif
endif
ifeq ($(ENABLE_NATIVEBRIDGE_64BIT),true)
  PRODUCT_PACKAGES += houdini64
  PRODUCT_PROPERTY_OVERRIDES += ro.dalvik.vm.isa.arm64=x86_64 ro.enable.native.bridge.exec64=1
endif
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.dalvik.vm.native.bridge=libhoudini.so

# Crashlog support
# Available options: on/off
OPTION_CRASHLOGD := on
$(call inherit-product, $(LOCAL_PATH)/options/debug-logs/$(OPTION_CRASHLOGD)/product.mk)
$(call inherit-product, $(LOCAL_PATH)/options/debug-crashlogd/$(OPTION_CRASHLOGD)/product.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/board/generic_x86_64/device.mk)

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG := normal large xlarge mdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi

DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/vendor/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/vendor/etc/media_codecs_google_video.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml   \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
    $(LOCAL_PATH)/android-removed-permissions.xml:system/etc/permissions/android-removed-permissions.xml \
    $(if $(wildcard device/intel/cic/$(TARGET_PRODUCT)/fstab.$(TARGET_PRODUCT)),device/intel/cic/$(TARGET_PRODUCT)/fstab.$(TARGET_PRODUCT),$(LOCAL_PATH)/fstab.base):root/fstab.$(TARGET_PRODUCT) \
    device/intel/cic/common/init.base.rc:root/init.base.rc \
    $(if $(wildcard device/intel/cic/$(TARGET_PRODUCT)/init.$(TARGET_PRODUCT).usb.rc),device/intel/cic/$(TARGET_PRODUCT)/init.$(TARGET_PRODUCT).usb.rc,$(LOCAL_PATH)/init.base.usb.rc):root/init.$(TARGET_PRODUCT).usb.rc \
    $(if $(wildcard device/intel/cic/$(TARGET_PRODUCT)/ueventd.$(TARGET_PRODUCT).rc),device/intel/cic/$(TARGET_PRODUCT)/ueventd.$(TARGET_PRODUCT).rc,$(LOCAL_PATH)/ueventd.base.rc):root/ueventd.$(TARGET_PRODUCT).rc \
    device/intel/cic/common/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml \

PRODUCT_PACKAGES += \
    egl.cfg \
    lib_renderControl_enc \
    libGLESv2_enc \
    libOpenglSystemCommon \
    libGLESv1_enc \
    bios.bin \
    vgabios-cirrus.bin \
    docker \
    cpio \
    aic-build

# Device modules
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.wifi@1.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    hwcomposer.goldfish \
    hwcomposer.ranchu \
    sh_vendor \
    vintf \
    toybox_vendor \
    CarrierConfig

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.broadcastradio@1.0-impl \
    android.hardware.soundtrigger@2.0-impl

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-strongbox-service

PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.0-impl

# WiFi
PRODUCT_PACKAGES += \
    wpa_supplicant \
    hostapd
PRODUCT_COPY_FILES += \
    device/intel/cic/common/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    device/intel/cic/common/wifi/WifiConfigStore.xml:data/misc/wifi/WifiConfigStore.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# need this for gles libraries to load properly
# after moving to /vendor/lib/
PRODUCT_PACKAGES += \
    vndk-sp

# camera support
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-external-service
PRODUCT_COPY_FILES += \
    device/intel/cic/common/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

# sdcard
PRODUCT_COPY_FILES += \
    out/target/product/$(TARGET_PRODUCT)/system/bin/sdcard-fuse:system/bin/sdcard

PRODUCT_PACKAGES += \
    sdcard-fuse

# Bluetooth tools
PRODUCT_PACKAGES += \
    hciconfig \

# Bluetooth tools eng / userdebug
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    hcitool
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service.vbt \
    libbt-vendor

PRODUCT_PACKAGE_OVERLAYS += device/intel/cic/common/bluetooth/tablet/overlay
