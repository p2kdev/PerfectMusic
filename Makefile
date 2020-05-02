THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard
# INSTALL_TARGET_PROCESSES = Music
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PerfectMusic13
PerfectMusic13_FILES = SLColorArt.m MusicPreferences.mm Colorizer.mm VolumeControl.xm MusicSpringboard-Helper.xm MusicSpringboard.xm MusicApp-Helper.xm MusicApp.xm Init.xm
PerfectMusic13_CFLAGS = -fobjc-arc
PerfectMusic13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk