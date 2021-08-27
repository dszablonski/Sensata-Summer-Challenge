extends Button

const CAUTION_LEVEL_TO_NORMAL_COLOR := {
	-1: Color("181425"),  # No data
	0: Color("63C74D"),  # Safe
	1: Color("FEE761"),  # Caution
	2: Color("E43B44"),  # Critical
}

const CAUTION_LEVEL_TO_HOVER_COLOR := {
	-1: Color("181425"),  # No data
	0: Color("3E8948"),  # Safe
	1: Color("FEAE34"),  # Caution
	2: Color("A22633"),  # Critical
}

const CAUTION_LEVEL_TO_PRESSED_COLOR := {
	-1: Color("181425"),  # No data
	0: Color("193C3E"),  # Safe
	1: Color("733E39"),  # Caution
	2: Color("3E2731"),  # Critical
}

const CAUTION_LEVEL_TO_DISABLED_COLOR := {
	-1: Color("181425"),  # No data
	0: Color("193C3E"),  # Safe
	1: Color("733E39"),  # Caution
	2: Color("3E2731"),  # Critical
}

const CAUTION_LEVEL_TO_NORMAL_FONT_COLOR := {
	-1: Color("3A4466"),  # No data
	0: Color.black,  # Safe
	1: Color.black,  # Caution
	2: Color.black,  # Critical
}

const CAUTION_LEVEL_TO_HOVER_FONT_COLOR := {
	-1: Color("3A4466"),  # No data
	0: Color.black,  # Safe
	1: Color.black,  # Caution
	2: Color.black,  # Critical
}

const CAUTION_LEVEL_TO_PRESSED_FONT_COLOR := {
	-1: Color("3A4466"),  # No data
	0: Color.black,  # Safe
	1: Color.black,  # Caution
	2: Color.black,  # Critical
}

const CAUTION_LEVEL_TO_DISABLED_FONT_COLOR := {
	-1: Color("3A4466"),  # No data
	0: Color.black,  # Safe
	1: Color.black,  # Caution
	2: Color.black,  # Critical
}

var num_days_back: int

var _is_random_colors := false
var _stylebox_normal: StyleBoxFlat
var _stylebox_hover: StyleBoxFlat
var _stylebox_pressed: StyleBoxFlat
var _stylebox_disabled: StyleBoxFlat
var _caution_level_string: String
var _month_display_string: String
var _year_display_string: String
var _time_button_display_string: String


func _ready() -> void:
	_stylebox_normal = get_stylebox("normal").duplicate()
	_stylebox_hover = get_stylebox("hover").duplicate()
	_stylebox_pressed = get_stylebox("pressed").duplicate()
	_stylebox_disabled = get_stylebox("disabled").duplicate()
	add_stylebox_override("normal", _stylebox_normal)
	add_stylebox_override("hover", _stylebox_hover)
	add_stylebox_override("pressed", _stylebox_pressed)
	add_stylebox_override("disabled", _stylebox_disabled)

	var pos_in_parent := get_position_in_parent()
	var button_num := pos_in_parent + 1
	var button_num_string := str(button_num)
	num_days_back = 7 - pos_in_parent
	_caution_level_string = "CautionLevel" + button_num_string
	_month_display_string = "MonthDisplay" + button_num_string
	_year_display_string = "YearDisplay" + button_num_string
	_time_button_display_string = "TimeButtonDisplay" + button_num_string

	#this makes the days go back from the current displayed week to get the day needs to input.
	#this sets the month and year to the current one on the timeline
	var day = GlobalDate.StartDay - num_days_back
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear
	if day < 1:
		#if the day is negative it goes back a month and adds those days to get the proper date
		month = month - 1
		if month < 1:
			# if the month is negative it goes back a year
			year = year - 1
			month = 12
		GetDaysInMonth(month)
		day = day + GlobalDate.DaysInMonth
	if year < GlobalDate.LowerYear:
		# if the year is less than the minimum data base year it will send a caution level of -1 showing a grey button
		GlobalDate.set(_caution_level_string, -1)
	else:
		#same for the month and day
		if month < GlobalDate.LowerMonth:
			GlobalDate.set(_caution_level_string, -1)
		else:
			if day < GlobalDate.LowerDay:
				GlobalDate.set(_caution_level_string, -1)
			else:
				#this sends the year, month and day to a function to get the caution level and sends that to the change_colour() function to update the colour
				var caution_level = get_caution_level(year, month, day)
				GlobalDate.set(_caution_level_string, caution_level)
	Change_colour()
	GlobalDate.set(_month_display_string, month)
	GlobalDate.set(_year_display_string, year)

	#gets the current weeks date and goes back enough to calculate the date for this button.
	var day_test = GlobalDate.StartDay - num_days_back
	if day_test > 0:
		#if it’s a positive normal number it’ll set the text to the day.
		set_text(str(day_test))
	else:  # if it’s negative
		# it goes back a month and adds the amount of days in the month to correct the date # then it sets the rich text to this text
		var month_test = GlobalDate.StartMonth
		var month2 = month_test - 1
		if month2 == 2:
			day_test = (28 + day_test) - num_days_back
		elif month2 in [4, 11, 6, 9]:
			day_test = (30 + day_test) - num_days_back
		elif month2 in [1, 3, 5, 7, 8, 10, 12]:
			day_test = (31 + day_test) - num_days_back
		set_text(str(day_test))


func get_caution_level(year: int, month: int, day: int) -> int:
	var safety_value := 0
	for i in 24:
		var temp_safety_value := Util.get_safety_value(year, month, day, i)
		if temp_safety_value > safety_value:
			safety_value = temp_safety_value
			if safety_value == 2:
				break
	return safety_value


func get_date() -> Dictionary:
	# these variables set the day month and year to the weeks current day month and year
	var day = GlobalDate.StartDay
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear  #
	day = day - num_days_back  #Gets the date this button will input
	if day < 1:  #checks if the day is in the day is in the same month
		month = month - 1  #if it's not it goes back a month
		if month < 1:  #this checks if the month is in the same year
			# if the month is negative it goes back a year and to December and ads 31 days to the negative day to make it the correct date
			year = year - 1  #this goes back a year
			month = 12  #this sends the date to december (the last month)
			day = day + 31  #this restores the date
		else:  #if the month is in the year
			# if the month is a positive number it’ll use a function to get the days in that month and add those days onto the negative number to get the correct date
			GetDaysInMonth(month)  #it gets the amount of days are in the month
			day = day + GlobalDate.DaysInMonth  #and adds them to restore the date
	return {
		"year": year,
		"month": month,
		"day": day,
	}


func updateColourLeft():
	var day = GlobalDate.StartDay
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear  #
	day = day - num_days_back  #Gets the date this button will input
	if day < 1:  #checks if the day is in the day is in the same month
		month = month - 1  #if it's not it goes back a month 
		if month < 1:  #this checks if the month is in the same year
			year = year - 1  #this goes back a year 
			month = 12  #this sends the date to december (the last month)
			day = day + 31  #this restores the date 
		else:  #if the month is in the year
			GetDaysInMonth(month)  #it gets the amount of days are in the month
			day = day + GlobalDate.DaysInMonth  #and adds them to restore the date
	if year >= GlobalDate.LowerYear:  #checks if the year is in range of the minium date
		if month >= GlobalDate.LowerMonth:  #checks if the month is in range of the minium date
			if day >= GlobalDate.LowerDay:  #checks if the month is in the range of the minium date
				var caution_level = get_caution_level(year, month, day)
				GlobalDate.set(_caution_level_string, caution_level)
			else:
				GlobalDate.set(_caution_level_string, -1)
		else:
			GlobalDate.set(_caution_level_string, -1)
	else:
		GlobalDate.set(_caution_level_string, -1)
	Change_colour()


func UpdateColourRight():
	var day = GlobalDate.StartDay
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear  #
	day = day - num_days_back  #Gets the date this button will input
	GetDaysInMonth(month)
	if day > GlobalDate.DaysInMonth:  #checks if the day is in the day is in the same month
		month = month - 1  #if it's not it goes back a month 
		if month < 1:  #this checks if the month is in the same year
			year = year - 1  #this goes back a year 
			month = 12  #this sends the date to december (the last month)
		GetDaysInMonth(month)  #it gets the amount of days are in the month
		day = day - GlobalDate.DaysInMonth  #and adds them to restore the date
	if year >= GlobalDate.LowerYear:  #checks if the year is in range of the minium date
		if month >= GlobalDate.LowerMonth:  #checks if the month is in range of the minium date
			if day >= GlobalDate.LowerDay:  #checks if the month is in the range of the minium date
				var caution_level = get_caution_level(year, month, day)
				GlobalDate.set(_caution_level_string, caution_level)
			else:
				GlobalDate.set(_caution_level_string, -1)
		else:
			GlobalDate.set(_caution_level_string, -1)
	else:
		GlobalDate.set(_caution_level_string, -1)
	Change_colour()


func Change_colour():
	var CautionLevel = GlobalDate.get(_caution_level_string)
	if _is_random_colors and CautionLevel > 0:
		CautionLevel = Util.randi_range(0, 2)
	var stylebox_normal_color: Color = CAUTION_LEVEL_TO_NORMAL_COLOR[CautionLevel]
	var stylebox_hover_color: Color = CAUTION_LEVEL_TO_HOVER_COLOR[CautionLevel]
	var stylebox_pressed_color: Color = CAUTION_LEVEL_TO_PRESSED_COLOR[CautionLevel]
	var stylebox_disabled_color: Color = CAUTION_LEVEL_TO_DISABLED_COLOR[CautionLevel]
	_stylebox_normal.bg_color = stylebox_normal_color
	_stylebox_hover.bg_color = stylebox_hover_color
	_stylebox_pressed.bg_color = stylebox_pressed_color
	_stylebox_disabled.bg_color = stylebox_disabled_color
	var normal_font_color: Color = CAUTION_LEVEL_TO_NORMAL_FONT_COLOR[CautionLevel]
	var hover_font_color: Color = CAUTION_LEVEL_TO_HOVER_FONT_COLOR[CautionLevel]
	var pressed_font_color: Color = CAUTION_LEVEL_TO_PRESSED_FONT_COLOR[CautionLevel]
	var disabled_font_color: Color = CAUTION_LEVEL_TO_DISABLED_FONT_COLOR[CautionLevel]
	add_color_override("font_color", normal_font_color)
	add_color_override("font_color_hover", hover_font_color)
	add_color_override("font_color_pressed", pressed_font_color)
	add_color_override("font_color_disabled", disabled_font_color)


func _on_LeftArrow_pressed():
	updateColourLeft()
	var day = GlobalDate.StartDay - num_days_back
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear
	if day < 1:
		month = month - 1
		if month < 1:
			year = year - 1
			month = 12
		GetDaysInMonth(month)
		day = day + GlobalDate.DaysInMonth
	GlobalDate.set(_month_display_string, month)
	GlobalDate.set(_year_display_string, year)

	set_text(str(GlobalDate.get(_time_button_display_string)))


func _on_RightArrow_pressed():
	UpdateColourRight()
	var day = GlobalDate.StartDay - num_days_back
	var month = GlobalDate.StartMonth
	var year = GlobalDate.StartYear
	if day < 1:
		month = month - 1
		if month < 1:
			year = year - 1
			month = 12
		GetDaysInMonth(month)
		day = day + GlobalDate.DaysInMonth
	GlobalDate.set(_month_display_string, month)
	GlobalDate.set(_year_display_string, year)

	if GlobalDate.ArrowFirstClick == 0:
		set_text(str(GlobalDate.get(_time_button_display_string)))


func GetDaysInMonth(month):
	if month == 2:  #checks if month has 28 days and if it does sends 28 back
		GlobalDate.DaysInMonth = 28

	elif month == 4:  # or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth = 30
	elif month == 6:  # or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth = 30
	elif month == 9:  # or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth = 30
	elif month == 11:  # or 6 or 11 or 9:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth = 30

	elif month == 1:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 3:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 5:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 7:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 8:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 10:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
	elif month == 11:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 30 days and if it does sends 30 back
		GlobalDate.DaysInMonth = 30
	elif month == 12:  #or 3 or 5 or 7 or 8 or 10 or 12:#checks if month has 31 days and if it does sends 31 back
		GlobalDate.DaysInMonth = 31
