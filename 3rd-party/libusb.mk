PACKAGE := $(wildcard libusb-*.tar.bz2)
SRCDIR := $(PACKAGE:.tar.bz2=)
BUILDDIR := $(SRCDIR)-build
ROOTDIR := $(shell readlink -m "$(SRCDIR)")-root
#DIR := $(shell find . -type d -name libusb-\*)

CPU := x86_64
ifeq '$(CPU)' 'x86_64'
BITS := 64
else
BITS := 32
endif
export CC := $(CC) -m$(BITS)

HOST := $(CPU)-linux-gnu

BUILDDIR := $(BUILDDIR)-$(CPU)
ROOTDIR := $(ROOTDIR)-$(CPU)

all: build

unpack: $(SRCDIR)

$(SRCDIR): $(PACKAGE)
	tar -xvf $(PACKAGE)

build: libusb-root-$(CPU)

libusb-root-$(CPU): $(SRCDIR)
	mkdir -p $(BUILDDIR)
	cd $(BUILDDIR) && ../$(SRCDIR)/configure --disable-timerfd --disable-udev --disable-shared --host=$(HOST) --prefix=$(ROOTDIR)
	make -C $(BUILDDIR) install
	ln -snf $(ROOTDIR) libusb-root-$(CPU)
	$(RM) -r $(SRCDIR) $(BUILDDIR)

clean:
	$(RM) -r $(SRCDIR) $(BUILDDIR) $(ROOTDIR)

.PHONY: all unpack build clean
