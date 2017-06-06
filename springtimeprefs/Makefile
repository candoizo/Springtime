TARGET = iphone:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = springtimeprefs
springtimeprefs_FILES = springtimeprefs.mm
springtimeprefs_INSTALL_PATH = /Library/PreferenceBundles
springtimeprefs_FRAMEWORKS = UIKit Social CoreGraphics
springtimeprefs_PRIVATE_FRAMEWORKS = Preferences
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/springtimeprefs.plist$(ECHO_END)
