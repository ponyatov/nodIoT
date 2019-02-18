
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

doxy:
	rm -rf docs ; doxygen doxy.gen 1>/dev/null

menu: buildroot/README
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) menuconfig

buildroot: buildroot/README
buildroot/README:
	git submodule add -b 2018.02.10 https://github.com/buildroot/buildroot.git buildroot

update:
	git pull
	git submodule update
