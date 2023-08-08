# https://www.gnu.org/software/make/manual/make.html
all:
	echo "make 默认执行第一个目标"
# 所有最终执行的规则，都以 case、cases 结尾
# 路径分割的目标适用于文件，以点号分割的目标适用于非文件
# 功能复用类
include build.common.mk
include build.elf.mk
include process.mk
# 语法测试类
include element.mk
include phases.mk
include vap.mk
include mrot.mk
include make.debug.mk

