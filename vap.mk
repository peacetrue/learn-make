# 变量作为先决条件：variable as prerequisites
vap.variable:=1
vap.normal.case:
	@echo "$(vap.variable)"

vap.special.case: vap.variable:=2
vap.special.case:
	@echo "$(vap.variable)"

#TODO 只能定义一个变量，如何定义多个变量
#vap.special.case: vap.variable:=2 vap.variable:=2

vap.cases: vap.special.case vap.normal.case
