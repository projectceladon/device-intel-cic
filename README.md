# CIC

## Introduction

CIC is short for [Celadon](https://01.org/projectceladon) in Container. The goal of this feature is to put [Celadon](https://01.org/projectceladon) [Android](https://www.android.com/) images in [Docker](https://www.docker.com/) containers. So that you could deploy the image on Linux devices through [Docker](https://www.docker.com/) tools. And then, you could run Android applications in it.

## Version history

### v0.5

CIC version 0.5 provide an early view of this feature, for pilot and development purpose. Some features, including Trusty, Verified Boot, and OTA update are not included in this version. These features is planned for upcoming releases.

## Environment

### Build machine

The build environment is as same as [Celadon](https://01.org/projectceladon) project, except for the [Docker](https://www.docker.com/)

### Target device

The recommended target devices are **NUC7i7BNH** and **NUC7i5BNH**, most of the Skylake or new generation CPU with integrated GPU should be supported

CIC currently requires Linux kernel version **>= 4.14.20**, many Linux operating systems are supported, the recommended ones are [Clear Linux](https://clearlinux.org/), [Rancher OS](https://rancher.com/rancher-os/) and [Ubuntu](https://ubuntu.com/)

To simplify the environment, here we use [Ubuntu 16.04](http://releases.ubuntu.com/xenial/)

### Docker

Both build machine and target device require [Docker](https://www.docker.com/) to be installed, here are the instructions for [Ubuntu](https://ubuntu.com/), refer to the [Docker official document](https://docs.docker.com/install/) for details

    $ sudo apt-get install apt-transport-https ca-certificates curl
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    $ sudo usermod -aG docker $USER

Verify the [Docker](https://www.docker.com/) by running the `hello-world` image:

    $ docker run --rm hello-world

## Download source code

For the master branch ([Android](https://www.android.com/) Q)

    $ repo init -u https://github.com/projectceladon/manifest.git -b celadon/master
    $ repo sync -c --no-tags -j4

For [Android](https://www.android.com/) P branch

    $ repo init -u https://github.com/projectceladon/manifest.git -b celadon/p/mr0/master -m cic
    $ repo sync -c --no-tags -j4

## Build

### Build targets

There are two build targets:

* **cic**: target to compliance with [Android CDD](https://source.android.com/compatibility/cdd). Choose this one if [SELinux](https://github.com/SELinuxProject) is required. 
* **cic_dev**: for development purpose. Choose this one if the host OS does not support [SELinux](https://github.com/SELinuxProject).

> **CAUTION**: **cic_dev** is only available on Android P branch currently

Take cic_dev target for example

    $ source build/envsetup.sh
    $ lunch cic_dev-userdebug
    $ make -j cic

The result package will be at `$OUT/$TARGET_PRODUCT-*.tar.gz`

## Deploy

Download and extract the CIC package to the target device (here we use `cic_dev-xxxx.tar.gz` for example) and install by the `aic` script:

    $ mkdir cic && cd cic
    $ tar xzf ../cic_dev-xxxx.tar.gz
    $ ./aic install

Now the CIC is installed, you can launch it with command:

    $ ./aic start

Wait for a while, there will be a window pops up and you can see the [Android](https://www.android.com/) is booting up.

You can stop the CIC with command:

    $ ./aic stop

Or uninstall it with command:

    $ ./aic uninstall

## SELinux

If [SELinux](https://github.com/SELinuxProject) is required, you need to build you own kernel with following patch:

```patch
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 2380b8d..fc07e55 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -979,6 +979,10 @@ static noinline int avc_denied(u32 ssid, u32 tsid,
 				u8 driver, u8 xperm, unsigned flags,
 				struct av_decision *avd)
 {
+	if (ssid == SECINITSID_KERNEL) {
+		avd->allowed = 0xffffffff;
+		return 0;
+	}
 	if (flags & AVC_STRICT)
 		return -EACCES;
```

## Tips

CIC is running as a [Docker](https://www.docker.com/) container, so you can use [Docker](https://www.docker.com/) CLI commands directly for debug purpose. For example, if you encounter some issues, capture necessary information by the commands:

    $ docker logs aic-manager 2>&1 | tee aic-manager.log
    $ docker exec -it android0 sh | tee android.log
    # getprop
    # logcat -b all

## See also

* [Celadon](https://01.org/projectceladon)
* [Android](https://www.android.com/)
* [Docker](https://www.docker.com/)
