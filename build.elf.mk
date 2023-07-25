# 构建 ELF 文件：预处理、汇编、编译、链接
CFLAGS+=-g #生成调试信息
# 从 C 源码编译
$(BUILD)/%.bin: c/%.c $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<
