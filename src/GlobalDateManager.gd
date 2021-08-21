extends Node


var GlobalDay=0
var GlobalMonth=0
var GlobalYear=0
var weeksD=0
var monthsD=0
var yearsD=0
var time = OS.get_datetime()
var StartDay =time["day"]+1#
var StartYear =time["year"]#
var StartMonth =time["month"]#
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

var hour := 0.0
