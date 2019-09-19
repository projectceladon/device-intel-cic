PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.logs.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.logs.rc

PRODUCT_PACKAGES += \
    elogs.sh \
    start_log_srv.sh \
    logcat_ep.sh

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.service.default_logfs=apklogfs
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.intel.logger=/system/bin/logcat
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += logd.kernel.raw_message=false
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.intel.logger.rot_cnt=20
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += persist.intel.logger.rot_size=5000
