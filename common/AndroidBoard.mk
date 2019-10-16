ifeq ($(TARGET_UEFI_ARCH),i386)
efi_default_name := bootia32.efi
LOADER_TYPE := linux-x86
else
efi_default_name := bootx64.efi
LOADER_TYPE := linux-x86_64
endif

.PHONY: multidroid
multidroid: droid kf4cic-$(TARGET_BUILD_VARIANT)
	@echo Make multidroid image...
	$(hide) rm -rf $(PRODUCT_OUT)/docker
	$(hide) mkdir -p $(PRODUCT_OUT)/docker/android/root
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/aic-manager $(PRODUCT_OUT)/docker
	$(hide) cp -r $(TOP)/kernel/modules/cic/ashmem $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/kernel/modules/cic/binder $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/kernel/modules/cic/mac80211_hwsim $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/android $(PRODUCT_OUT)/docker
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/update $(PRODUCT_OUT)/docker
	$(hide) cp $(TOP)/vendor/intel/cic/host/docker/scripts/aic $(PRODUCT_OUT)
	$(hide) cp -r $(PRODUCT_OUT)/efi/kf4cic.efi $(PRODUCT_OUT)/kf4cic.efi
ifneq ($(TARGET_LOOP_MOUNT_SYSTEM_IMAGES), true)
	$(hide) cp -r $(PRODUCT_OUT)/system $(PRODUCT_OUT)/docker/android/root
	$(hide) cp -r $(PRODUCT_OUT)/root/* $(PRODUCT_OUT)/docker/android/root
	$(hide) rm -f $(PRODUCT_OUT)/docker/android/root/etc
	$(hide) cp -r $(PRODUCT_OUT)/system/etc $(PRODUCT_OUT)/docker/android/root
	$(hide) chmod -R g-w $(PRODUCT_OUT)/docker/android/root
else
	$(hide) zcat $(PRODUCT_OUT)/ramdisk.img | (cd $(PRODUCT_OUT)/docker/android/root && cpio -idm)
	$(hide) rm -rf $(PRODUCT_OUT)/docker/android/root/etc
	$(hide) cp -r $(PRODUCT_OUT)/system/etc $(PRODUCT_OUT)/docker/android/root
	$(hide) rm -rf $(PRODUCT_OUT)/docker/aic-manager/images
	$(hide) mkdir -p $(PRODUCT_OUT)/docker/aic-manager/images
	$(hide) ln -t $(PRODUCT_OUT)/docker/aic-manager/images $(PRODUCT_OUT)/system.img
endif

TARGET_AIC_FILE_NAME := $(TARGET_PRODUCT)-aic-$(BUILD_NUMBER).tar.gz

.PHONY: aic
aic: .KATI_NINJA_POOL := console
aic: multidroid
	@echo Make AIC docker images...
ifneq ($(TARGET_LOOP_MOUNT_SYSTEM_IMAGES), true)
	$(HOST_OUT_EXECUTABLES)/aic-build -b $(BUILD_NUMBER)
else
	BUILD_VARIANT=loop_mount $(HOST_OUT_EXECUTABLES)/aic-build -b $(BUILD_NUMBER)
endif
	tar cvzf $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) -C $(PRODUCT_OUT) aic android.tar.gz aic-manager.tar.gz kf4cic.efi -C docker update

.PHONY: cic
cic: aic

.PHONY: publish_ci
publish_ci: aic
	@echo Publish CI AIC docker images...
	$(hide) mkdir -p $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)

# Following 1A CI practice, "publish" is used by buildbot for "latest", "release", etc. Without this
# target, the build will fail on related buildbot.
# Currently, the "publish" and "publish_ci" are the same. But they may be different in the future.
.PHONY: publish
publish: aic
	@echo Publish AIC docker images...
	$(hide) mkdir -p $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
