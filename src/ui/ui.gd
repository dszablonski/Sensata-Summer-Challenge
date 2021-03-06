extends Control

onready var date_time: DateTimeLabel = $UIMargin/UIVSplit/TopRowHSplit/LeftSide/Timeline/TopRow/DateTime
onready var clock: Clock = $"UIMargin/UIVSplit/TopRowHSplit/RightSide/TabContainer/Time Selection"
onready var help_popup: PopupPanel = $UIMargin/HelpPopup


func _ready() -> void:
	clock.force_press_time_button(GlobalDate.hour)
	date_time.force_press_day_button(
		GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen


func _on_Time_Selection_time_changed(new_time) -> void:
	GlobalDate.hour = new_time
	date_time.UpdateDate()


func _on_HelpButton_pressed() -> void:
	help_popup.popup_centered()
