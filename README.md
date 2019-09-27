# CIC

## Introduction

The goal of [Celadon](https://01.org/projectceladon) in Container (**CIC**) feature is to run the [Celadon](https://01.org/projectceladon) [Android](https://www.android.com/) image in a [Docker](https://www.docker.com/) container, so that you can run the image on Linux devices through [Docker](https://www.docker.com/) tools, and run [Android](https://www.android.com/) applications in it.

## Version history

### v0.5

CIC version 0.5 provides a preview of the feature for pilot and development purposes. Some features such as Trusty, Verified Boot, and OTA update are not included in this preview version. Those features are planned for the upcoming releases.

## Environment

### Build machine

The build environment is as same as [Celadon](https://01.org/projectceladon/documentation/getting_started/build-source#set-up-the-development-environment), except for the [Docker](https://www.docker.com/)

### Target device

CIC should be able to run on modern PCs with Intel® 6th generation or later processors with integrated GPU. The Intel NUC model **NUC7i7BNH** and model **NUC7i5BNH** are recommended to try out the CIC features.

CIC currently requires Linux kernel version **4.14.20** or later, which is available in most Linux distributions such as [Clear Linux](https://clearlinux.org/), [Rancher OS](https://rancher.com/rancher-os/) and [Ubuntu](https://ubuntu.com/), etc.

The current instructions are based on [Ubuntu 16.04](http://releases.ubuntu.com/xenial/)

### Docker

Both build machine and target device require [Docker](https://www.docker.com/) to be installed, here are the instructions for [Ubuntu](https://ubuntu.com/), refer to the [Docker official document](https://docs.docker.com/install/) for details

    $ sudo apt-get install apt-transport-https ca-certificates curl
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install -y docker-ce docker-ce-cli containerd.io

If you would like to use [Docker](https://www.docker.com/) as a non-root user:

    $ sudo usermod -aG docker $USER

Remember to log out and back in for this to take effect!

Verify that the [Docker](https://www.docker.com/) is installed correctly by running the `hello-world` image:

    $ docker run --rm hello-world

## Download source code

    $ repo init -u https://github.com/projectceladon/manifest.git -b celadon/p/mr0/master -m cic
    $ repo sync --no-tags

## Build

### Build targets

There are two build targets:

* **cic**: target to compliant with [Android CDD](https://source.android.com/compatibility/cdd). Choose this one if [SELinux](https://github.com/SELinuxProject) is required.
* **cic_dev**: for development purpose. Choose this one if the host OS does not support [SELinux](https://github.com/SELinuxProject).

Take **cic_dev** target for example

    $ source build/envsetup.sh
    $ lunch cic_dev-userdebug
    $ make -j cic

The result package will be at `$OUT/$TARGET_PRODUCT-*.tar.gz`

## Deploy

Download and extract the CIC package to the target device (here we use `cic_dev-xxxx.tar.gz` for example) and install it by the `aic` script:

    $ tar xzf ../cic_dev-xxxx.tar.gz
    $ ./aic install

Now the CIC is installed, you can launch it with command:

    $ ./aic start

A window will be pop-up showing [Android](https://www.android.com/) is booting after the CIC container is initialized and running.

You can stop the CIC with command:

    $ ./aic stop

Or uninstall it with:

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

CIC runs as a [Docker](https://www.docker.com/) container, so you can use [Docker CLI commands](https://docs.docker.com/engine/reference/commandline/cli) directly for debugging. For example, if you encounter some issues, capture necessary information by the following commands:

    $ docker logs aic-manager 2>&1 | tee aic-manager.log
    $ docker exec -it android0 sh | tee android.log
    # getprop
    # logcat -b all

## See also

* [Celadon](https://01.org/projectceladon)
* [Android](https://www.android.com/)
* [Docker](https://www.docker.com/)
