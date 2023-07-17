# https://www.gnu.org/software/make/manual/make.html
all:
	echo 'make 默认执行第一个目标'


include element.mk
include phases.mk

# Antora 文档案例
antora_dir=docs/antora/modules/ROOT/pages
$(antora_dir)/manual.adoc:
	touch $@
manual.adoc.case: $(antora_dir)/manual.adoc
	make -h > $<
	sed -i '1s/^/= 用户手册\n\n----\n/' $<
	echo '----' >> $<

