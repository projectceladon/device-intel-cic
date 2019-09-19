CIC release notes

Introduction:
CIC is short for Celadon in Container. The goal of this feature is to put Celadon android images in Docker containers. So that you could deploy the image on Linux devices through Docker tools. And then, you could run Android applications in it.

Version history:
Version 0.5 (CIC P):
CIC Version 0.5 provide an early view of this feature, for pilot and development purpose. Some features, including Trusty, Verified Boot, and OTA update are not included in this version. These features is planned for upcoming releases.

Environment:
Build machine:
The build environment is as same as Celadon project, except for the Docker

Target device:
The recommended target devices are NUC7i7BNH and NUC7i5BNH, most of the Skylake or new generation CPU with integrated GPU should be supported
CIC currently requires Linux kernel version >= 4.14.20, many Linux operating systems are supported, the recommended ones are Clear Linux, Rancher OS and Ubuntu
To simplify the environment, here we use Ubuntu 16.04

Docker:
Both build machine and target device require Docker to be installed, here are the instructions for Ubuntu, refer to the Docker’s official document for details
    sudo apt-get install apt-transport-https ca-certificates curl
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
Verify the Docker by running the hello-world image:
    docker run --rm hello-world

Download source code:
For the master branch (Android Q)
    repo init -u https://github.com/projectceladon/manifest.git -b celadon/master
    repo sync
Or add “-c --no-tags” parameter to download minimal objects
    repo sync -c --no-tags -j8 

For CIC P branch
    repo init -u https://github.com/projectceladon/manifest.git -b celadon/p/mr0/master -m cic
    repo sync
Or add “-c --no-tags” parameter to download minimal objects
    repo sync -c --no-tags -j8 

Build:
For master branch (Android Q), the build target is:
    cic: 
For CIC P branch, here are two build targets:
    cic: target to compliance with Android CDD. Choose this target if SELinux need to be enabled. 
    cic_dev: target for development purpose. Choose this target if Host do not support SELinux. 
Take cic_dev target for example
    source build/envsetup.sh
    lunch cic_dev-userdebug
    make -j cic

The result package will be at $OUT/$TARGET_PRODUCT-*.tar.gz

Deploy:
Download and extract the CIC package to the target device (here we use cic_dev-xxxx.tar.gz for example) and install by the aic script:
    mkdir cic && cd cic
    tar xzf ../cic_dev-xxxx.tar.gz
    ./aic install

Now the CIC is installed, you can launch it with command:
    ./aic start

Wait for a while, there will be a window pops up and you can see the Android is booting up.
You can stop the CIC with command:
    ./aic stop

Or uninstall it with command:
    ./aic uninstall

Tips:
CIC is running as a Docker container, so you can use Docker CLI commands directly for debug purpose. For example, if you encounter some issues, capture necessary information by the commands:
    docker logs aic-manager 2>&1 | tee aic-manager.log
    docker exec -it android0 sh | tee android.log
    getprop
    logcat -b all
