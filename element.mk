# https://www.gnu.org/software/make/manual/make.html#Makefile-Contents
# 此文件用于演示 Makefile 的成分：显式规则、隐式规则、变量定义、指令、注释
# 变量定义
element.variable=variable
# 显示规则，不含先决条件，食谱在下一行；同时演示分割的长行。
element.explicit:
	echo "$(element.variable)"
	echo "$(element.variable) \
	to long to new line"
# empty 为隐式规则，包含先决条件，不含食谱。
element.implicit: empty
#empty: empty.c
#	cc empty.c -o empty

# 显示规则，包含先决条件，食谱在当前行
element.case: element.explicit element.implicit; echo "$(element.variable)1"; echo "$(element.variable)2";
# 指令
include empty.mk
# make element.case
