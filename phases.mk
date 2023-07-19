# https://www.gnu.org/software/make/manual/make.html#Reading-Makefiles
# 此文件演示 make 两阶段处理过程：读取阶段和目标更新阶段
# make phases.case
phases.immediate:=1
phases.deferred=$(phases.immediate)
phases.immediate2:=$(phases.immediate)
phases.immediate:=2
phases.$(phases.immediate2):
	@echo "$@"
phases.$(phases.deferred):
	@echo "$@"
phases.case: phases.$(phases.immediate2) \
	phases.$(phases.deferred)
	@echo "$^"
	@echo "phases.immediate: $(phases.immediate)"
	@echo "phases.immediate2: $(phases.immediate2)"
	@echo "phases.deferred: $(phases.deferred)"
phases.immediate:=3
#分析目标依赖关系及其是否存在，确定如何执行目标的食谱
