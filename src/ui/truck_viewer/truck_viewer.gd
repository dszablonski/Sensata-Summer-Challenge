extends VSplitContainer

onready var interactive_truck: InteractiveTruck = $TruckViewportContainer/TruckViewport/InteractiveTruck


func _on_Truck_Viewer_visibility_changed() -> void:
	interactive_truck.is_enabled = visible
