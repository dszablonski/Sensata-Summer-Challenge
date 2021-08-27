extends Label


func _ready():
	update_text()


func update_text() -> void:
	# this declares the month variable and subtracts 7 from the date to get the month on the 1 at button
	var Month = 0
	var Day = GlobalDate.StartDay - 7
	if Day < 1:
		#if the day is negative it goes back a month
		Month = GlobalDate.StartMonth - 1
	else:
		# if the number is positive  it just gets the already used month
		Month = GlobalDate.StartMonth
	# then it uses a function to convert the month that’s in numbers into the name of the month eg “1” to “January”
	GetMonthName(Month)
	#Then it displays this month
	set_text(GlobalDate.MonthName1)


func GetMonthName(MonthNum):
	if MonthNum == 1:
		GlobalDate.MonthName1 = "January"
	elif MonthNum == 2:
		GlobalDate.MonthName1 = "Febuary"
	elif MonthNum == 3:
		GlobalDate.MonthName1 = "March"
	elif MonthNum == 4:
		GlobalDate.MonthName1 = "April"
	elif MonthNum == 5:
		GlobalDate.MonthName1 = "May"
	elif MonthNum == 6:
		GlobalDate.MonthName1 = "June"
	elif MonthNum == 7:
		GlobalDate.MonthName1 = "July"
	elif MonthNum == 8:
		GlobalDate.MonthName1 = "August"
	elif MonthNum == 9:
		GlobalDate.MonthName1 = "September"
	elif MonthNum == 10:
		GlobalDate.MonthName1 = "October"
	elif MonthNum == 11:
		GlobalDate.MonthName1 = "November"
	elif MonthNum == 12:
		GlobalDate.MonthName1 = "December"


func _on_LeftArrow_pressed():
	# Hack: wait for all the other methods connected to the pressed signal to
	# fire first.
	yield(get_tree(), "idle_frame")
	update_text()


func _on_RightArrow_pressed():
	# Hack: wait for all the other methods connected to the pressed signal to
	# fire first.
	yield(get_tree(), "idle_frame")
	update_text()
