export THEOS_DEVICE_IP=Janiks-iPhone.local
export THEOS_DEVICE_PORT=22
export SDKROOT=iphoneos
export SYSROOT=$(THEOS)/sdks/iPhoneOS11.2.sdk

export PACKAGE_VERSION=0.7
export ARCHS = arm64
TARGET=iphone:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Erie
Erie_FILES = Tweak.xm

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

ifeq ($(THEOS_TARGET_NAME),iphone)
Erie_SUBPROJECTS = erieprefs
endif


include $(THEOS_MAKE_PATH)/aggregate.mk
