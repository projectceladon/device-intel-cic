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

$(call inherit-product,device/intel/cic/common/device.mk)

TARGET_USE_GRALLOC_VHAL := false
TARGET_USE_HWCOMPOSER_VHAL := true
TARGET_AIC_DEVICE_INPUT_FILTER := true
TARGET_AIC_PERF := true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:system/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/vendor/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    device/intel/cic/common/media_codecs.xml:system/vendor/etc/media_codecs.xml \
    device/intel/cic/common/media_codecs_performance.xml:system/vendor/etc/media_codecs_performance.xml \
    device/intel/cic/common/mfx_omxil_core.conf:system/vendor/etc/mfx_omxil_core.conf \
    device/intel/cic/common/media_profiles.xml:system/vendor/etc/media_profiles_V1_0.xml \
    device/intel/cic/cic_dev/init.cic_dev.rc:root/init.cic_dev.rc

PRODUCT_COPY_FILES += \
    device/intel/cic/common/audio/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    device/intel/cic/common/audio/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
    device/intel/cic/common/audio/mixer_paths_0.xml:system/etc/mixer_paths_0.xml \
    device/intel/cic/common/audio/default_volume_tables.xml:system/etc/default_volume_tables.xml \
    device/intel/cic/common/audio/audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml \

ifeq ($(TARGET_USE_GRALLOC_VHAL), true)
PRODUCT_COPY_FILES += \
    vendor/intel/cic/target/graphics/edge/system/vendor/bin/gralloc1_test:system/vendor/bin/gralloc1_test \
    vendor/intel/cic/target/graphics/edge/system/vendor/bin/test_lxc_server:system/vendor/bin/test_lxc_server \
    vendor/intel/cic/target/graphics/edge/system/vendor/bin/test_lxc_client:system/vendor/bin/test_lxc_client \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib/hw/gralloc.intel.so:system/vendor/lib/hw/gralloc.intel.so \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib64/hw/gralloc.intel.so:system/vendor/lib64/hw/gralloc.intel.so \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib/liblxc_util.so:system/vendor/lib/liblxc_util.so \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib64/liblxc_util.so:system/vendor/lib64/liblxc_util.so
endif

PRODUCT_PACKAGES += \
    libGLES_mesa \
    libdrm \
    libdrm_intel \
    audio.primary.$(TARGET_PRODUCT) \
    libsync \
    Browser2 \
    auto_start_apk.sh

ifeq ($(TARGET_USE_INTEL_HWCOMPOSER), true)
PRODUCT_PACKAGES += libva
endif

ifeq ($(TARGET_USE_GRALLOC_VHAL), true)
PRODUCT_PACKAGES += gralloc_imp.intel
else
PRODUCT_PACKAGES += gralloc.intel
endif

ifeq ($(TARGET_USE_HWCOMPOSER_VHAL), true)
PRODUCT_COPY_FILES += \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib/hw/hwcomposer.remote.so:system/vendor/lib/hw/hwcomposer.remote.so \
    vendor/intel/cic/target/graphics/edge/system/vendor/lib64/hw/hwcomposer.remote.so:system/vendor/lib64/hw/hwcomposer.remote.so
else
PRODUCT_PACKAGES += hwcomposer.intel
endif

# Media SDK and OMX IL components
PRODUCT_PACKAGES += \
    libmfxhw32 \
    libmfxhw64 \
    libmfx_omx_core \
    libmfx_omx_components_hw \
	libstagefrighthw

PRODUCT_PACKAGES += \
    i965_drv_video \
    libgrallocclient

PRODUCT_PACKAGES += \
    libva-android \
    libva

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=intel \
    ro.hardware.gralloc_imp=intel \
    ro.opengles.version=196610 \
    service.adb.tcp.port=5555

ifeq ($(TARGET_USE_HWCOMPOSER_VHAL), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.hwcomposer=remote
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.hwcomposer=intel
endif

PRODUCT_NAME := cic_dev
PRODUCT_DEVICE := cic_dev
PRODUCT_BRAND := Intel
PRODUCT_MODEL := CIC container image on edge device
