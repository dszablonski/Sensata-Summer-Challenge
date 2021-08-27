class_name DateTimeLabel
extends Label

var _selected_button: Button
var _selected_button_date: Dictionary

onready var days_hbox = get_parent().get_parent().get_node("Days/DaysMargin/DaysHBox")


func _ready():  #This sets the varibles for the time
	GlobalDate.GlobalDay = GlobalDate.UpperDay  #
	GlobalDate.GlobalMonth = GlobalDate.UpperMonth  #
	GlobalDate.GlobalYear = GlobalDate.UpperYear  #
	UpdateDate()


func UpdateDate():  #This updates the displayed date text
	var day = GlobalDate.GlobalDay
	var month = GlobalDate.GlobalMonth
	var year = GlobalDate.GlobalYear
	var time_string = str(day, "/", month, "/", year)
	var hour_string = Util.to_time_string(GlobalDate.hour)
	set_text("%s %s" % [time_string, hour_string])


func force_press_day_button(year: int, month: int, day: int):
	for button in days_hbox.get_children():
		var date = button.get_date()
		if date.year == year and date.month == month and date.day == day:
			_selected_button = button
			_selected_button_date = _selected_button.get_date()
			_selected_button.disabled = true
			return


func _on_Button_pressed(button):  #button 1 - This makes the first button input the date
	# If a button is already selected then it should be enabled again.
	if _selected_button:
		_selected_button.disabled = false
	# This button should be selected and then disabled so it can't be pressed
	# again.
	_selected_button = button
	_selected_button_date = _selected_button.get_date()
	_selected_button.disabled = true
	var date = button.get_date()
	var year = date.year
	var month = date.month
	var day = date.day
	if year >= GlobalDate.LowerYear:  #checks if the year is in range of the minium date
		if month >= GlobalDate.LowerMonth:  #checks if the month is in range of the minium date
			if day >= GlobalDate.LowerDay:  #checks if the month is in the range of the minium date
				GlobalDate.GlobalDay = (day)  #if it is it sets the varibles and updates the text
				GlobalDate.GlobalMonth = (month)
				GlobalDate.GlobalYear = (year)
				UpdateDate()


func _are_dates_equal(date1: Dictionary, date2: Dictionary) -> bool:
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day


func _on_LeftArrow_pressed():
	#The first bit is just code to stop the dates going above the maximum date that’s allowed
	GlobalDate.ArrowFirstClick = 0
	GlobalDate.ButtonClickedLimit = 1
	if GlobalDate.ArrowFirstClick == 1:
		GlobalDate.ArrowFirstClick = 0
		UpdateButtonText()
	else:
		GlobalDate.ArrowButtonsClicked = GlobalDate.ArrowButtonsClicked - 1
	#Then the variable goes back 7days (a week) on the days
	GlobalDate.StartDay = GlobalDate.StartDay - 7
	if GlobalDate.StartDay < 1:
		if GlobalDate.StartMonth <= 1:
			# if the days are negative and the month is below one then it’ll go back a year and to December and add 31 days to calculate the positive date
			GlobalDate.StartYear = GlobalDate.StartYear - 1
			GlobalDate.StartMonth = 12
			GlobalDate.StartDay = GlobalDate.StartDay + 31
		else:  # if the month is positive
			# it’ll go back a month and use a function to get the days in that month.
			GlobalDate.StartMonth = GlobalDate.StartMonth - 1
			GetDaysInMonth(GlobalDate.StartMonth)
			# then add those days back to the date to get the actual date.
			GlobalDate.StartDay = GlobalDate.StartDay + GlobalDate.DaysInMonth
	# finally, it uses the update text function to update all the button values.
	UpdateButtonText()
	# Enable/disable the selected button if the correct week is displayed.
	var current_selected_button_date = _selected_button.get_date()
	var are_dates_equal = _are_dates_equal(_selected_button_date, current_selected_button_date)
	_selected_button.disabled = are_dates_equal


func _on_RightArrow_pressed():
	#the first lines are just setting variables to the maximum database value
	var Day = GlobalDate.UpperDay
	var Month = GlobalDate.UpperMonth
	var Year = GlobalDate.UpperYear
	if GlobalDate.ArrowFirstClick == 0:
		# this checks that the year is the right year for database values
		if Year == GlobalDate.StartYear:
			# this checks that the month is under the maximum month.
			if Month > GlobalDate.StartMonth:
				#This adds seven days
				GlobalDate.StartDay = GlobalDate.StartDay + 7
				# we then use a temporary variable to get the month ahead and use a function to see how many days are in it.
				var month = GlobalDate.StartMonth + 1
				GetDaysInMonth(month)
				# if the days is more than the days in that month this code executes
				if GlobalDate.StartDay > GlobalDate.DaysInMonth:
					GetDaysInMonth(GlobalDate.StartMonth)
					# it gets the amount of days in the month ahead and then subtracts them from the total.
					GlobalDate.StartDay = GlobalDate.StartDay - GlobalDate.DaysInMonth
					# it then updates the main month as we’ve gone forward a month
					GlobalDate.StartMonth = GlobalDate.StartMonth + 1
				GlobalDate.ArrowButtonsClicked = GlobalDate.ArrowButtonsClicked + 1
				UpdateButtonText()
			elif Month == GlobalDate.StartMonth:
				# this code is used to check the user hasn’t gone forward too far
				# the text then updates if it’s been in range.
				if Day >= GlobalDate.StartDay:
					GlobalDate.StartDay = GlobalDate.StartDay + 7
					var month = GlobalDate.StartMonth + 1
					GetDaysInMonth(month)
					if GlobalDate.StartDay > GlobalDate.DaysInMonth:
						GetDaysInMonth(GlobalDate.StartMonth)
						GlobalDate.StartDay = GlobalDate.StartDay - GlobalDate.DaysInMonth
						GlobalDate.StartMonth = GlobalDate.StartMonth + 1
					GlobalDate.ArrowButtonsClicked = GlobalDate.ArrowButtonsClicked + 1
					UpdateButtonText()
		elif Year > GlobalDate.StartYear:  # if the year is under the max year
			GlobalDate.StartDay = GlobalDate.StartDay + 7
			var month = GlobalDate.StartMonth + 1
			GetDaysInMonth(month)
			if GlobalDate.StartDay > GlobalDate.DaysInMonth:
				GetDaysInMonth(GlobalDate.StartMonth)
				GlobalDate.StartDay = GlobalDate.StartDay - GlobalDate.DaysInMonth
				GlobalDate.StartMonth = GlobalDate.StartMonth + 1
			GlobalDate.ArrowButtonsClicked = GlobalDate.ArrowButtonsClicked + 1
			# it’s basically the same too except if the month is over 12 it goes forward a year
			if GlobalDate.StartMonth > 12:
				GlobalDate.StartYear = GlobalDate.StartYear + 1
				GlobalDate.StartMonth = 1
			UpdateButtonText()
	# Enable/disable the selected button if the correct week is displayed.
	var current_selected_button_date = _selected_button.get_date()
	var are_dates_equal = _are_dates_equal(_selected_button_date, current_selected_button_date)
	_selected_button.disabled = are_dates_equal


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


func UpdateButtonText():
	for i in range(7):
		var time_button_display_string = "TimeButtonDisplay" + str(i + 1)
		var num_days_back = 7 - i
		var Day = GlobalDate.StartDay - num_days_back
		if Day > 0:  #if it's positive it sends the value to be displayed
			GlobalDate.set(time_button_display_string, Day)
		else:  #if it's not then it goes back a month
			var month = GlobalDate.StartMonth - 1  #gets the month before
			GetDaysInMonth(month)  #uses this function to get the amount of days
			Day = GlobalDate.DaysInMonth + Day  #makes the negative positive
			GlobalDate.set(time_button_display_string, Day)  #sends it to be displayed
