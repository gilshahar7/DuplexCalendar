FINALPACKAGE = 1
GO_EASY_ON_ME = 1

ARCHS = arm64 armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DuplexCalendar
DuplexCalendar_FILES = Tweak.xm
DuplexCalendar_FRAMEWORKS = CoreTelephony AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += duplexcalendarprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
