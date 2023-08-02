# 进程分析
# 获取进程 id。ps -f 选项展示 CMD 全部内容，默认会截断 CMD 名称
proc.pid=ps -a | grep "$(1)" | grep -v "grep" | head -n 1 | awk '{print $$1}' > $(2)
proc.delay=1#程序执行后，等待一定时间，直到操作系统完全启动了该程序，此时再观察其虚拟内存
$(BUILD)/%.pid: $(BUILD)
	sleep $(proc.delay)
	$(call proc.pid,$*,$@)
#	ps -a | grep "$*" | grep -v "grep" | head -n 1 | awk '{print $$1}' > $@
#	ps -af | grep -E "elf.*$*" | head -n 1 | awk '{printf $$2}'
# top 分析内存  -e M
$(BUILD)/%.top: $(BUILD)/%.pid
	top -b -e m -n 1 -p `cat $<` > $@
#$(BUILD)/%.top.humanize: $(BUILD)/%.top
#	cat $< | awk '/java/ {$$5 = $$5 + 10} { print }' > $@
#	cat $< | awk '/java/ {cmd="numfmt --from-unit=K --to=iec-i "; for (i = 5; i <= 7; i++) {cmd_i=cmd $$i; cmd_i | getline $$i; close(cmd_i); } } { if(/PID|java/) print }' | column -t > $@
$(BUILD)/%.pmap: $(BUILD)/%.pid
	$(if $(is_linux),pmap,vmmap) `cat $<` > $@
$(BUILD)/%.maps: $(BUILD)/%.pid
	cat /proc/`cat $<`/maps > $@
# 添加序号表头
$(BUILD)/%.maps.head: $(BUILD)/%.maps
	sed "1i $(shell seq -s ' ' 1 `cat $< | grep heap | head -n 1 | awk '{print NF}'`)" $< | column -t > $@
# 列出 so 文件。例如：/usr/lib/x86_64-linux-gnu/libc.so.6             2.2M
$(BUILD)/%.so.ls: $(BUILD)/%.maps
	cat $< | grep -E '/usr|/root' | awk '{printf "%s\n", $$NF}' | uniq | xargs -I {} ls -lah "{}" | awk '{printf "%s %s\n",$$NF,$$5}' | column -t > $@
# 列出 so 文件。例如：libc.so.6	2.2M
$(BUILD)/%.size: $(BUILD)/%.so.ls
	cat $< | awk -F / '{printf "%s\n", $$NF}' | column -t > $@
stop/%: $(BUILD)/%.pid
	kill -9 `cat $<` | true
maps/%: $(BUILD)/%.maps.head $(BUILD)/%.pmap $(BUILD)/%.top;
#maps/%: $(BUILD)/%.maps stop/%; #lldb 运行中无法 stop
proc.hello.case: LFLAGS=-b -o r
proc.hello.case: ARGS=&
proc.hello.case: proc.delay=3
proc.hello.case: lldb/$(java.def.pkg)/HelloWorld $(BUILD)/java.maps;
proc.clean.case: clean/hello* clean/java*;
#运行+生成+结束：r=run, m=maps, s=stop。
#运行的程序必须能持续一段时间，等到捕捉到 maps；否则可以使用 lldb 调试，使程序阻塞，再手动调用 maps
#$(BUILD)/%.rms: $(BUILD)/%.readobjbin $(BUILD)/%.run $(BUILD)/%$(EXEC_EXTENSION).maps $(BUILD)/%.stop;
# make sleep.rms SUBDIR=/sleep-default-static STATIC=TRUE BACK='&'


EXEC_EXTENSION=.class
run/%: java/def/%;
# 观察虚拟内存
# 进程信息：USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
$(BUILD)/%.ps: java/def/%
	ps aux | grep "bin/java" | grep -v "grep" > $@
# 格式化进程信息中的内存大小。 numfmt --from-unit=K --to=iec-i -z --format=%.1f, 4096 4096
# echo -e "4096\n4096" | awk '{cmd="numfmt --from-unit=K --to=iec-i -z "; printf "%s ", $0; system(cmd $0); printf " "; system(cmd $1); printf "\n"; }'
$(BUILD)/%.ps.humanize: $(BUILD)/%.ps
	cat $< | awk '{cmd="numfmt --from-unit=K --to=iec-i "; printf "%s ", $$2; system(cmd $$5); printf " "; system(cmd $$6); printf "\n"; }' > $@
# 进程编号
$(BUILD)/%.pid: run/%
#	ps -a | grep "java" | grep -v "grep" | head -n 1 | awk '{print $$1}' > $@ # 不使用 -f 选项
	ps -af | grep "$(java_bin)/java" | grep -v "grep" > $@.all
	ps -af | grep "$(java_bin)/java" | grep -v "grep" | head -n 1 | awk '{print $$2}' > $@
#	ps -a | grep "java" | grep -v "grep" | head -n 1 | awk '{print $$1}' > $@


hello.case: run/HelloWorld;

sleep.case: $(BUILD)/Sleep.pmap $(BUILD)/Sleep.maps $(BUILD)/Sleep.top
	sleep 1
#sleep_flags:="java=java ARGS='&'"
sleep_ARGS:="ARGS=&"
sleep_clean:="clean"
sleep_sizes:=10 100 1024
sleep.cases:
	@for size in $(sleep_sizes); do \
	    make $(sleep_clean) sleep.case SUBDIR=/sleep-$${size}M JAVA_OPTS="-Xms$${size}M -Xmx$${size}M" $(sleep_ARGS); \
	done
# 执行 graffle 绘图
graffle_dir:=$(workingDir)/learn-graffle/automation
sleep.graffle.cases:
	@for size in $(sleep_sizes); do \
	    make -C $(graffle_dir) demo-memory.call.case script_argument=$(shell pwd)/$(BUILD)/sleep-$${size}M/sleep.maps; \
    done
