# https://www.gnu.org/software/make/manual/make.html#Makefile-Contents
# 此文件用于演示 Makefile 的构成部件：显式规则、隐式规则、变量定义、指令、注释
# make element.case
# 变量定义
element.variable=variable
# 显示规则，不含先决条件，食谱在下一行；同时演示分割的长行。
element.explicit:;echo "element.explicit"
# 包含先决条件，不含食谱。element.o 为隐式规则
element.implicit: element.o;
#element.o: element.c
#	cc -c -o element.o element.c
# TODO 隐式规则如果不能和源文件目录和目标文件目录配合，如何实际应用？
# %.c: $(src)/%.c;
# %.o: $(build)/%.o;

# 条件指令
element.condition:
ifeq ($(element.variable),variable)
	echo "element.variable is original value"
else
	echo "element.variable is changed"
endif

# 显示规则，包含先决条件和食谱
element.case: element.explicit \
element.implicit element.condition
	echo "$(element.variable)1"
	echo "$(element.variable)2"
