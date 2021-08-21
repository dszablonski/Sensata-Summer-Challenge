extends Button

var Icon_grey=preload("res://calender_grey.png")
var Icon_Green=preload("res://calender_green.png")
var Icon_Yellow=preload("res://calender_yellow.png")
var Icon_Orange=preload("res://calender_orange.png")
var Icon_Red=preload("res://calender_red.png")
var Icon_Really_Red=preload("res://calender_really_red.png")

func Change_colour():
	randomize()
	GlobalDate.CautionLevel3=int(rand_range(0,5))
	if GlobalDate.CautionLevel3==0:
		set_button_icon(Icon_grey)
	elif GlobalDate.CautionLevel3==1:
		set_button_icon(Icon_Green)
	elif GlobalDate.CautionLevel3==2:
		set_button_icon(Icon_Yellow)
	elif GlobalDate.CautionLevel3==3:
		set_button_icon(Icon_Orange)
	elif GlobalDate.CautionLevel3==4:
		set_button_icon(Icon_Red)
	elif GlobalDate.CautionLevel3==5:
		set_button_icon(Icon_Really_Red)

func _ready():
	Change_colour()

func _on_LeftArrow_pressed():
	Change_colour()
	pass # Replace with function body.

func _on_RightArrow_pressed():
	Change_colour()
	pass # Replace with function body.