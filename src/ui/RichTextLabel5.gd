extends RichTextLabel
func _ready():
	var difference=-3
	var day = GlobalDate.StartDay+difference
	if day>0:
		set_text(str(day))
	else:
		var month=GlobalDate.StartMonth
		var month2= month-1
		if month2==2:
			day=(28+ day)+difference
		elif month2==4 or 11 or 6 or 9:
			day=(30+ day)-7
		elif month2==1 or 3 or 5 or 7 or 8 or 10 or 12:
			day=(31+ day)+difference
		set_text(str(day))
	pass # Replace with function body.


func _on_LeftArrow_pressed():
	set_text(str(GlobalDate.TimeButtonDisplay5))#updates text when left arrow is pressed


func _on_RightArrow_pressed():
	if GlobalDate.ArrowFirstClick==0:
		set_text(str(GlobalDate.TimeButtonDisplay5))
