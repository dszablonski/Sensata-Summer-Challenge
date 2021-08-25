class_name DateTimeLabel
extends Label

var _selected_button: Button
var _selected_button_date: Dictionary

onready var days_hbox = get_parent().get_parent().get_node("Days/DaysMargin/DaysHBox")

func _ready():#This sets the varibles for the time
	var time = OS.get_datetime()
	GlobalDate.GlobalDay=GlobalDate.UpperDay#
	GlobalDate.GlobalMonth=GlobalDate.UpperMonth#
	GlobalDate.GlobalYear=GlobalDate.UpperYear#
	UpdateDate()
	
func UpdateDate():#This updates the displayed date text
	var day=GlobalDate.GlobalDay
	var month=GlobalDate.GlobalMonth
	var year=GlobalDate.GlobalYear
	var time_string = str(day, "/",month,"/",year)
	var hour_string = Util.to_time_string(GlobalDate.hour)
	set_text("%s %s" % [time_string, hour_string])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func force_press_day_button(year: int, month: int, day: int):
	for button in days_hbox.get_children():
		var date = button.get_date()
		if date.year == year and date.month == month and date.day == day:
			_selected_button = button
			_selected_button_date = _selected_button.get_date()
			_selected_button.disabled = true
			return


func _on_Button_pressed(button):#button 1 - This makes the first button input the date
	if _selected_button:
		_selected_button.disabled = false
	_selected_button = button
	_selected_button_date = _selected_button.get_date()
	_selected_button.disabled = true
	var date = button.get_date()
	var year = date.year
	var month = date.month
	var day = date.day
	if year>=GlobalDate.LowerYear:#checks if the year is in range of the minium date
		if month>=GlobalDate.LowerMonth:#checks if the month is in range of the minium date
			if day>=GlobalDate.LowerDay:#checks if the month is in the range of the minium date
				GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
				GlobalDate.GlobalMonth=(month)
				GlobalDate.GlobalYear=(year)
				UpdateDate()

func _are_dates_equal(date1: Dictionary, date2: Dictionary) -> bool:
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day

func _on_LeftArrow_pressed():
	GlobalDate.ArrowFirstClick=0
	GlobalDate.ButtonClickedLimit=1
	if GlobalDate.ArrowFirstClick==1:
		GlobalDate.ArrowFirstClick=0
		UpdateButtonText()
	else:
		GlobalDate.ArrowButtonsClicked=GlobalDate.ArrowButtonsClicked-1
	GlobalDate.StartDay=GlobalDate.StartDay-7
	if GlobalDate.StartDay<1:
		if GlobalDate.StartMonth<=1:
			GlobalDate.StartYear=GlobalDate.StartYear-1
			GlobalDate.StartMonth=12
			GlobalDate.StartDay=GlobalDate.StartDay+31
		else:
			GlobalDate.StartMonth=GlobalDate.StartMonth-1
			GetDaysInMonth(GlobalDate.StartMonth)
			GlobalDate.StartDay=GlobalDate.StartDay+GlobalDate.DaysInMonth
	UpdateButtonText()
	var current_selected_button_date = _selected_button.get_date()
	var are_dates_equal = _are_dates_equal(_selected_button_date, current_selected_button_date)
	_selected_button.disabled = are_dates_equal


func _on_RightArrow_pressed():
	var Day=GlobalDate.UpperDay
	var Month=GlobalDate.UpperMonth
	var Year=GlobalDate.UpperYear
	if GlobalDate.ArrowFirstClick==0:
		if Year==GlobalDate.StartYear:
			if Month>GlobalDate.StartMonth:
				GlobalDate.StartDay=GlobalDate.StartDay+7
				var month=GlobalDate.StartMonth+1
				GetDaysInMonth(month)
				if GlobalDate.StartDay>GlobalDate.DaysInMonth:
					GetDaysInMonth(GlobalDate.StartMonth)
					GlobalDate.StartDay=GlobalDate.StartDay-GlobalDate.DaysInMonth
					GlobalDate.StartMonth=GlobalDate.StartMonth+1
				GlobalDate.ArrowButtonsClicked=GlobalDate.ArrowButtonsClicked+1
				UpdateButtonText()
			elif Month==GlobalDate.StartMonth:
				if Day>=GlobalDate.StartDay:
					GlobalDate.StartDay=GlobalDate.StartDay+7
					var month=GlobalDate.StartMonth+1
					GetDaysInMonth(month)
					if GlobalDate.StartDay>GlobalDate.DaysInMonth:
						GetDaysInMonth(GlobalDate.StartMonth)
						GlobalDate.StartDay=GlobalDate.StartDay-GlobalDate.DaysInMonth
						GlobalDate.StartMonth=GlobalDate.StartMonth+1
					GlobalDate.ArrowButtonsClicked=GlobalDate.ArrowButtonsClicked+1
					UpdateButtonText()
		elif Year>GlobalDate.StartYear:
				GlobalDate.StartDay=GlobalDate.StartDay+7
				var month=GlobalDate.StartMonth+1
				GetDaysInMonth(month)
				if GlobalDate.StartDay>GlobalDate.DaysInMonth:
					GetDaysInMonth(GlobalDate.StartMonth)
					GlobalDate.StartDay=GlobalDate.StartDay-GlobalDate.DaysInMonth
					GlobalDate.StartMonth=GlobalDate.StartMonth+1
				GlobalDate.ArrowButtonsClicked=GlobalDate.ArrowButtonsClicked+1
				if GlobalDate.StartMonth>12:
					GlobalDate.StartYear=GlobalDate.StartYear+1
					GlobalDate.StartMonth=1
				UpdateButtonText()
	var current_selected_button_date = _selected_button.get_date()
	var are_dates_equal = _are_dates_equal(_selected_button_date, current_selected_button_date)
	_selected_button.disabled = are_dates_equal

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
		
func UpdateButtonText():
	var Day=GlobalDate.StartDay-7#This makes the it go back 7
	if Day>0:#if it's positive it sends the value to be displayed
		GlobalDate.TimeButtonDisplay1=Day
	else:#if it's not then it goes back a month
		var month=GlobalDate.StartMonth-1#gets the month before
		GetDaysInMonth(month)#uses this function to get the amount of days
		Day=GlobalDate.DaysInMonth+Day#makes the negative positive
		GlobalDate.TimeButtonDisplay1=Day#sends it to be displayed
	Day=GlobalDate.StartDay-6#repeats for all the other buttons
	if Day>0:
		GlobalDate.TimeButtonDisplay2=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay2=Day
		
	Day=GlobalDate.StartDay-5
	if Day>0:
		GlobalDate.TimeButtonDisplay3=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay3=Day
		
	Day=GlobalDate.StartDay-4
	if Day>0:
		GlobalDate.TimeButtonDisplay4=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay4=Day
		
	Day=GlobalDate.StartDay-3
	if Day>0:
		GlobalDate.TimeButtonDisplay5=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay5=Day
		
	Day=GlobalDate.StartDay-2
	if Day>0:
		GlobalDate.TimeButtonDisplay6=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay6=Day
		
	Day=GlobalDate.StartDay-1
	if Day>0:
		GlobalDate.TimeButtonDisplay7=Day
	else:
		var month=GlobalDate.StartMonth-1
		GetDaysInMonth(month)
		Day=GlobalDate.DaysInMonth+Day
		GlobalDate.TimeButtonDisplay7=Day
