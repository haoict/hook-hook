ARCHS = arm64 arm64e
TARGET = iphone:clang:12.2:10.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = hookhook
hookhook_FILES = Tweak.xm
hookhook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

