extends Spatial

# When everything is okay, green
const good = Color(0,1,0)
# When something is near a limit, yellow
const caution = Color(1,1,0)
# When something is at a critical point, red
const warning = Color(1,0,0)


# These are placeholders for now until we get the date/time selection working
var current_date = 1
var current_time = 14

var current_id

# A dictionary of the meshes and the sensors which they are tied to. 
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

# These variables hold the nodes for the meshes whose materials will be changed
onready var freezer = get_node("Cube")
onready var fridge = get_node("Cube001")
onready var truck_wheel_a = get_node("Truck Wheel A")
onready var truck_wheel_b = get_node("Truck Wheel B")
onready var truck_wheel_c = get_node("Truck Wheel C")
onready var truck_wheel_e = get_node("Truck Wheel E")
onready var truck_wheel_d = get_node("Truck Wheel D")
onready var truck_wheel_f = get_node("Truck Wheel F")
onready var trailer_wheel_a = get_node("Trailer Wheel A")
onready var trailer_wheel_b = get_node("Trailer Wheel B")
onready var trailer_wheel_c = get_node("Trailer Wheel C")
onready var trailer_wheel_d = get_node("Trailer Wheel D")
onready var trailer_wheel_e = get_node("Trailer Wheel E")
onready var trailer_wheel_f = get_node("Trailer Wheel F")

func fridge_limits(id: Dictionary):
		var sensor = sensors["Cube001"]
		
		#Did this as a variable to save space on the if statement
		# Basically gets the stats from the weight sensors and sees if any of 
		# them are above 0
		var is_loaded = id[sensor[3]] > 0 or id[sensor[4]] > 0 or id[sensor[5]] > 0 or id[sensor[6]] > 0
		
		var weight_array = [id[sensor[3]], id[sensor[4]], id[sensor[5]], id[sensor[6]]]
		var weight_differential = weight_array.max() - weight_array.min()
		
		
		for i in range(1):
			if int(id[sensor[i]]) >= CriticalLimits.MAX_FRIDGE_TEMP and is_loaded:
				return warning
			else:
				pass
		for j in range(2, 7):
			if int(id[sensor[j]]) >= CriticalLimits.MAX_WEIGHT:
				return warning
			elif int(id[sensor[j]]) >= CautionLimits.MAX_WEIGHT:
				return caution
			elif weight_differential >= CriticalLimits.MAX_WEIGHT_DIFFERENTIAL:
				return warning
			elif weight_differential >= CautionLimits.MAX_WEIGHT_DIFFERENTIAL:
				return caution
			else:
				return good



func truck_wheel_ab_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	if int(id[sensor[0]]) >= CriticalLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CriticalLimits.MIN_TYRE_PRESSURE:
			return warning
	elif int(id[sensor[0]]) >= CautionLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CautionLimits.MIN_TYRE_PRESSURE:
		return caution
	elif int(id[sensor[1]]) <= CriticalLimits.MIN_BRAKE_PADS:
		return warning
	elif int(id[sensor[1]]) <= CautionLimits.MIN_BRAKE_PADS:
		return caution
	elif int(id[sensor[2]]) >= CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		return warning
	elif int(id[sensor[2]]) >= CautionLimits.MAX_WHEEL_BEARING_TEMP:
		return caution
	else:
		return good
	
func truck_wheel_df_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	if int(id[sensor[0]]) >= CriticalLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CriticalLimits.MIN_TYRE_PRESSURE:
		return warning
	elif int(id[sensor[0]]) >= CautionLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CautionLimits.MIN_TYRE_PRESSURE:
		return caution
	elif int(id[sensor[1]]) >= CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		return warning
	elif int(id[sensor[1]]) >= CautionLimits.MAX_WHEEL_BEARING_TEMP:
		return caution
	else:
		return good

func truck_wheel_ce_limits(id: Dictionary, wheel:String):
	var sensor = sensors[wheel]
	
	if int(id[sensor[0]]) >= CriticalLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CriticalLimits.MIN_TYRE_PRESSURE:
			return warning
	elif int(id[sensor[0]]) >= CautionLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CautionLimits.MIN_TYRE_PRESSURE:
		return caution
	else:
		return good

func trailer_wheel_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	if int(id[sensor[0]]) >= CriticalLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CriticalLimits.MIN_TYRE_PRESSURE:
			return warning
	elif int(id[sensor[0]]) >= CautionLimits.MAX_TYRE_PRESSURE or int(id[sensor[0]]) <= CautionLimits.MIN_TYRE_PRESSURE:
		return caution
	elif int(id[sensor[1]]) <= CriticalLimits.MIN_BRAKE_PADS:
		return warning
	elif int(id[sensor[1]]) <= CautionLimits.MIN_BRAKE_PADS:
		return caution
	else:
		return good

# Compares values in the database to the critical limits/cautions
func freezer_limits(id: Dictionary):
	# These return the values from the database, calling from the dictionary.
	# The id passed through will be the variable current_id
	# Gets the value of the weight sensor G and stores it in a variable
	var freezer_weight = int(id[sensors["Cube"][3]])
	
	# This loop will allow us to run through the different temp sensors (0-2)
	# without too much code. If there's nothign wrong with the sensors, it will move on
	# to checking the weight.
	for i in range(2):
		# Compares the freezer temperatures to the critical limit but only if the 
		# freezer is loaded (the weight is greater than 1) 
		# i will equal a value inclusive of 0-2, which will when applied below
		# will results in the freezer temps being returned
		if int(id[sensors["Cube"][i]]) >= CriticalLimits.MIN_FREEZER_TEMP and freezer_weight > 0:
			# Will return the warning color (red)
			return warning
			break
		else:
			pass
	# Compares the freezer weight to the critical limit
	if freezer_weight >= CriticalLimits.MAX_WEIGHT:
		# Will return warning color (red) and break the loop
		return warning
	elif freezer_weight >= CautionLimits.MAX_WEIGHT:
		return caution
	else:
		return good

func set_material(node, color):
	node.get_surface_material(0).next_pass.set_shader_param("albedo", color)

func set_status(id):
	set_material(freezer, freezer_limits(id))
	set_material(fridge, fridge_limits(id))
	set_material(truck_wheel_a, truck_wheel_ab_limits(id, "Truck Wheel A"))
	set_material(truck_wheel_b, truck_wheel_ab_limits(id, "Truck Wheel B"))
	set_material(truck_wheel_c, truck_wheel_ce_limits(id, "Truck Wheel C"))
	set_material(truck_wheel_e, truck_wheel_ce_limits(id, "Truck Wheel E"))
	set_material(truck_wheel_d, truck_wheel_df_limits(id, "Truck Wheel D"))
	set_material(truck_wheel_f, truck_wheel_df_limits(id, "Truck Wheel F"))
	set_material(trailer_wheel_a, trailer_wheel_limits(id, "Trailer Wheel A"))
	set_material(trailer_wheel_b, trailer_wheel_limits(id, "Trailer Wheel B"))
	set_material(trailer_wheel_c, trailer_wheel_limits(id, "Trailer Wheel C"))
	set_material(trailer_wheel_d, trailer_wheel_limits(id, "Trailer Wheel D"))
	set_material(trailer_wheel_e, trailer_wheel_limits(id, "Trailer Wheel E"))
	set_material(trailer_wheel_f, trailer_wheel_limits(id, "Trailer Wheel F"))
	
func _process(delta):
	current_id = DatabaseFetch.read_db_time(current_date, current_time)
	set_status(current_id)

