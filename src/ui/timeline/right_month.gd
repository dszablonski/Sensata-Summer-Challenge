extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GetMonthName(GlobalDate.StartMonth)
	set_text(GlobalDate.MonthName2)
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RightArrow_pressed():
	GetMonthName(GlobalDate.StartMonth)
	set_text(GlobalDate.MonthName2)
	pass  # Replace with function body.


func _on_LeftArrow_pressed():
	GetMonthName(GlobalDate.StartMonth)
	set_text(GlobalDate.MonthName2)
	pass  # Replace with function body.


func GetMonthName(MonthNum):
	if MonthNum == 1:
		GlobalDate.MonthName2 = "January"
	elif MonthNum == 2:
		GlobalDate.MonthName2 = "Febuary"
	elif MonthNum == 3:
		GlobalDate.MonthName2 = "March"
	elif MonthNum == 4:
		GlobalDate.MonthName2 = "April"
	elif MonthNum == 5:
		GlobalDate.MonthName2 = "May"
	elif MonthNum == 6:
		GlobalDate.MonthName2 = "June"
	elif MonthNum == 7:
		GlobalDate.MonthName2 = "July"
	elif MonthNum == 8:
		GlobalDate.MonthName2 = "August"
	elif MonthNum == 9:
		GlobalDate.MonthName2 = "September"
	elif MonthNum == 10:
		GlobalDate.MonthName2 = "October"
	elif MonthNum == 11:
		GlobalDate.MonthName2 = "November"
	elif MonthNum == 12:
		GlobalDate.MonthName2 = "December"
