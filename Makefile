include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Hankana
Hankana_FILES = Tweak.xm
Hankana_FRAMEWORKS = CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
