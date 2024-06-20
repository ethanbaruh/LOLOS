# LOLOS
Operating System for Raspberry PI 3b emulated using QEMU

# Setup

## Initial Setup with QEMU and Rasberry Pi OS

In order to ensure that QEMU will run properly on the system you can start by trying to run Raspberry PI OS using QEMU emulation. QEMU should already be installed, you can check this using `qemu-system-aarch64 --version` which should run successfully. 

### Downloading Raspberry PI OS

The image of the raspberry pi os is excluded from the git repo as it is quite a large file however it can be downloaded using `wget https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz` and then decompressed using `xz -d 2023-05-03-raspios-bullseye-arm64.img.xz`. From the downloaded image you should extract the `kernel8.img` and `bcm2710-rpi-3-b-plus.dtb` files. I found the easiest way to do this on macOS was to mount the image using DiskImageMounter for Mac then manually copy the files into your working directory. 

Before emulating the image it must be resized to be an even multiple of 2. To do this you can run `qemu-img resize ./2023-05-03-raspios-bullseye-arm64.img 8G`. 

> **Note:**
>
> Before doing this, ensure that you have unmounted the image, otherwise you will get an error staing that byte 100 of the image is locked.

### Running QEMU

QEMU has a built in emulation for different models of raspberry pi. This makes it very easy to use, in order to emulate the kernel image we can run 

``` 
qemu-system-aarch64 -machine raspi3b -cpu cortex-a72 \  
-nographic -dtb bcm2710-rpi-3-b-plus.dtb -m 1024 -smp 4 -kernel kernel8.img \    
-sd 2023-05-03-raspios-bullseye-arm64.img -append "rw earlyprintk loglevel=8 \    
console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1"
```

This line is also in the makefile under the target `raspiOS` so you can also run `make raspiOS`. Note that it will take a couple of seconds to load the OS and get to the shell.