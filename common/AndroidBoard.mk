.PHONY: multidroid
multidroid: droid addon
	@echo Make multidroid image...
	$(hide) rm -rf $(PRODUCT_OUT)/docker
	$(hide) mkdir -p $(PRODUCT_OUT)/docker/android/root
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/aic-manager $(PRODUCT_OUT)/docker
	$(hide) mkdir -p $(PRODUCT_OUT)/docker/aic-manager/data
	$(hide) cp -r $(TOP)/kernel/modules/cic/ashmem $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/kernel/modules/cic/binder $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/kernel/modules/cic/mac80211_hwsim $(PRODUCT_OUT)/docker/aic-manager/data/
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/android $(PRODUCT_OUT)/docker
	$(hide) cp -r $(TOP)/vendor/intel/cic/host/docker/update $(PRODUCT_OUT)/docker
	$(hide) cp $(TOP)/vendor/intel/cic/host/docker/scripts/aic $(PRODUCT_OUT)
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

.PHONY: addon
addon: 
ifeq ($(TARGET_PRODUCT), cic_dev)
	@echo Make additional release binaries/files...
	$(hide) rm -rf $(PRODUCT_OUT)/cfc $(PRODUCT_OUT)/pre-requisites  $(PRODUCT_OUT)/README-CIC  $(PRODUCT_OUT)/ia_hwc $(PRODUCT_OUT)/setup-aic
	$(hide) cp -r $(TOP)/device/intel/cic/$(TARGET_PRODUCT)/addon/* $(TOP)/vendor/intel/cic/host/cfc $(TOP)/vendor/intel/cic/target/graphics/ia_hwc $(PRODUCT_OUT)/.
	$(hide) cp $(TOP)/device/intel/cic/cic_dev/addon/cic.sh $(PRODUCT_OUT)
else
	@echo Nothing todo
endif

.PHONY: aic
aic: .KATI_NINJA_POOL := console
aic: multidroid
	@echo Make AIC docker images...
ifneq ($(TARGET_LOOP_MOUNT_SYSTEM_IMAGES), true)
	$(HOST_OUT_EXECUTABLES)/aic-build -b $(BUILD_NUMBER)
else
	BUILD_VARIANT=loop_mount $(HOST_OUT_EXECUTABLES)/aic-build -b $(BUILD_NUMBER)
endif
ifeq ($(TARGET_PRODUCT), cic_dev)
	tar cvzf $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) -C $(PRODUCT_OUT) aic android.tar.gz aic-manager.tar.gz cfc ia_hwc pre-requisites README-CIC cic.sh setup-aic -C docker update
	@echo Make debian binaries...
	$(hide) (rm -rf $(PRODUCT_OUT)/cic && mkdir -p $(PRODUCT_OUT)/cic/opt/cic && mkdir -p $(PRODUCT_OUT)/cic/etc/profile.d)
	$(hide) (cd $(PRODUCT_OUT)/cic/opt/cic && tar xvf ../../../$(TARGET_AIC_FILE_NAME) aic android.tar.gz aic-manager.tar.gz cic.sh cfc update)
	$(hide) mkdir -p $(PRODUCT_OUT)/cic/DEBIAN
	$(hide) cp -r device/intel/cic/$(TARGET_PRODUCT)/addon/debian/* $(PRODUCT_OUT)/cic/DEBIAN/.
	$(hide) cp -r device/intel/cic/$(TARGET_PRODUCT)/addon/pre-requisites/create_pasocket.sh $(PRODUCT_OUT)/cic/etc/profile.d
	$(hide) dpkg -x $(PRODUCT_OUT)/cfc/cfc_0.1.0_x64.deb $(PRODUCT_OUT)/cic/.
	$(hide) (cd $(PRODUCT_OUT)/ && dpkg-deb --build cic/)
else
	tar cvzf $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) -C $(PRODUCT_OUT) aic android.tar.gz aic-manager.tar.gz -C docker update
endif

.PHONY: cic
cic: aic

.PHONY: publish_ci
publish_ci: aic
	@echo Publish CI AIC docker images...
	$(hide) mkdir -p $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/cic.deb $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)

# Following 1A CI practice, "publish" is used by buildbot for "latest", "release", etc. Without this
# target, the build will fail on related buildbot.
# Currently, the "publish" and "publish_ci" are the same. But they may be different in the future.
.PHONY: publish
publish: aic
	@echo Publish AIC docker images...
	$(hide) mkdir -p $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/$(TARGET_AIC_FILE_NAME) $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
	$(hide) cp $(PRODUCT_OUT)/cic.deb $(TOP)/pub/$(TARGET_PRODUCT)/$(TARGET_BUILD_VARIANT)
