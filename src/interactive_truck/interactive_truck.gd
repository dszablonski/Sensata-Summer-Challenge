extends Node2D

# When the mouse wraps around the viewport it forcibly sets the mouse's position.
# This results in an InputEventMouseMotion event which we want to ignore.
# Since these events caused by the mouse wrapping tend to move the mouse large
# distances the InputEventMouseMotion.relative property becomes very large.
# Therefore, by ignoring all events which move the mouse too far, we can
# essentially ignore all events caused by forcibly setting the mouse's position.
const MAX_MOUSE_MOTION_DIST := 300
const ZOOM_IN_SPEED := 1.0
const ZOOM_OUT_SPEED := 1.0
const MIN_CAMERA_SIZE := 4.0
const MAX_CAMERA_SIZE := 25.0
const AUTOMATIC_TRUCK_ROTATION_SPEED := 135 # Degrees/second

var _was_prev_panning_camera := false
var _last_y_rotation: float

onready var tree := get_tree()
onready var root := tree.get_root()

onready var viewport := get_viewport()

onready var camera_pivot: Spatial = $CameraPivot
onready var camera: Camera = $CameraPivot/Camera


func _process(delta: float) -> void:
	if _is_mouse_inside_viewport():
		return
	# If the mouse is not inside the viewport, rotate the truck automatically.
	var dir := sign(_last_y_rotation)
	if dir == 0:
		dir = 1
	var rot := deg2rad(AUTOMATIC_TRUCK_ROTATION_SPEED) * dir * delta
	camera_pivot.rotation.y += rot


func _input(event: InputEvent) -> void:
	if not _is_mouse_inside_viewport():
		if not _was_prev_panning_camera:
			return
		_wrap_mouse_around_viewport()

	if Input.is_action_pressed("pan_camera") and event is InputEventMouseMotion:
		if event.relative.length() > MAX_MOUSE_MOTION_DIST:
			return
		_was_prev_panning_camera = true
		camera_pivot.rotation.y -= deg2rad(event.relative.x)
		camera_pivot.rotation.z -= deg2rad(event.relative.y)
		_last_y_rotation = -event.relative.x
	else:
		_was_prev_panning_camera = false

	if Input.is_action_pressed("zoom_in"):
		camera.size -= ZOOM_IN_SPEED
		camera.size = max(MIN_CAMERA_SIZE, camera.size)
	elif Input.is_action_pressed("zoom_out"):
		camera.size += ZOOM_OUT_SPEED
		camera.size = min(MAX_CAMERA_SIZE, camera.size)


func _is_mouse_inside_viewport() -> bool:
	var mouse_pos := get_global_mouse_position()
	var viewport_rect := get_viewport_rect()
	return viewport_rect.has_point(mouse_pos)


func _wrap_mouse_around_viewport() -> void:
	var root_mouse_pos := root.get_mouse_position()
	var mouse_pos := get_global_mouse_position()
	var root_mouse_pos_diff := root_mouse_pos - mouse_pos
	var new_mouse_pos := Vector2(
		fposmod(mouse_pos.x, viewport.size.x),
		fposmod(mouse_pos.y, viewport.size.y)
	)
	var new_root_mouse_pos := root_mouse_pos_diff + new_mouse_pos
	Input.warp_mouse_position(new_root_mouse_pos)
