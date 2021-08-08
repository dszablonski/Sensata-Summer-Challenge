extends ViewportContainer

onready var viewport: Viewport = $TruckViewport


func _input(event: InputEvent) -> void:
	# Relevant issue: https://github.com/godotengine/godot/issues/17326
	# Workaround: https://github.com/godotengine/godot/issues/17326#issuecomment-431186323
	if event is InputEventMouse:
		var mouse_event = event.duplicate()
		mouse_event.position = get_global_transform().xform_inv(event.global_position)
		viewport.unhandled_input(mouse_event)
	else:
		viewport.unhandled_input(event)
