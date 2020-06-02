THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

# INSTALL_TARGET_PROCESSES = SpringBoard
INSTALL_TARGET_PROCESSES = Music Preferences
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PerfectMusic13
PerfectMusic13_FILES = SLColorArt.m MusicPreferences.mm Colorizer.xm VolumeControl.xm ExtraPlaybackButtons.xm MediaNotification.xm MusicSpringboard-Helper.xm MusicSpringboard.xm MusicApp-Helper.xm MusicApp.xm Init.xm
PerfectMusic13_CFLAGS = -fobjc-arc -Wno-logical-op-parentheses
PerfectMusic13_EXTRA_FRAMEWORKS += Cephei
PerfectMusic13_LIBRARIES += sparkcolourpicker
PerfectMusic13_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk