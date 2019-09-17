PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.crashlogd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.crashlogd.rc \
	$(call add-to-product-copy-files-if-exists,$(LOCAL_PATH)/ingredients.conf:$(TARGET_COPY_OUT_VENDOR)/etc/ingredients.conf) \
	$(call add-to-product-copy-files-if-exists,$(LOCAL_PATH)/crashlog.conf:$(TARGET_COPY_OUT_VENDOR)/etc/crashlog.conf)

PRODUCT_PACKAGES += crashlogd \
	dumpstate_dropbox.sh


PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.crashlogd.data_quota=50

CRASHLOGD_LOGS_PATH := "/data/logs"
CRASHLOGD_APLOG := true
CRASHLOGD_FULL_REPORT := true

#binder
CRASHLOGD_MODULE_BINDER := true

CRASHLOGD_USE_SD := false

#ssram_crashlog}}
#CRASHLOGD_SSRAM_CRASHLOG := {{{ssram_crashlog}}}

#ramdump}}
#CRASHLOGD_RAMDUMP := {{{ramdump}}}

