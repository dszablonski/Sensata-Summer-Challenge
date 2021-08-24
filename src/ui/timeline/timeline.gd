extends VBoxContainer

onready var left_arrow: Button = $TopRow/LeftArrow
onready var date_time: DateTimeLabel = $TopRow/DateTime
onready var right_arrow: Button = $TopRow/RightArrow
onready var days_hbox: HBoxContainer = $Days/DaysMargin/DaysHBox


func _ready() -> void:
	for day in days_hbox.get_children():
		left_arrow.connect("pressed", day, "_on_LeftArrow_pressed")
		right_arrow.connect("pressed", day, "_on_RightArrow_pressed")
		day.connect("pressed", date_time, "_on_Button_pressed", [day])
