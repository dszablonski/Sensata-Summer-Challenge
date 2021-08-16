extends MeshInstance

# Selected colour, red
const selected = Color(0,0,0)
# Clear colour, white
const clear = Color(1,1,1)
# When everything is okay, green
const good = Color(0,1,0)
# When something is near a limit, yellow
const caution = Color(1,1,0)
# When something is at a critical point, red
const warning = Color(1,0,0)

var current_date = 1
var current_time = 0

# Function to make all borders white
func clear_borders(node, colour):
	# Fetches the parent node (root of the tree, Truck) and then loops through all its
	# children
	for i in node.get_parent().get_children():
		# Stores the first surface material of current object being looped 
		# through in the variable mat
		var mat = i.get_surface_material(0)
		# If the albedo (colour) of the material is white or has no colour (is the void),
		if mat.get_shader_param("albedo") == Color(1,1,1,1) or mat.get_shader_param("albedo") == Color(0,0,0,0):
			# then skip it
			pass
		# Otherwise, change it to the colour that has been passed through to the
		# function
		else:
			change_border(i, colour)

# Function to change the border
func change_border(get_mesh, get_colour):
	print("Border texture changed")
	# Gets the material of the mesh passed into the function
	var material = get_mesh.get_surface_material(0)
	# Sets the albedo of the shader to the colour passed into the function
	material.set_shader_param("albedo", get_colour)

# This is what will be run when a mesh is clicked
func main(meshInstance):
	# Run the clear_borders function
	clear_borders(meshInstance, clear)
	# Run the change_border function to change the colour of the border of the 
	# mesh passed through
	change_border(meshInstance, selected)

# These functions will run when a certain object is clicked on, passing through
# that object into the main function.

# Truck Wheel A
func _on_StaticBody_truck_wheel_a():
	main(self.get_node("."))

# Freezer
func _on_StaticBody_freezer():
	main(self.get_node("."))

# This function will be run when the clear signal is sent out, running the
# clear_borders function
func _on_StaticBody_clear():
	clear_borders(self.get_node("."), clear)

# Truck Wheel B
func _on_StaticBody_truck_wheel_b():
	main(self.get_node("."))

# Trailer Wheel C
func _on_StaticBody_trailer_wheel_c():
	main(self.get_node("."))

# Truck Wheel D
func _on_StaticBody_truck_wheel_d():
	main(self.get_node("."))

# Truck Wheel E
func _on_StaticBody_truck_wheel_e():
	main(self.get_node("."))

# Truck Wheel F
func _on_StaticBody_truck_wheel_f():
	main(self.get_node("."))

# Trailer Wheel A
func _on_StaticBody_trailer_wheel_a():
	main(self.get_node("."))

# Trailer Wheel B
func _on_StaticBody_trailer_wheel_b():
	main(self.get_node("."))

# Trailer Wheel D
func _on_StaticBody_trailer_wheel_d():
	main(self.get_node("."))

# Trailer Wheel E
func _on_StaticBody_trailer_wheel_e():
	main(self.get_node("."))

# Trailer Wheel F
func _on_StaticBody_trailer_wheel_f():
	main(self.get_node("."))

# Fridge
func _on_StaticBody_fridge():
	main(self.get_node("."))

# Truck Wheel C
func _on_StaticBody_truck_wheel_c():
	main(self.get_node("."))
