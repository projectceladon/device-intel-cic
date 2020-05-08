# config.mk
#
# Product-specific compile-time definitions.
#

# The generic product target doesn't have any hardware-specific pieces.
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := true
TARGET_CPU_ABI := x86_64
TARGET_ARCH := x86_64
TARGET_ARCH_VARIANT := x86_64
TARGET_PRELINK_MODULE := false

TARGET_2ND_CPU_ABI := x86
TARGET_2ND_ARCH := x86
TARGET_2ND_ARCH_VARIANT := x86

TARGET_USES_64_BIT_BINDER := true

# Enable dex-preoptimization to speed up the first boot sequence
# of an SDK AVD. Note that this operation only works on Linux for now
ifeq ($(HOST_OS),linux)
WITH_DEXPREOPT ?= true
endif

# Container related configurations
ANDROID_AS_GUEST := true

# Build and enable the OpenGL ES View renderer. When running on the emulator,
# the GLES renderer disables itself if host GL acceleration isn't available.
USE_OPENGL_RENDERER := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648 # 2 GB
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 512
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
DEVICE_MATRIX_FILE   := device/intel/cic/common/compatibility_matrix.xml

BOARD_SEPOLICY_DIRS += \
        build/target/board/generic/sepolicy \
        build/target/board/generic_x86/sepolicy

# Wifi.
BOARD_WLAN_DEVICE           := emulator
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_simulated
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_DRIVER_FW_PATH_PARAM   := "/dev/null"
WIFI_DRIVER_FW_PATH_STA     := "/dev/null"
WIFI_DRIVER_FW_PATH_AP      := "/dev/null"

####################### Houdini board config
# Install Native Bridge
WITH_NATIVE_BRIDGE := true

# Enable ARM codegen for x86 with Native Bridge
BUILD_ARM_FOR_X86 := true

# Native Bridge ABI List
NB_ABI_LIST_32_BIT := armeabi-v7a armeabi
NB_ABI_LIST_64_BIT := arm64-v8a

# Support 64 Bit Apps
ifeq ($(ENABLE_NATIVEBRIDGE_64BIT),true)
  TARGET_CPU_ABI_LIST_64_BIT ?= $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2)
  TARGET_CPU_ABI_LIST_32_BIT ?= $(TARGET_2ND_CPU_ABI) $(TARGET_2ND_CPU_ABI2)
  TARGET_CPU_ABI_LIST := \
      $(TARGET_CPU_ABI_LIST_64_BIT) \
      $(TARGET_CPU_ABI_LIST_32_BIT) \
      $(NB_ABI_LIST_32_BIT) \
      $(NB_ABI_LIST_64_BIT)
  TARGET_CPU_ABI_LIST_32_BIT += $(NB_ABI_LIST_32_BIT)
  TARGET_CPU_ABI_LIST_64_BIT += $(NB_ABI_LIST_64_BIT)
else
  TARGET_CPU_ABI_LIST_32_BIT ?= $(TARGET_CPU_ABI) $(TARGET_CPU_ABI2)
  TARGET_CPU_ABI_LIST_32_BIT += $(NB_ABI_LIST_32_BIT)
  TARGET_CPU_ABI_LIST := $(TARGET_CPU_ABI_LIST_32_BIT)
endif

BOARD_HAVE_BLUETOOTH_INTEL_ICNV := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/intel/cic/common/bluetooth/tablet/
DEVICE_PACKAGE_OVERLAYS += device/intel/cic/common/bluetooth/tablet/overlay

BOARD_SEPOLICY_DIRS += device/intel/cic/common/sepolicy
BOARD_SEPOLICY_DIRS += device/intel/cic/common/sepolicy/bluetooth
BOARD_SEPOLICY_DIRS += device/intel/cic/common/sepolicy/camera-ext
