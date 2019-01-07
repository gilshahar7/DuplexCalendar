include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DuplexCalendarPrefs
DuplexCalendarPrefs_FILES = DCPRootListController.m
DuplexCalendarPrefs_INSTALL_PATH = /Library/PreferenceBundles
DuplexCalendarPrefs_FRAMEWORKS = UIKit
DuplexCalendarPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DuplexCalendarPrefs.plist$(ECHO_END)
