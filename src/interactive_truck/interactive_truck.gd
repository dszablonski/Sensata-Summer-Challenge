extends Spatial

onready var camera_pivot: Spatial = $CameraPivot


func _physics_process(delta: float) -> void:
	camera_pivot.rotate_y(deg2rad(100 * delta))
