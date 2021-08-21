extends Control

onready var date_time: DateTimeLabel = $MarginContainer/VSplitContainer/HSplitContainer/LeftSide/MarginContainer/DateTime
onready var clock: Clock = $"MarginContainer/VSplitContainer/HSplitContainer/RightSide/TabContainer/Time Selection"


func _ready() -> void:
	clock.force_press_time_button(GlobalDate.hour)


func _on_Time_Selection_time_changed(new_time) -> void:
	GlobalDate.hour = new_time
	date_time.UpdateDate()
