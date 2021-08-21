extends RichTextLabel
func _ready():
	var difference=-0
	var time = OS.get_datetime()
	var day= time["day"]
	var day2 = day+difference
	if day2>0:
		set_text(str(day2))
	else:
		var month=time["month"]
		var month2= month-1
		if month2==2:
			var day3=(28+ day)+difference
			set_text(str(day3))
		if month2==4 or 11 or 6 or 9:
			var day3=(30+ day)-7
			set_text(str(day3))
		if month2==1 or 3 or 5 or 7 or 8 or 10 or 12:
			var day3=(31+ day)+difference
			set_text(str(day3))
	pass # Replace with function body.


func _on_LeftArrow_pressed():
	set_text(str(GlobalDate.TimeButtonDisplay7))#updates text when left arrow is pressed


func _on_RightArrow_pressed():
	if GlobalDate.ArrowFirstClick==0:
		set_text(str(GlobalDate.TimeButtonDisplay7))
