extends Node

signal date_time_changed

var GlobalDay=0 setget _set_GlobalDay  # Displayed day
var GlobalMonth=0 setget _set_GlobalMonth   # Displayed month
var GlobalYear=0  setget _set_GlobalYear  # Displayed year
var weeksD=0
var monthsD=0
var yearsD=0
var time = OS.get_datetime()
var StartDay =10+1
var StartMonth =6
var StartYear =2021#
var OriginalDay =10
var OriginalMonth =6
var OriginalYear =2021#
var DaysInMonth=0
var TimeButtonDisplay1=0
var CautionLevel1=0
var TimeButtonDisplay2=0
var CautionLevel2=0
var TimeButtonDisplay3=0
var CautionLevel3=0
var TimeButtonDisplay4=0
var CautionLevel4=0
var TimeButtonDisplay5=0
var CautionLevel5=0
var TimeButtonDisplay6=0
var CautionLevel6=0
var TimeButtonDisplay7=0
var CautionLevel7=0
var ArrowButtonsClicked=-0
var ArrowFirstClick=1
var ButtonClickedLimit=0
var MonthName1=""
var MonthName2=""
#I'll use this to dettermine the weeks away the display date is from the current date :p

var hour := 0.0 setget _set_hour


func _set_GlobalDay(value: int) -> void:
	GlobalDay = value
	emit_signal("date_time_changed")


func _set_GlobalMonth(value: int) -> void:
	GlobalMonth = value
	emit_signal("date_time_changed")


func _set_GlobalYear(value: int) -> void:
	GlobalYear = value
	emit_signal("date_time_changed")


func _set_hour(value: float) -> void:
	hour = value
	emit_signal("date_time_changed")
