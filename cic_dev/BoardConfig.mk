include device/intel/cic/common/BoardConfig.mk

# framework switches 
TARGET_USES_HWC2 			:= false
USE_OPENGL_RENDERER 		:= true
TARGET_HARDWARE_3D 			:= true

# global switches to use old gfx stack or master gfx stack
TARGET_USE_INTEL_LIBDRM 	:= true
TARGET_USE_INTEL_MESA 		:= true
TARGET_USE_INTEL_GRALLOC	:= true
TARGET_USE_INTEL_HWCOMPOSER	:= false

# cic vhal switches
TARGET_USE_GRALLOC_VHAL     := false
TARGET_USE_HWCOMPOSER_VHAL  := true


# components specific switches
ifeq ($(TARGET_USE_INTEL_LIBDRM), true)
TARGET_USE_PRIVATE_LIBDRM := true
LIBDRM_VER ?= intel
else
TARGET_USE_PRIVATE_LIBDRM := false
endif

BOARD_USE_MESA := true
BOARD_GPU_DRIVERS := i965
BOARD_USES_MINIGBM := true
INTEL_MINIGBM := external/minigbm-intel
BOARD_USES_GRALLOC1 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

ifeq ($(TARGET_USE_INTEL_HWCOMPOSER), true)
BOARD_USES_IA_HWCOMPOSER := true
BOARD_ENABLE_EXPLICIT_SYNC := true
BOARD_CURSOR_WA := true
else
BOARD_USES_IA_HWCOMPOSER := false
BOARD_ENABLE_EXPLICIT_SYNC := false
BOARD_CURSOR_WA := false
endif

TARGET_DONT_USE_NATIVE_FENCE := true

VSYNC_EVENT_PHASE_OFFSET_NS := 7500000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Media
INTEL_VA := true
INTEL_STAGEFRIGHT := true
USE_MEDIASDK := true
BOARD_HAVE_MEDIASDK_OPEN_SOURCE := true

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_TINY_ALSA_AUDIO := true
BOARD_USES_GENERIC_AUDIO ?= false
USE_CUSTOM_PARAMETER_FRAMEWORK := false
ifneq ($(BOARD_USES_GENERIC_AUDIO), true)
# Audio HAL selection Flag default setting.
#  INTEL_AUDIO_HAL:= audio     -> baseline HAL
#  INTEL_AUDIO_HAL:= audio_pfw -> PFW-based HAL
INTEL_AUDIO_HAL := audio
else
INTEL_AUDIO_HAL := stub
endif

# Use XML audio policy configuration file
USE_XML_AUDIO_POLICY_CONF := 1
# Use configurable audio policy
USE_CONFIGURABLE_AUDIO_POLICY := 0

# Use Baseline Legacy Audio HAL
USE_LEGACY_BASELINE_AUDIO_HAL := true
