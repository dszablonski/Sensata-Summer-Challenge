extends StaticBody

signal truck_wheel_a
signal freezer
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
		return "brake wear Sensor AB clicked"
		
	elif $CollisionShape.is_in_group("truckWheelA"):
		emit_signal("truck_wheel_a")
		return "Truck wheel A selected"
		
	elif $CollisionShape.is_in_group("truckWheelB"):
		return "truck wheel B clicked"
		
	elif $CollisionShape.is_in_group("truckWheelC"):
		return "truck wheel C clicked"
		
	elif $CollisionShape.is_in_group("truckWheelD"):
		return "truck wheel D clicked"
		
	elif $CollisionShape.is_in_group("truckWheelE"):
		return "truck wheel E clicked"
		
	elif $CollisionShape.is_in_group("truckWheelF"):
		return "truck wheel F clicked"
		
	elif $CollisionShape.is_in_group("brakeWearAndWeightSensorEB"):
		# perhaps the weight part of these sensors could be returned when
		# the trailer parts are clicked, rather than when the actual 
		# bars are
		return "brake wear and weight sensor EB clicked"
		
	elif $CollisionShape.is_in_group("brakeWearAndWeightSensorDA"):
		return "brake wear and weight sensor DA clicked"
		
	elif $CollisionShape.is_in_group("brakeWearSensorFC"):
		return "brake wear sensor FC clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelA"):
		return "trailer wheel A clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelB"):
		return "trailer wheel B clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelC"):
		return "trailer wheel C clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelD"):
		return "trailer wheel D clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelE"):
		return "trailer wheel E clicked"
		
	elif $CollisionShape.is_in_group("trailerWheelF"):
		return "trailer wheel F"
		
	elif $CollisionShape.is_in_group("freezer"):
		emit_signal("freezer")
		return "freezer clicked"
		
	elif $CollisionShape.is_in_group("fridge"):
		return "fridge clicked"
	elif $CollisionShape.is_in_group("truck"):
		pass
		emit_signal("clear")
	else:
		emit_signal("clear")
		pass	

func _input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print(get_data())
