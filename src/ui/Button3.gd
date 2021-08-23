extends Button

var Icon_grey=preload("res://calender_grey.png")
var Icon_Green=preload("res://calender_green.png")
var Icon_Yellow=preload("res://calender_yellow.png")
var Icon_Orange=preload("res://calender_orange.png")
var Icon_Red=preload("res://calender_red.png")
var Icon_Really_Red=preload("res://calender_really_red.png")
func updateColourLeft():
	var difference=-5#Makes it go back 6 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day<1:#checks if the day is in the day is in the same month
		month=month-1#if it's not it goes back a month 
		if month<1:#this checks if the month is in the same year
			year=year-1#this goes back a year 
			month=12#this sends the date to december (the last month)
			day=day+31#this restores the date 
		else:#if the month is in the year
			GetDaysInMonth(month)#it gets the amount of days are in the month
			day=day+GlobalDate.DaysInMonth#and adds them to restore the date
	if year>=GlobalDate.LowerYear:#checks if the year is in range of the minium date
		if month>=GlobalDate.LowerMonth:#checks if the month is in range of the minium date
			if day>=GlobalDate.LowerDay:#checks if the month is in the range of the minium date
				randomize()
				GlobalDate.CautionLevel3=int(rand_range(1,5))
			else:
				GlobalDate.CautionLevel3=0
		else:
			GlobalDate.CautionLevel3=0
	else:
		GlobalDate.CautionLevel3=0
	Change_colour()

func UpdateColourRight():
	var difference=-5#Makes it go back 5 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	GetDaysInMonth(month)
	if day>GlobalDate.DaysInMonth:
		month=month-1
		if month<1:
			year=year-1
			month=12
		GetDaysInMonth(month)
		day=day-GlobalDate.DaysInMonth
	if year>=GlobalDate.LowerYear:
		if month>=GlobalDate.LowerMonth:
			if day>=GlobalDate.LowerDay:
				randomize()
				GlobalDate.CautionLevel3=int(rand_range(1,5))
			else:
				GlobalDate.CautionLevel3=0
		else:
			GlobalDate.CautionLevel3=0
	else:
		GlobalDate.CautionLevel3=0
	Change_colour()

func Change_colour():
	var CautionLevel=GlobalDate.CautionLevel3
	if CautionLevel==0:
		set_button_icon(Icon_grey)
	elif CautionLevel==1:
		set_button_icon(Icon_Green)
	elif CautionLevel==2:
		set_button_icon(Icon_Yellow)
	elif CautionLevel==3:
		set_button_icon(Icon_Orange)
	elif CautionLevel==4:
		set_button_icon(Icon_Red)
	elif CautionLevel==5:
		set_button_icon(Icon_Really_Red)

func _ready():
	var day=GlobalDate.StartDay-5
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear
	if day<1:
		month=month-1
		if month<1:
			year=year-1
			month=12
		GetDaysInMonth(month)
		day=day+GlobalDate.DaysInMonth
	if year<GlobalDate.LowerYear:
		GlobalDate.CautionLevel3=0
	else:
		if month<GlobalDate.LowerMonth:
			GlobalDate.CautionLevel3=0
		else:
			if day<GlobalDate.LowerDay:
				GlobalDate.CautionLevel3=0
			else:
				randomize()
				GlobalDate.CautionLevel3=int(rand_range(1,5))
	Change_colour()

func _on_LeftArrow_pressed():
	updateColourLeft()
	
func _on_RightArrow_pressed():
	UpdateColourRight()
	
func GetDaysInMonth(month):
	if month==2:#checks if month has 28 days and if it does sends 28 back
		GlobalDate.DaysInMonth=28

	elif month==4:# or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth=30
	elif month==6:# or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth=30
	elif month==9:# or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth=30
	elif month==11:# or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth=30

	elif month==1: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==3: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==5: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==7: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==8: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==10: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
	elif month==11: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth=30
	elif month==12: #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth=31
