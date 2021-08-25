extends StaticBody

# All the signals this script can send out
signal truck_wheel_a
signal truck_wheel_b
signal truck_wheel_c
signal truck_wheel_d
signal truck_wheel_e
signal truck_wheel_f
signal trailer_wheel_a
signal trailer_wheel_b
signal trailer_wheel_c
signal trailer_wheel_d
signal trailer_wheel_e
signal trailer_wheel_f
signal freezer
signal fridge
signal clear


func get_data():
	# Plan is to then fetch the data for that part and do something with it
	# and then change the albedo of outline texture for that part to highlight
	# that it is selected.
	# certain parts (such as the actual truck and some of the connecting cyllinders
	# won't be clickable because they don't have sensors, meaning they don't
	# need to be clicked.
	#
	#
	# Also think it would be a good idea to try and make this look a little 
	# or making it look less clunky

	if $CollisionShape.is_in_group("truckWheelA"):
		# Will get sensors for Tire Pressure Truck Wheel A, Brake Wear Truck Wheel
		# A, and Wheel Bearing Temp Truck Wheel A
		emit_signal("truck_wheel_a")
		return "Truck wheel A selected"

	elif $CollisionShape.is_in_group("truckWheelB"):
		# Will get sensors for Tire Pressure Truck Wheel B, Brake Wear Truck Wheel
		# B, and Wheel Bearing Temp Truck Wheel B
		emit_signal("truck_wheel_b")
		return "truck wheel B clicked"

	elif $CollisionShape.is_in_group("truckWheelC"):
		# Will get Tire Pressure and Wheel Bearing Temp Truck Wheel C sensor
		emit_signal("truck_wheel_c")
		return "truck wheel C clicked"

	elif $CollisionShape.is_in_group("truckWheelD"):
		# Will get Tire Pressure and Wheel Bearing Temp Truck Wheel D sensor
		emit_signal("truck_wheel_d")
		return "truck wheel D clicked"

	elif $CollisionShape.is_in_group("truckWheelE"):
		# Will get Tire Pressure Truck and Wheel Bearing Temp Wheel E sensor
		emit_signal("truck_wheel_e")
		return "truck wheel E clicked"

	elif $CollisionShape.is_in_group("truckWheelF"):
		# Will get Tire Pressure and Wheel Bearing Temp Truck Wheel F  sensor
		emit_signal("truck_wheel_f")
		return "truck wheel F clicked"

	elif $CollisionShape.is_in_group("trailerWheelA"):
		# Will get sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel A
		emit_signal("trailer_wheel_a")
		return "trailer wheel A clicked"

	elif $CollisionShape.is_in_group("trailerWheelB"):
		# Will get sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel B
		emit_signal("trailer_wheel_b")
		return "trailer wheel B clicked"

	elif $CollisionShape.is_in_group("trailerWheelC"):
		# Will get sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel C
		emit_signal("trailer_wheel_c")
		return "trailer wheel C clicked"

	elif $CollisionShape.is_in_group("trailerWheelD"):
		# Will get sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel D
		emit_signal("trailer_wheel_d")
		return "trailer wheel D clicked"

	elif $CollisionShape.is_in_group("trailerWheelE"):
		# Will get Sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel E
		emit_signal("trailer_wheel_e")
		return "trailer wheel E clicked"

	elif $CollisionShape.is_in_group("trailerWheelF"):
		# Will get Sensors for Tire Pressure, Wheel Bearing Temp and Brake Wear
		# for Trailer Wheel F
		emit_signal("trailer_wheel_f")
		return "trailer wheel F"

	elif $CollisionShape.is_in_group("freezer"):
		# Will get Sensors for Freezer Weight and Freezer Temp
		emit_signal("freezer")
		return "freezer clicked"

	elif $CollisionShape.is_in_group("fridge"):
		# Will get Sensors for Fridge Weight and Fridge Temp
		emit_signal("fridge")
		return "fridge clicked"
	# The signal clear will be called whenever the void mesh is clicked. 
	# The void mesh is just a cube with an invisible material which is at its
	# max size, ensuring when the void is clicked in the viewer that the truck 
	# selection will be cleared.
	elif $CollisionShape.is_in_group("void"):
		emit_signal("clear")
	# If anything on the truck that isn't selectable is clicked, the selection 
	# is cleared.
	else:
		emit_signal("clear")


func _input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print(get_data())
