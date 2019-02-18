
#location of the buildroot sources
MAKEARGS := -C $(CURDIR)/buildroot
 
#location to store build files
MAKEARGS += O=$(CURDIR)/output

# location to store extra config options and buildroot packages
MAKEARGS += BR2_EXTERNAL=$(CURDIR)

#transmit project name to be able to use it in kconfig
MAKEARGS += PROJECT_NAME=$(notdir $(CURDIR))

# location of default defconfig
DEFCONFIG_FILE=$(CURDIR)/defconfig
DEFCONFIG := BR2_DEFCONFIG=$(DEFCONFIG_FILE)

# location of default kernel defconfig
KERNELCONFIG_FILE=$(CURDIR)/kernel.defconfig
KERNELCONFIG := BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=\"$(KERNELCONFIG_FILE)\" \
				BR2_LINUX_KERNEL_DEFCONFIG=\"$(KERNELCONFIG_FILE)\"

doxy:
	rm -rf docs ; doxygen doxy.gen 1>/dev/null
	
emu: output/images/bzImage
	qemu-system-i386 -kernel $<
	
output/images/bzImage:
	$(MAKE) build	
	
build: output/.config
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $(KERNELCONFIG) defconfig
	$(MAKE) $(MAKEARGS) $(DEFCONFIG)
	
kernel: buildroot/README
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $(KERNELCONFIG) linux-menuconfig

menu: buildroot/README
	echo $(KERNELCONFIG) >> defconfig
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $(KERNELCONFIG) defconfig menuconfig savedefconfig

buildroot: buildroot/README
buildroot/README:
	git submodule add -b 2018.02.10 https://github.com/buildroot/buildroot.git buildroot

update:
	git pull
	git submodule update
