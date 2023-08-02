# https://www.gnu.org/software/make/manual/make.html
all:
	echo "make 默认执行第一个目标"
# 所有最终执行的规则，都以 case 结尾
include element.mk
include phases.mk
include vap.mk
include build.common.mk
include build.elf.mk
include process.mk
include mrot.mk
include debug.mk

