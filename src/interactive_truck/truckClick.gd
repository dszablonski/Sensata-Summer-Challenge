extends StaticBody

signal truck_wheel_a
signal truck_wheel_b
signal truck_wheel_c
signal truck_wheel_d
signal truck_wheel_e
signal truck_wheel_f
signal brake_wear_sensor_ab
signal brake_wear_sensor_eb
signal brake_wear_sensor_da
signal brake_wear_sensor_fc
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
	if $CollisionShape.is_in_group("brakeWearSensorAB"):
		# perhaps this sensor could be returned when the wheels are clicked
		# rather when the the bar itself is clicked
		emit_signal("brake_wear_sensor_ab")
		return "brake wear Sensor AB clicked"
		
	elif $CollisionShape.is_in_group("truckWheelA"):
		emit_signal("truck_wheel_a")
		return "Truck wheel A selected"
		
	elif $CollisionShape.is_in_group("truckWheelB"):
		emit_signal("truck_wheel_b")
		return "truck wheel B clicked"
		
	elif $CollisionShape.is_in_group("truckWheelC"):
		emit_signal("truck_wheel_c")
		return "truck wheel C clicked"
		
	elif $CollisionShape.is_in_group("truckWheelD"):
		emit_signal("truck_wheel_d")
		return "truck wheel D clicked"
		
	elif $CollisionShape.is_in_group("truckWheelE"):
		emit_signal("truck_wheel_e")
		return "truck wheel E clicked"
		
	elif $CollisionShape.is_in_group("truckWheelF"):
		emit_signal("truck_wheel_f")
		return "truck wheel F clicked"
		
	elif $CollisionShape.is_in_group("brakeWearAndWeightSensorEB"):
		# perhaps the weight part of these sensors could be returned when
		# the trailer parts are clicked, rather than when the actual 
		# bars are
		emit_signal("brake_wear_sensor_fc")
		return "brake wear and weight sensor EB clicked"
		
	elif $CollisionShape.is_in_group("brakeWearAndWeightSensorDA"):
		emit_signal("brake_wear_sensor_eb")
		return "brake wear and weight sensor DA clicked"
		
	elif $CollisionShape.is_in_group("brakeWearSensorFC"):
		emit_signal("brake_wear_sensor_fc")
		return "brake wear sensor FC clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelA"):
		emit_signal("trailer_wheel_a")
		return "trailer wheel A clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelB"):
		emit_signal("trailer_wheel_b")
		return "trailer wheel B clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelC"):
		emit_signal("trailer_wheel_c")
		return "trailer wheel C clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelD"):
		emit_signal("trailer_wheel_d")
		return "trailer wheel D clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelE"):
		emit_signal("trailer_wheel_e")
		return "trailer wheel E clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelF"):
		emit_signal("trailer_wheel_f")
		return "trailer wheel F"
		
	elif $CollisionShape.is_in_group("freezer"):
		emit_signal("freezer")
		return "freezer clicked"
		
	elif $CollisionShape.is_in_group("fridge"):
		emit_signal("fridge")
		return "fridge clicked"
	elif $CollisionShape.is_in_group("void"):
		emit_signal("clear")
	else:
		emit_signal("clear")

func _input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print(get_data())
