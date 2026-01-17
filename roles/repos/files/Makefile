PACKAGES=$(shell cat rpms.snapshot)
RPMS=$(PACKAGES:=.rpm)
PACKAGES_NAMES_ONLY=$(shell cat rpms.names)
.PHONY: download download_latest resolve repo clean
default: repo

download:
	@yumdownloader -x \*i686 --archlist=x86_64,noarch $(PACKAGES)

download_latest:
	@yumdownloader -x \*i686 --archlist=x86_64,noarch $(PACKAGES_NAMES_ONLY)

resolve:
	@../scripts/resolve.sh $(PACKAGES_NAMES_ONLY)

repo:
	@createrepo .

clean:
	@rm -f $(RPMS)
	@rm -rf repodata
	@rm -rf rpms.*