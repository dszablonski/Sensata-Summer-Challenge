extends MeshInstance

# Selected colour, red
const selected = Color(1,0,0)
# Clear colour, white
const clear = Color(1,1,1)
onready var meshInstance

# Hoping to use this at some point to check for the last node clicked and then
# making that node's colour to be white. I've been trying to implement that
# but am having a little bit of trouble 
#var last_node_clicked

# Function to change the border
func change_border(get_mesh, get_colour):
	print("Border texture changed")
	# Gets the material of the mesh passed into the function
	var material = get_mesh.get_surface_material(0)
	# Sets the albedo of the shader to the colour passed into the function
	material.set_shader_param("albedo", get_colour)
		

# For now, this only applies to Truck Wheel A and the freezer
func _on_StaticBody_truck_wheel_a():
	meshInstance = self.get_node(".")
	change_border(meshInstance, selected)



func _on_StaticBody_freezer():
	meshInstance = self.get_node(".")
	change_border(meshInstance, selected)
