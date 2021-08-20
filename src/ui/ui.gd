extends MarginContainer

#export var time := 0.0
#
#onready var date_time_label: Label = $VSplitContainer/HSplitContainer/LeftSide/DateTime
#onready var clock: Clock = $"VSplitContainer/HSplitContainer/RightSide/TabContainer/Time Selection"
#
#
#func _ready() -> void:
#	date_time_label.setup(time)
#	clock.force_press_time_button(time)
#
#
#func _on_Time_Selection_time_changed(new_time) -> void:
#	time = new_time
#	date_time_label.setup(time)
