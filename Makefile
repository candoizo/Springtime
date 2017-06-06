GO_EASY_ON_ME = 1
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Springtime
Springtime_FILES = Tweak.xm
Springtime_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	@echo "thanks for installing my tweak ! -@candoizo"
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += springtimeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
