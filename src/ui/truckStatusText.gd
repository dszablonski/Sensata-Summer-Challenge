extends GridContainer

onready var id = DatabaseFetch.read_db_time(1, GlobalDate.hour)

const good :String = "#00ff00" 
const warning :String = "#ff0000"
const caution :String = "#ffff00"

var sensors = {
	"Cube": ["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC", "TrailerWeightG"],
	"Cube001": ["TrailerTemperatureD", "TrailerTemperatureE", "TrailerTemperatureF", "TrailerWeightA", "TrailerWeightD", "TrailerWeightC", "TrailerWeightF"],
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

# Runs every frame (capped at 60fps)
func _physics_process(delta):
	# Checks if the freezer is loaded
	freezer_is_loaded = id["TrailerWeightG"] > 0
	fridge_is_loaded = id["TrailerWeightA"] > 0 or id["TrailerWeightD"] > 0 or id["TrailerWeightC"] > 0 or id["TrailerWeightF"] > 0
	id = DatabaseFetch.read_db_time(1, GlobalDate.hour)

# Clears the labels so the panel is blank
func clear():
	$RichTextLabel5.bbcode_text = ""
	$RichTextLabel.bbcode_text = ""
	$RichTextLabel2.bbcode_text = ""
	$RichTextLabel3.bbcode_text = ""
	$RichTextLabel4.bbcode_text = ""

func check_tyre_pressure(sensor):
	if sensor <= CriticalLimits.MIN_TYRE_PRESSURE or sensor >= CriticalLimits.MAX_TYRE_PRESSURE:
		return warning
	elif sensor <= CautionLimits.MIN_TYRE_PRESSURE or sensor >= CautionLimits.MAX_TYRE_PRESSURE: 
		return caution
	else:
		return good

func check_break_pads(sensor):
	if sensor <= CriticalLimits.MIN_BRAKE_PADS:
		return warning
	elif sensor <= CautionLimits.MIN_BRAKE_PADS:
		return caution
	else:
		return good

func check_wheel_bearing(sensor):
	if sensor >= CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		return warning
	elif sensor >= CautionLimits.MAX_WHEEL_BEARING_TEMP:
		return caution
	else:
		return good

func check_temp(sensor, loaded, crit_temp):
	if sensor >= crit_temp and loaded:
		return warning
	else:
		return good

func check_weight(sensor):
	if sensor >= CriticalLimits.MAX_WEIGHT:
		return warning
	elif sensor >= CautionLimits.MAX_WEIGHT:
		return caution
	else:
		return good

func trailer_wheels(wheel:String):
	var wheel_brake_color = check_break_pads(id[sensors[wheel][1]])
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheel][0]])
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheel]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheel][0]]]
	$RichTextLabel2.bbcode_text = "Brake Pad Wear: [color=%s]%s[/color]%%" %[wheel_brake_color, id[sensors[wheel][1]]]

func truck_wheel_df(wheels:String):
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	var wheel_bearing_color = check_wheel_bearing(id[sensors[wheels][1]])
	
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheels]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheels][0]]]
	$RichTextLabel2.bbcode_text = "Wheel Bearing Temperature: [color=%s]%s[/color]C" %[wheel_bearing_color, id[sensors[wheels][1]]]

func truck_wheel_ce(wheels:String):
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheels]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheels][0]]]

func truck_wheel_ab(wheels:String):
	var tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	var wheel_brake_color = check_break_pads(id[sensors[wheels][1]])
	var wheel_bearing_color = check_wheel_bearing(id[sensors[wheels][2]])
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheels]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheels][0]]]
	$RichTextLabel2.bbcode_text = "Brake Pad Wear: [color=%s]%s[/color]%%" %[wheel_brake_color, id[sensors[wheels][1]]]
	$RichTextLabel3.bbcode_text = "Wheel Bearing Temperature: [color=%s]%s[/color]C" %[wheel_bearing_color, id[sensors[wheels][2]]]

func _on_CubeStaticBody_mouse_entered():
	var temp_a_color = check_temp(id[sensors["Cube"][0]], freezer_is_loaded, CriticalLimits.MIN_FREEZER_TEMP)
	var temp_b_color = check_temp(id[sensors["Cube"][1]], freezer_is_loaded, CriticalLimits.MIN_FREEZER_TEMP)
	var temp_c_color = check_temp(id[sensors["Cube"][2]], freezer_is_loaded, CriticalLimits.MIN_FREEZER_TEMP)
	var weight_g_color = check_weight(id[sensors["Cube"][3]])
	
	
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]Freezer[/color]"
	$RichTextLabel.bbcode_text = "Temperature Sensor A : [color=%s]%s[/color]C" %[temp_a_color, int(id[sensors["Cube"][0]])]
	$RichTextLabel3.bbcode_text = "Temperature Sensor B : [color=%s]%s[/color]C" %[temp_b_color, int(id[sensors["Cube"][1]])]
	$RichTextLabel2.bbcode_text = "Temperature Sensor C : [color=%s]%s[/color]C" %[temp_c_color, int(id[sensors["Cube"][2]])]
	$RichTextLabel4.bbcode_text = "Weight Sensor G : [color=%s]%s[/color]KG" %[weight_g_color, int(id[sensors["Cube"][3]])]

func _on_CubeStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelFStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel F")

func _on_TrailerWheelFStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelEStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel E")

func _on_TrailerWheelEStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelDStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel D")


func _on_TrailerWheelDStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelCStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel C")


func _on_TrailerWheelCStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelBStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel B")


func _on_TrailerWheelBStaticBody_mouse_exited():
	clear()


func _on_TrailerWheelAStaticBody_mouse_entered():
	trailer_wheels("Trailer Wheel A")


func _on_TrailerWheelAStaticBody_mouse_exited():
	clear()


func _on_TruckWheelFStaticBody_mouse_entered():
	truck_wheel_df("Truck Wheel F")


func _on_TruckWheelFStaticBody_mouse_exited():
	clear()


func _on_TruckWheelEStaticBody_mouse_entered():
	truck_wheel_ce("Truck Wheel E")


func _on_TruckWheelEStaticBody_mouse_exited():
	clear()


func _on_TruckWheelDStaticBody_mouse_entered():
	truck_wheel_df("Truck Wheel D")


func _on_TruckWheelDStaticBody_mouse_exited():
	clear()


func _on_TruckWheelCStaticBody_mouse_entered():
	truck_wheel_ce("Truck Wheel C")


func _on_TruckWheelCStaticBody_mouse_exited():
	clear()


func _on_TruckWheelBStaticBody_mouse_entered():
	truck_wheel_ab("Truck Wheel B")


func _on_TruckWheelBStaticBody_mouse_exited():
	clear()


func _on_TruckWheelStaticBody_mouse_entered():
	truck_wheel_ab("Truck Wheel A")


func _on_TruckWheelStaticBody_mouse_exited():
	clear()


func _on_FridgeStaticBody_mouse_entered():
	var weight_avg = (id[sensors["Cube001"][3]] + id[sensors["Cube001"][4]] + id[sensors["Cube001"][5]] + id[sensors["Cube001"][6]]) / 4
	var weight_color = check_weight(weight_avg)
	var temp_d_color = check_temp(id[sensors["Cube001"][0]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP)
	var temp_e_color = check_temp(id[sensors["Cube001"][1]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP)
	var temp_f_color = check_temp(id[sensors["Cube001"][2]], fridge_is_loaded, CriticalLimits.MAX_FRIDGE_TEMP)
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]Fridge[/color]"
	$RichTextLabel.bbcode_text = "Temperature Sensor D : [color=%s]%s[/color]C" %[temp_d_color, int(id[sensors["Cube001"][0]])]
	$RichTextLabel3.bbcode_text = "Temperature Sensor E : [color=%s]%s[/color]C" %[temp_e_color, int(id[sensors["Cube001"][1]])]
	$RichTextLabel2.bbcode_text = "Temperature Sensor F : [color=%s]%s[/color]C" %[temp_f_color, int(id[sensors["Cube001"][2]])]
	$RichTextLabel4.bbcode_text = "Avg. Weight (Sensors A, D, C & F) : [color=%s]%s[/color]KG" %[weight_color, weight_avg]
func _on_FridgeStaticBody_mouse_exited():
	clear()
