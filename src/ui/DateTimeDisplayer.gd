class_name DateTimeLabel
extends Label
func _ready():#This sets the varibles for the time
	var time = OS.get_datetime()
	GlobalDate.GlobalDay=time["day"]#
	GlobalDate.GlobalMonth=time["month"]#
	GlobalDate.GlobalYear=time["year"]#
	UpdateDate()
	
func UpdateDate():#This updates the displayed date text
	var day=GlobalDate.GlobalDay
	var month=GlobalDate.GlobalMonth
	var year=GlobalDate.GlobalYear
	set_text(str(day, "/",month,"/",year))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():#button 1 - This makes the first button input the date
	var difference=-7#Makes i go back 7 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button2_pressed():#button 2
	var difference=-6#Makes it go back 6 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button3_pressed():#button 3
	var difference=-5#Makes it go back 5 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button4_pressed():#button 4
	var difference=-4#Makes it go back 7 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button5_pressed():#button 5
	var difference=-3#Makes it go back 3 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button6_pressed():#button 6
	var difference=-2#Makes it go back 2 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

func _on_Button7_pressed():#button 7
	var difference=-1#Makes it go back 7 days
	var day=GlobalDate.StartDay
	var month=GlobalDate.StartMonth
	var year=GlobalDate.StartYear#
	day = day+difference#Gets the date this button will input
	if day>0:#Checks if the date iss in the same month
		GlobalDate.GlobalDay=(day)#if it is it sets the varibles and updates the text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()
	else:#if it's not in the same month it'll do the following
		month= month-1#find the previous month
		GetDaysInMonth(month)#find how many days are in it
		day=(GlobalDate.DaysInMonth+ day)#use that to calculate the date
		GlobalDate.GlobalDay=(day)#and then use that date and update the displayed text
		GlobalDate.GlobalMonth=(month)
		GlobalDate.GlobalYear=(year)
		UpdateDate()

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
	pass # Replace with function body.


func _on_RightArrow_pressed():
	var time = OS.get_datetime()
	var Day=GlobalDate.OriginalDay
	var Month=GlobalDate.OriginalMonth
	var Year=GlobalDate.OriginalYear
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
	pass # Replace with function body.

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
