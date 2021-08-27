extends GridContainer

# Stores hex value for green
const good: String = "#63c74d"
# Stores hex value for red 
const warning: String = "#e43b44"
# Stores hex value for yellow
const caution: String = "#fee761"
var clicked = false
var selected_mesh: String = ""

# Dictionary of the meshes and their corresponding 
var sensors = {
	"Cube": ["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC", "TrailerWeightG"],
	"Cube001":
	[
		"TrailerTemperatureD",
		"TrailerTemperatureE",
		"TrailerTemperatureF",
		"TrailerWeightA",
		"TrailerWeightD",
		"TrailerWeightC",
		"TrailerWeightF"
	],
	"Truck Wheel A": ["TruckTyrePressureA", "TruckBrakePadsA", "TruckWheelBearingTempA"],
	"Truck Wheel B": ["TruckTyrePressureB", "TruckBrakePadsB", "TruckWheelBearingTempB"],
	"Truck Wheel C": ["TruckTyrePressureC"],
	"Truck Wheel E": ["TruckTyrePressureE"],
	"Truck Wheel D": ["TruckTyrePressureD", "TruckWheelBearingTempD"],
	"Truck Wheel F": ["TruckTyrePressureF", "TruckWheelBearingTempF"],
	"Trailer Wheel A": ["TrailerTyrePressureA", "TrailerBrakePadsA"],
	"Trailer Wheel B": ["TrailerTyrePressureB", "TrailerBrakePadsB"],
	"Trailer Wheel C": ["TrailerTyrePressureC", "TrailerBrakePadsC"],
	"Trailer Wheel D": ["TrailerTyrePressureD", "TrailerBrakePadsD"],
	"Trailer Wheel E": ["TrailerTyrePressureE", "TrailerBrakePadsE"],
	"Trailer Wheel F": ["TrailerTyrePressureF", "TrailerBrakePadsF"]
}

var freezer_is_loaded
var fridge_is_loaded
var id


func _ready() -> void:
	# When the date/time is changed the id should be updated.
	GlobalDate.connect("date_time_changed", self, "_on_date_time_changed")
	_on_date_time_changed()


func _on_date_time_changed() -> void:
	# Fetches the dictionary of values
	id = DatabaseFetch.read_db_current_date_time()
	# Checks if the freezer is loaded (sensor value greater than 0, returns 
	# either True or False
	freezer_is_loaded = id["TrailerWeightG"] > 0
	# Checks if the freezer is loaded (sensor value greater than 0, returns
	# either True or False
	fridge_is_loaded = (
		id["TrailerWeightA"] > 0
		or id["TrailerWeightD"] > 0
		or id["TrailerWeightC"] > 0
		or id["TrailerWeightF"] > 0
	)
	match selected_mesh:
		"Truck Wheel A":
			truck_wheel_ab("Truck Wheel A")
		"Truck Wheel B":
			truck_wheel_ab("Truck Wheel B")
		"Truck Wheel C":
			truck_wheel_ce("Truck Wheel C")
		"Truck Wheel D":
			truck_wheel_df("Truck Wheel D")
		"Truck Wheel E":
			truck_wheel_ce("Truck Wheel E")
		"Truck Wheel F":
			truck_wheel_df("Truck Wheel F")
		"Trailer Wheel A":
			trailer_wheels("Trailer Wheel A")
		"Trailer Wheel B":
			trailer_wheels("Trailer Wheel B")
		"Trailer Wheel C":
			trailer_wheels("Trailer Wheel C")
		"Trailer Wheel D":
			trailer_wheels("Trailer Wheel D")
		"Trailer Wheel E":
			trailer_wheels("Trailer Wheel E")
		"Trailer Wheel F":
			trailer_wheels("Trailer Wheel F")
		"Freezer":
			freezer()
		"Fridge":
			fridge()


# Clears the labels so the panel is blank
func clear():
	$RichTextLabel5.bbcode_text = ""
	$RichTextLabel.bbcode_text = ""
	$RichTextLabel2.bbcode_text = ""
	$RichTextLabel3.bbcode_text = ""
	$RichTextLabel4.bbcode_text = ""
	$RichTextLabel7.bbcode_text = ""
	$RichTextLabel8.bbcode_text = ""
	$RichTextLabel9.bbcode_text = ""


# Checks the status of tyre pressure
func check_tyre_pressure(sensor):
	# If the sensor passed through is less than or equal to the critical minimum for tyre 
	# pressure or more than the critical maximum,  
	if sensor < CriticalLimits.MIN_TYRE_PRESSURE or sensor > CriticalLimits.MAX_TYRE_PRESSURE:
		# Return the variable warning
		return warning
	# If the sensor passed through is less than or equal to the caution minimum for tyre
	# pressure or more than the caution maxium,
	elif sensor < CautionLimits.MIN_TYRE_PRESSURE or sensor > CautionLimits.MAX_TYRE_PRESSURE:
		# Return the variable caution
		return caution
	# Otherwise
	else:
		# Return the variable good
		return good


# Checks the break pad status
func check_break_pads(sensor):
	# If the sensor passed through is less than or equal to the critical minimum
	#  for brake pad percentage,
	if sensor < CriticalLimits.MIN_BRAKE_PADS:
		# Return the variable warning
		return warning
	# If the sensor passed through is less than or equal to  the caution minimum
	#  for brake pad percentage,
	elif sensor < CautionLimits.MIN_BRAKE_PADS:
		# Return the variable caution
		return caution
	# Otherwise
	else:
		# Return the variable good
		return good


# Checks the wheel bearing temperature status
func check_wheel_bearing(sensor):
	# If the sensor passed through is higher or equal to the maximum critical
	# wheel bearing temperature,
	if sensor > CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		# Return the warning variable
		return warning
	# If the sensor passed through is higher or equal to the maximum caution
	# wheel bearing temperature
	elif sensor > CautionLimits.MAX_WHEEL_BEARING_TEMP:
		# Returnt the caution variable
		return caution
	# Otherwise
	else:
		# Return the variable good
		return good


# Checks temperature status
func check_temp(sensor, loaded, crit_temp):
	# If the sensor is greater than the critical temperature limit and the truck
	# is loaded,
	if sensor > crit_temp and loaded:
		# return warning
		return warning
	# Otherwise
	else:
		# Return good
		return good


# Checks weight status
func check_weight(sensor):
	# If the sensor is greater than or equal to the crticial weight limit,
	if sensor > CriticalLimits.MAX_WEIGHT:
		# return the variable warning
		return warning
	# If the sensor is greater than or equal to the caution weight limit,
	elif sensor > CautionLimits.MAX_WEIGHT:
		# return the variable caution
		return caution
	# Otherwise
	else:
		# return the variable good
		return good


# Function to return stats for the trailer wheels
func trailer_wheels(wheel: String):
	# Sets the color of the brake pad wear based on its status
	var wheel_brake_color = check_break_pads(id[sensors[wheel][1]])
	# Sets the color of the tyre pressure based on its status
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheel][0]])

	# Name of the wheel passed through, colored light blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" % [wheel]
	# Returns the stat of the tyre pressure, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Tyre Pressure: [color=%s]%s[/color] psi"
		% [tyre_pressure_color, id[sensors[wheel][0]]]
	)
	# Returns the stat of the brake pad wear %, coloring it the color of its 
	# status
	$RichTextLabel2.bbcode_text = (
		"Brake Pad Wear: [color=%s]%s[/color]%%"
		% [wheel_brake_color, id[sensors[wheel][1]]]
	)


# Function to return stats of truck wheels d & f
func truck_wheel_df(wheels: String):
	# Sets the color of the tyre pressure based on its status
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	# Sets the color of the wheel bearing based on its status
	var wheel_bearing_color = check_wheel_bearing(id[sensors[wheels][1]])

	# Name of the wheel passed through, colored light blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" % [wheels]
	# Returns the stat of the tyre pressure, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Tyre Pressure: [color=%s]%s[/color] psi"
		% [tyre_pressure_color, id[sensors[wheels][0]]]
	)
	# Returns the stat of the wheel bearing temp, coloring it the color of its status
	$RichTextLabel2.bbcode_text = (
		"Wheel Bearing Temperature: [color=%s]%s[/color]°C"
		% [wheel_bearing_color, id[sensors[wheels][1]]]
	)


func truck_wheel_ce(wheels: String):
	# Sets the color of the tyre pressure based on its status
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])

	# Name of the wheel passed through, colored light blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" % [wheels]
	# Returns the stat of the tyre pressure, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Tyre Pressure: [color=%s]%s[/color] psi"
		% [tyre_pressure_color, id[sensors[wheels][0]]]
	)


func truck_wheel_ab(wheels: String):
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	var wheel_brake_color = check_break_pads(id[sensors[wheels][1]])
	var wheel_bearing_color = check_wheel_bearing(id[sensors[wheels][2]])

	# Name of the wheel passed through, colored light blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" % [wheels]
	# Returns the stat of the tyre pressure, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Tyre Pressure: [color=%s]%s[/color] psi"
		% [tyre_pressure_color, id[sensors[wheels][0]]]
	)
	# Returns the stat of the brake pad wear %, coloring it the color of its 
	# status
	$RichTextLabel2.bbcode_text = (
		"Brake Pad Wear: [color=%s]%s[/color]%%"
		% [wheel_brake_color, id[sensors[wheels][1]]]
	)
	# Returns the stat of the wheel bearing temp, coloring it the color of its status
	$RichTextLabel3.bbcode_text = (
		"Wheel Bearing Temperature: [color=%s]%s[/color]°C"
		% [wheel_bearing_color, id[sensors[wheels][2]]]
	)

func fridge():
	# Gets the color status for each weight sensor on the fridge
	var weight_color_a = check_weight(id[sensors["Cube001"][3]])
	var weight_color_d = check_weight(id[sensors["Cube001"][4]])
	var weight_color_c = check_weight(id[sensors["Cube001"][5]])
	var weight_color_f = check_weight(id[sensors["Cube001"][6]])
	# Gets teh color status for temp sensor d
	var temp_d_color = check_temp(
		id[sensors["Cube001"][0]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP
	)
	# Gets teh color status for temp sensor e
	var temp_e_color = check_temp(
		id[sensors["Cube001"][1]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP
	)
	# gets the color satus for temp sensor f
	var temp_f_color = check_temp(
		id[sensors["Cube001"][2]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP
	)
		
	# The word fridge colored blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]Fridge[/color]"
	# Returns the stat of temp sensor d, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Temperature Sensor D : [color=%s]%s[/color]°C"
		% [temp_d_color, int(id[sensors["Cube001"][0]])]
	)
	# Returns the stat of temp sensor e, coloring it the color of its status
	$RichTextLabel3.bbcode_text = (
		"Temperature Sensor E : [color=%s]%s[/color]°C"
		% [temp_e_color, int(id[sensors["Cube001"][1]])]
	)
	# Returns the stat of temp sensor f, coloring it the color of its status
	$RichTextLabel2.bbcode_text = (
		"Temperature Sensor F : [color=%s]%s[/color]°C"
		% [temp_f_color, int(id[sensors["Cube001"][2]])]
	)
	# Returns teh stat of the avg weight and colors it the color of its status
	$RichTextLabel4.bbcode_text = (
		"Weight Sensor A : [color=%s]%s[/color] kg"
		% [weight_color_a, id[sensors["Cube001"][3]]]
	)
	$RichTextLabel7.bbcode_text = (
		"Weight Sensor D : [color=%s]%s[/color] kg"
		% [weight_color_d, id[sensors["Cube001"][4]]]
	)
	$RichTextLabel8.bbcode_text = (
		"Weight Sensor C : [color=%s]%s[/color] kg"
		% [weight_color_c, id[sensors["Cube001"][5]]]
	)
	$RichTextLabel9.bbcode_text = (
		"Weight Sensor F : [color=%s]%s[/color] kg"
		% [weight_color_f, id[sensors["Cube001"][6]]]
	)

func freezer():
	# Sets the color of temp sensor a on its status
	var temp_a_color = check_temp(
		id[sensors["Cube"][0]], freezer_is_loaded, CriticalLimits.MAX_FREEZER_TEMP
	)
	# Sets the color of temp sensor b based on its status
	var temp_b_color = check_temp(
		id[sensors["Cube"][1]], freezer_is_loaded, CriticalLimits.MAX_FREEZER_TEMP
	)
	# Sets the color of temp sensor c based on its status
	var temp_c_color = check_temp(
		id[sensors["Cube"][2]], freezer_is_loaded, CriticalLimits.MAX_FREEZER_TEMP
	)
	# Sets the color of weight sensor g based on its status
	var weight_g_color = check_weight(id[sensors["Cube"][3]])

	# The word Freezer colored blue
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]Freezer[/color]"
	# Returns the stat of temp sensor a, coloring it the color of its status
	$RichTextLabel.bbcode_text = (
		"Temperature Sensor A : [color=%s]%s[/color]°C"
		% [temp_a_color, int(id[sensors["Cube"][0]])]
	)
	# Returns the stat of temp sensor b, coloring it the color of its status
	$RichTextLabel3.bbcode_text = (
		"Temperature Sensor B : [color=%s]%s[/color]°C"
		% [temp_b_color, int(id[sensors["Cube"][1]])]
	)
	# Returns the stat of temp sensor c, coloring it the color of its status
	$RichTextLabel2.bbcode_text = (
		"Temperature Sensor C : [color=%s]%s[/color]°C"
		% [temp_c_color, int(id[sensors["Cube"][2]])]
	)
	# Returns the stat of weight sensor g, coloring it the color of its status
	$RichTextLabel4.bbcode_text = (
		"Weight Sensor G : [color=%s]%s[/color] kg"
		% [weight_g_color, int(id[sensors["Cube"][3]])]
	)

# The following functions are called when the mouse enters a mesh or exits a mesh
# On mouse enter, they will show the stats of their respective sensors, but if
# the mesh is clicked nothing will happen. 
func _on_CubeStaticBody_mouse_entered():
	if not clicked:
		freezer()
	else:
		pass


func _on_FridgeStaticBody_mouse_entered():
	if not clicked:
		fridge()
	else:
		pass

func _on_FridgeStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass



func _on_CubeStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelFStaticBody_mouse_entered():
	if not clicked:
		trailer_wheels("Trailer Wheel F")
	else:
		pass

func _on_TrailerWheelFStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelEStaticBody_mouse_entered():
	if not clicked:
		trailer_wheels("Trailer Wheel E")
	else:
		pass


func _on_TrailerWheelEStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelDStaticBody_mouse_entered():
	if not clicked:
		trailer_wheels("Trailer Wheel D")
	else:
		pass


func _on_TrailerWheelDStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelCStaticBody_mouse_entered():
	if not clicked:
		trailer_wheels("Trailer Wheel C")
	else:
		pass


func _on_TrailerWheelCStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelBStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel B")


func _on_TrailerWheelBStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TrailerWheelAStaticBody_mouse_entered():
	if not clicked:
		trailer_wheels("Trailer Wheel A")
	else:
		pass


func _on_TrailerWheelAStaticBody_mouse_exited():
	if clicked == false:
		clear()
	else:
		pass


func _on_TruckWheelFStaticBody_mouse_entered():
	truck_wheel_df("Truck Wheel F")


func _on_TruckWheelFStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TruckWheelEStaticBody_mouse_entered():
	if not clicked:
		truck_wheel_ce("Truck Wheel E")
	else:
		pass


func _on_TruckWheelEStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TruckWheelDStaticBody_mouse_entered():
	if not clicked:
		truck_wheel_df("Truck Wheel D")
	else:
		pass


func _on_TruckWheelDStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TruckWheelCStaticBody_mouse_entered():
	if not clicked:
		truck_wheel_ce("Truck Wheel C")
	else:
		pass


func _on_TruckWheelCStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TruckWheelBStaticBody_mouse_entered():
	if not clicked:
		truck_wheel_ab("Truck Wheel B")
	else:
		pass


func _on_TruckWheelBStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass


func _on_TruckWheelStaticBody_mouse_entered():
	if not clicked:
		truck_wheel_ab("Truck Wheel A")
	else:
		pass


func _on_TruckWheelStaticBody_mouse_exited():
	if not clicked:
		clear()
	else:
		pass

# This will be called when the user clicks into the void to clear the selection.
# The clicked variable will be set to false and the clear() function will be 
# called.
func _on_StaticBody_clear():
	selected_mesh = ""
	clicked = false
	clear()

# These functions are run when a certain mesh is clicked.
# They will check whether a mesh is clicked first, if not they will set the #
# "clicked" function to "true" and call upon their respective function. 
# If clicked is true, the status panel will be clerd before its respective
# function is called again.
func _on_TruckWheelStaticBody_truck_wheel_a():
	selected_mesh = "Truck Wheel A"
	if not clicked:
		clicked = true
		truck_wheel_ab("Truck Wheel A")
	else:
		clear()
		clicked = true
		truck_wheel_ab("Truck Wheel A")


func _on_TruckWheelBStaticBody_truck_wheel_b():
	selected_mesh = "Truck Wheel B"
	if not clicked:
		clicked = true
		truck_wheel_ab("Truck Wheel B")
	else:
		clear()
		clicked = true
		truck_wheel_ab("Truck Wheel B")


func _on_TruckWheelCStaticBody_truck_wheel_c():
	selected_mesh = "Truck Wheel C"
	if not clicked:
		clicked = true
		truck_wheel_ce("Truck Wheel C")
	else:
		clear()
		clicked = true
		truck_wheel_ce("Truck Wheel C")


func _on_TruckWheelDStaticBody_truck_wheel_d():
	selected_mesh = "Truck Wheel D"
	if not clicked:
		clicked = true
		truck_wheel_df("Truck Wheel D")
	else:
		clear()
		clicked = true
		truck_wheel_df("Truck Wheel D")


func _on_TruckWheelEStaticBody_truck_wheel_e():
	selected_mesh = "Truck Wheel E"
	if not clicked:
		clicked = true
		truck_wheel_ce("Truck Wheel E")
	else:
		clear()
		clicked = true
		truck_wheel_ce("Truck Wheel E")


func _on_TruckWheelFStaticBody_truck_wheel_f():
	selected_mesh = "Truck Wheel F"
	if not clicked:
		clicked = true
		truck_wheel_df("Truck Wheel F")
	else:
		clear()
		clicked = true
		truck_wheel_df("Truck Wheel F")


func _on_TrailerWheelAStaticBody_trailer_wheel_a():
	selected_mesh = "Trailer Wheel A"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel A")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel A")

func _on_TrailerWheelBStaticBody_trailer_wheel_b():
	selected_mesh = "Trailer Wheel B"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel B")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel B")

func _on_TrailerWheelCStaticBody_trailer_wheel_c():
	selected_mesh = "Trailer Wheel C"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel C")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel C")

func _on_TrailerWheelDStaticBody_trailer_wheel_d():
	selected_mesh = "Trailer Wheel D"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel D")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel D")


func _on_TrailerWheelEStaticBody_trailer_wheel_e():
	selected_mesh = "Trailer Wheel E"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel E")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel E")


func _on_TrailerWheelFStaticBody_trailer_wheel_f():
	selected_mesh = "Trailer Wheel F"
	if not clicked:
		clicked = true
		trailer_wheels("Trailer Wheel F")
	else:
		clear()
		clicked = true
		trailer_wheels("Trailer Wheel F")


func _on_CubeStaticBody_freezer():
	selected_mesh = "Freezer"
	if not clicked:
		clicked = true
		freezer()
	else:
		clear()
		clicked = true
		freezer()


func _on_FridgeStaticBody_fridge():
	selected_mesh = "Fridge"
	if not clicked:
		clicked = true
		fridge()
	else:
		clear()
		clicked = true
		fridge()
