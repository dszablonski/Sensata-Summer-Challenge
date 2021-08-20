extends GridContainer

onready var id = DatabaseFetch.read_db_time(1, GlobalDate.hour)

const good :String = "#00ff00" 
const warning :String = "#ff0000"
const caution :String = "#ffff00"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sensors = {
	"Cube": ["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC", "TrailerWeightG"],
	"Cube001": ["TrailerTemperatureD", "TrailerTemperatuerE", "TrailerTemperatureF", "TrailerWeightA", "TrailerWeightD", "TrailerWeightC", "TrailerWeightF"],
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

func trailer_wheels(wheel:String):
	var wheel_brake_color = good
	var tyre_pressure_color = good
	
	tyre_pressure_color = check_tyre_pressure(id[sensors[wheel][0]])
	
	if id[sensors[wheel][1]] <= CriticalLimits.MIN_BRAKE_PADS:
		wheel_brake_color = warning
	elif id[sensors[wheel][1]] <= CautionLimits.MIN_BRAKE_PADS:
		wheel_brake_color = caution
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheel]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheel][0]]]
	$RichTextLabel2.bbcode_text = "Brake Pad Wear: [color=%s]%s[/color]%%" %[wheel_brake_color, id[sensors[wheel][1]]]

func truck_wheel_df(wheels:String):
	var tyre_pressure_color = good
	var wheel_bearing_color = good
	
	tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	
	if id[sensors[wheels][1]] >= CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		wheel_bearing_color = warning
	elif id[sensors[wheels][1]] >= CautionLimits.MAX_WHEEL_BEARING_TEMP:
		wheel_bearing_color = caution
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheels]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheels][0]]]
	$RichTextLabel2.bbcode_text = "Wheel Bearing Temperature: [color=%s]%s[/color]C" %[wheel_bearing_color, id[sensors[wheels][1]]]

func truck_wheel_ce(wheels:String):
	var tyre_pressure_color = good
	
	tyre_pressure_color = check_tyre_pressure(id[sensors[wheels][0]])
	
	$RichTextLabel5.bbcode_text = "[color=#00e1ff]%s[/color]" %[wheels]
	$RichTextLabel.bbcode_text = "Tyre Pressure: [color=%s]%s[/color]PSI" %[tyre_pressure_color, id[sensors[wheels][0]]]

func truck_wheel_ab(wheels:String):
	pass

func _on_CubeStaticBody_mouse_entered():
	var temp_a_color = good
	var temp_b_color = good
	var temp_c_color = good
	var weight_g_color = good
	
	if id[sensors["Cube"][0]] >= CriticalLimits.MIN_FREEZER_TEMP and freezer_is_loaded:
		temp_a_color = warning
	
	if id[sensors["Cube"][1]] >= CriticalLimits.MIN_FREEZER_TEMP and freezer_is_loaded:
		temp_b_color = warning
		
	if id[sensors["Cube"][2]] >= CriticalLimits.MIN_FREEZER_TEMP and freezer_is_loaded:
		temp_c_color = warning
	
	if id[sensors["Cube"][3]] >= CriticalLimits.MAX_WEIGHT:
		weight_g_color = warning
	elif id[sensors["Cube"][3]] >= CautionLimits.MAX_WEIGHT:
		weight_g_color = caution
	
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
	pass # Replace with function body.


func _on_TruckWheelBStaticBody_mouse_exited():
	clear()


func _on_TruckWheelStaticBody_mouse_entered():
	pass # Replace with function body.


func _on_TruckWheelStaticBody_mouse_exited():
	clear()


func _on_FridgeStaticBody_mouse_entered():
	pass # Replace with function body.


func _on_FridgeStaticBody_mouse_exited():
	clear()
