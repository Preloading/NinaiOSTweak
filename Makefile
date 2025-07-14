TARGET := iphone:clang:latest:2.0

INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS= armv6 armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NINASwitcherforAIM

NINASwitcherforAIM_FILES = Tweak.x
NINASwitcherforAIM_CFLAGS = -Wno-deprecated-declarations -Wno-format -fno-objc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
