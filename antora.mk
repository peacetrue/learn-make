# Antora 文档案例
antora_dir=docs/antora/modules/ROOT/pages
$(antora_dir)/manual.adoc:
	touch $@
manual.adoc.case: $(antora_dir)/manual.adoc
	make -h > $<
	sed -i '1s/^/= 用户手册\n\n.make -h\n----\n/' $<
	echo '----' >> $<
