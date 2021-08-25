extends Node

signal date_time_changed

var GlobalDay = 1 setget _set_GlobalDay  #Displayed day
var GlobalMonth = 6 setget _set_GlobalMonth  #Displayed month
var GlobalYear = 2021 setget _set_GlobalYear  #Displayed year
var StartDay = 10 + 1  #This is the day the timeline starts on 
var StartMonth = 6  #This is the month the timeline starts on 
var StartYear = 2021  ##This is the year the timeline starts on 
var LowerDay = 1  #This is minium day in the database and makes it so you can't interact with dates before this
var LowerMonth = 6  #This is minium month in the database and makes it so you can't interact with dates before this
var LowerYear = 2021  #This is minium year in the database and makes it so you can't interact with dates before this
var UpperDay = 10  #This is maxium day in the database and makes it so you can't interact with dates after this
var UpperMonth = 6  #This is maxium month in the database and makes it so you can't interact with dates after this
var UpperYear = 2021  ##This is maxium year in the database and makes it so you can't interact with dates after this
var DaysInMonth = 0  #This is used in functions to deliver the amount of days in a month(I couldn't get the return function working)
var TimeButtonDisplay1 = 0  #This is used to display the day on button1
var MonthDisplay1 = 0  #This is used to store the month on button1
var YearDisplay1 = 0  #This is used to store the year on button1
var CautionLevel1 = 0  #This is used to store the caution level on button1 and decides the colour of said button
var TimeButtonDisplay2 = 0  #This is used to display the day on button2
var MonthDisplay2 = 0  #This is used to store the month on button2
var YearDisplay2 = 0  #This is used to store the year on button2
var CautionLevel2 = 0  #This is used to store the caution level on button1 and decides the colour of said button
var TimeButtonDisplay3 = 0  #This is used to display the day on button3
var MonthDisplay3 = 0  #This is used to store the month on button3
var YearDisplay3 = 0  #This is used to store the year on button3
var CautionLevel3 = 0  #This is used to store the caution level on button3 and decides the colour of said button
var TimeButtonDisplay4 = 0  #This is used to display the day on button4
var MonthDisplay4 = 0  #This is used to store the month on button4
var YearDisplay4 = 0  #This is used to store the year on button4
var CautionLevel4 = 0  #This is used to store the caution level on button4 and decides the colour of said button
var TimeButtonDisplay5 = 0  #This is used to display the day on button5
var MonthDisplay5 = 0  #This is used to store the month on button5
var YearDisplay5 = 0  #This is used to store the year on button5
var CautionLevel5 = 0  #This is used to store the caution level on button5 and decides the colour of said button
var TimeButtonDisplay6 = 0  #This is used to display the day on button6
var MonthDisplay6 = 0  #This is used to store the month on button6
var YearDisplay6 = 0  #This is used to store the year on button6
var CautionLevel6 = 0  #This is used to store the caution level on button6 and decides the colour of said button
var TimeButtonDisplay7 = 0  #This is used to display the day on button7
var MonthDisplay7 = 0  #This is used to store the month on button7
var YearDisplay7 = 0  #This is used to store the year on button7
var CautionLevel7 = 0  #This is used to store the caution level on button7 and decides the colour of said button
var ArrowButtonsClicked = -0  #This varible makes sure you can't go past the upper date
var ArrowFirstClick = 1  #This varible makes sure you can't go past the upper date on the first click
var ButtonClickedLimit = 0  #This varible makes sure you can't go past the upper date
var MonthName1 = ""  #This is used to display the first month on "Month1" text
var MonthName2 = ""  #This is used to display the second month on "Month2" text
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
