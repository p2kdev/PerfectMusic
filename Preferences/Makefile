ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectMusic13Prefs
PerfectMusic13Prefs_FILES = PMSAppearanceSettings.m PMSRootHeaderView.mm PMSRootListController.xm
PerfectMusic13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectMusic13Prefs_FRAMEWORKS = UIKit
PerfectMusic13Prefs_LIBRARIES += sparkcolourpicker
PerfectMusic13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectMusic13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectMusic13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectMusic13Prefs.plist$(ECHO_END)
