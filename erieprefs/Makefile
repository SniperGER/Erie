SHARED_CFLAGS = -fobjc-arc
CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = erieprefs
erieprefs_FILES = ERRootListController.m
erieprefs_INSTALL_PATH = /Library/PreferenceBundles
erieprefs_FRAMEWORKS = UIKit
erieprefs_PRIVATE_FRAMEWORKS = Preferences
erieprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/erieprefs.plist$(ECHO_END)
