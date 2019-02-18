doxy:
	rm -rf docs ; doxygen doxy.gen 1>/dev/null

buildroot: buildroot/README
buildroot/README:
	git submodule add -b 2018.02.10 https://github.com/buildroot/buildroot.git buildroot

update:
	git pull
	git submodule update
