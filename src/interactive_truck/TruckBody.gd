extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("input_event", self, "on_input_event")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		print("clicked")

func _process(delta):
	pass
