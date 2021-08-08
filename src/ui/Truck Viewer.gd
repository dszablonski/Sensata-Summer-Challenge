extends ViewportContainer

onready var viewport: Viewport = $TruckViewport


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		event.position -= rect_global_position
	viewport.unhandled_input(event)
