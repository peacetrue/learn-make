# https://www.gnu.org/software/make/manual/make.html#Multiple-Rules
#此文件用于演示多个规则使用同一个目标
# Multiple Rules for One Target: mrot

BUILD=build/mrot
#创建源文件
$(BUILD)/empty.c $(BUILD)/empty.cpp: mkdir/$(BUILD)
	echo 'int main() {}' > $@

mrot.recipe1=@echo "1: $^"
mrot.recipe2=@echo "2: $^"

#普通规则：重复定义，后面的食谱覆盖前面的
$(BUILD)/empty.bin: $(BUILD)/empty.c
	$(mrot.recipe1)
$(BUILD)/empty.bin: $(BUILD)/empty.cpp
	$(mrot.recipe2)
mrot.empty.case: $(BUILD)/empty.bin;
# mrot.mk:20: warning: overriding commands for target `build/mrot/empty.bin'
# mrot.mk:17: warning: ignoring old commands for target `build/mrot/empty.bin'
# 2: build/mrot/empty.cpp build/mrot/empty.c

#普通规则-双冒号：重复定义，两者依次执行。使用场景，通过不同的参数运行可执行程序。
$(BUILD)/empty.double.bin:: $(BUILD)/empty.c
	$(mrot.recipe1)
$(BUILD)/empty.double.bin:: $(BUILD)/empty.cpp
	$(mrot.recipe2)
mrot.empty.double.case: $(BUILD)/empty.double.bin;
# cc -o build/mrot/empty.double.bin build/mrot/empty.c
# cc -o build/mrot/empty.double.bin build/mrot/empty.cpp

# 模式规则：重复定义，优先匹配
$(BUILD)/%.pattern.bin: $(BUILD)/%.c
	$(mrot.recipe1)
$(BUILD)/%.pattern.bin: $(BUILD)/%.cpp
	$(mrot.recipe2)
mrot.empty.pattern.case: $(BUILD)/empty.pattern.bin
# 1: build/mrot/custom.empty.c
# rm build/mrot/custom.empty.c
# .SECONDARY:#保留中间过程文件

# 模式规则-双冒号：重复定义，优先匹配
$(BUILD)/%.double.pattern.bin:: $(BUILD)/%.c
	$(mrot.recipe1)
$(BUILD)/%.double.pattern.bin:: $(BUILD)/%.cpp
	$(mrot.recipe2)
mrot.empty.double.pattern.case: $(BUILD)/empty.double.pattern.bin

# 模式规则：循环简写
$(foreach suffix,c cpp,$(eval $$(build)/%.for.bin: $$(build)/%.$(suffix); $$(mrot.recipe2)))
mrot.empty.for.case: $(BUILD)/empty.for.bin

mrot.cases: mrot.empty.case\
	mrot.empty.double.case\
	mrot.empty.pattern.case\
	mrot.empty.double.pattern.case\
	mrot.empty.for.case
