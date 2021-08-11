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

func clear_borders(node, colour):
	for i in node.get_parent().get_children():
		change_border(i, colour)

# Function to change the border
func change_border(get_mesh, get_colour):
	print("Border texture changed")
	# Gets the material of the mesh passed into the function
	var material = get_mesh.get_surface_material(0)
	# Sets the albedo of the shader to the colour passed into the function
	material.set_shader_param("albedo", get_colour)

func main(meshInstance):
	clear_borders(meshInstance, clear)
	change_border(meshInstance, selected)

# For now, this only applies to Truck Wheel A and the freezer
func _on_StaticBody_truck_wheel_a():
	main(self.get_node("."))



func _on_StaticBody_freezer():
	main(self.get_node("."))


func _on_StaticBody_brake_wear_sensor_ab():
	main(self.get_node("."))


func _on_StaticBody_clear():
	clear_borders(self.get_node("."), clear)

func _on_StaticBody_truck_wheel_b():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_c():
	main(self.get_node("."))


func _on_StaticBody_truck_wheel_d():
	main(self.get_node("."))


func _on_StaticBody_truck_wheel_e():
	main(self.get_node("."))


func _on_StaticBody_truck_wheel_f():
	main(self.get_node("."))


func _on_StaticBody_brake_wear_sensor_eb():
	main(self.get_node("."))


func _on_StaticBody_brake_wear_sensor_da():
	main(self.get_node("."))


func _on_StaticBody_brake_wear_sensor_fc():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_a():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_b():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_d():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_e():
	main(self.get_node("."))


func _on_StaticBody_trailer_wheel_f():
	main(self.get_node("."))


func _on_StaticBody_fridge():
	main(self.get_node("."))


func _on_StaticBody_truck_wheel_c():
	main(self.get_node("."))
