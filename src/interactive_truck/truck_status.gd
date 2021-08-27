extends Spatial

# When everything is okay, green
const good = Color(0.38823, 0.78039, 0.30196)
# When something is near a limit, yellow
const caution = Color(0.99607, 0.90588, 0.38039)
# When something is at a critical point, red
const warning = Color(0.89411, 0.23137, 0.26666)

var current_id
var fridge_is_loaded
var freezer_is_loaded

# A dictionary of the meshes and the sensors which they are tied to. 
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

# When the program is first run, the signal for the global date and time changing
# will be connected 
func _ready() -> void:
	GlobalDate.connect("date_time_changed", self, "_on_date_time_changed")
	# The date and time is fetched here through this function
	_on_date_time_changed()

# This is run whent he date and time is changed
func _on_date_time_changed() -> void:
	# The current date and time is fetched from the database singleton
	current_id = DatabaseFetch.read_db_current_date_time()
	# Gets the stats for the fridgge and checks if any of the weight sensors are 
	# above 0 (meaning they are loaded), returning either true or false
	fridge_is_loaded = (
		current_id[sensors["Cube001"][3]] > 0 
		or current_id[sensors["Cube001"][4]] > 0 
		or current_id[sensors["Cube001"][5]] > 0 
		or current_id[sensors["Cube001"][6]] > 0
					)
	# Gets the weight stats of the freezer and if any of the sensors read above
	# 0 (meaningg they are loaded), they return true, otherwise they return false
	freezer_is_loaded = (
		current_id[sensors["Cube"][3]] > 0
	)
	# The set_status function is run (see below) with the current ID being passed
	# through
	set_status(current_id)

# Function which sets the status of the fridge
func fridge_limits(id: Dictionary):
	# The sensor used will be "Cube001" (the fridge mesh)
	var sensor = sensors["Cube001"]
	
	# Stores the weight sensor vallues in an array
	var weight_array = [id[sensor[3]], id[sensor[4]], id[sensor[5]], id[sensor[6]]]
	# Gets the weight differential by taking the max weight value away from the
	# minimum weight value. We weren't really sure how to calculate the weight
	# differential, so we decided on doing it this way.
	var weight_differential = weight_array.max() - weight_array.min()

	# This will loop twice (0 - 2), giving us the ID of the temperature sensors
	for i in range(2):
		# If the sensor is above the critical limit for the fridge temp, and
		# the fridge_is_loaded variable is true,
		if int(id[sensor[i]]) > CriticalLimits.MAX_FRIDGE_TEMP and fridge_is_loaded:
			# Return the variable warning (red)
			return warning
		# Otherwie, move on with the loop
		else:
			pass
	# This will loop through a range of numbers (3-6) giving us the ID of the 
	# weight sensors
	for j in range(3, 7):
		# If the weight sensor is above the critical limit for the weight,
		if int(id[sensor[j]]) > CriticalLimits.MAX_WEIGHT:
			# Return the constant warning (red)
			return warning
		# Else, if the weight sensor is above the caution limit for the weight, 
		elif int(id[sensor[j]]) > CautionLimits.MAX_WEIGHT:
			# Return the constant caution (yellow)
			return caution
		# Else, if the weight differential is above the caution limit for the
		# weight differential,
		elif weight_differential > CriticalLimits.MAX_WEIGHT_DIFFERENTIAL:
			# Return the constant warning (red)
			return warning
		# Else, if the weight differential is above the caution limit for the
		# weight differential, 
		elif weight_differential > CautionLimits.MAX_WEIGHT_DIFFERENTIAL:
			# Return the constant caution (yelow)
			return caution
		# Otherwise,
		else:
			# Return the constant good (green)
			return good

# This function checks teh status of the truck wheels a and b, since they share
# common sernsors
func truck_wheel_ab_limits(id: Dictionary, wheel: String):
	# Stores the array of the value of the wheel passed through
	var sensor = sensors[wheel]

	# If the tyre pressure sensor exceeds or underceeds the critical limits for
	# tyre pressure,
	if (
		int(id[sensor[0]]) > CriticalLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CriticalLimits.MIN_TYRE_PRESSURE
	):
		# Return the constant "warning" (red)
		return warning
	# Else, if the tyre pressure sensor exceeds or underceeds the caution limits
	# for the tyre pressure,
	elif (
		int(id[sensor[0]]) > CautionLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CautionLimits.MIN_TYRE_PRESSURE
	):
		# Return the constatn "caution" (yellow)
		return caution
	# Else, if the brake pad sensor underceeds the critical limit for brake pads,
	elif int(id[sensor[1]]) < CriticalLimits.MIN_BRAKE_PADS:
		# Return the  constant "warning" (red)
		return warning
	# Else, if the brake pad sensor underceeds teh caution limit for brake pads,
	elif int(id[sensor[1]]) < CautionLimits.MIN_BRAKE_PADS:
		# Return the constatn "caution" (yellow)
		return caution
	# Else, if the wheel bearing sensor exceeds the critical limit for wheel
	# bearing temperature
	elif int(id[sensor[2]]) > CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		# Return the  constant "warning" (red)
		return warning
	# Else if the wehel bearing sensor exceeds teh caution  limit for wheel 
	# bearing temperature,
	elif int(id[sensor[2]]) > CautionLimits.MAX_WHEEL_BEARING_TEMP:
		# Return the constatn "caution" (yellow)
		return caution
	# Otherwise,
	else:
		# Return the constant good (green)
		return good


func truck_wheel_df_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	# If the tyre pressure sensor exceeds or underceeds the critical limits for
	# tyre pressure,
	if (
		int(id[sensor[0]]) > CriticalLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CriticalLimits.MIN_TYRE_PRESSURE
	):
		# Return the  constant "warning" (red)
		return warning
	# Else, if the tyre pressure sensor exceeds or underceeds the caution limits
	# for the tyre pressure,
	elif (
		int(id[sensor[0]]) > CautionLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CautionLimits.MIN_TYRE_PRESSURE
	):
		# Return the constatn "caution" (yellow)
		return caution
	# Else, if the wheel bearing sensor exceeds the critical limit for wheel
	# bearing temperature
	elif int(id[sensor[1]]) > CriticalLimits.MAX_WHEEL_BEARING_TEMP:
		# Return the  constant "warning" (red)
		return warning
	# Else if the wehel bearing sensor exceeds teh caution  limit for wheel 
	# bearing temperature,
	elif int(id[sensor[1]]) > CautionLimits.MAX_WHEEL_BEARING_TEMP:
		# Return the constatn "caution" (yellow)
		return caution
	# Otherwise, 
	else:
		# Return the constant good (green)
		return good


func truck_wheel_ce_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	# If the tyre pressure sensor exceeds or underceeds the critical limits for
	# tyre pressure,
	if (
		int(id[sensor[0]]) > CriticalLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CriticalLimits.MIN_TYRE_PRESSURE
	):
		# Return the  constant "warning" (red)
		return warning
	# Else, if the tyre pressure sensor exceeds or underceeds the caution limits
	# for the tyre pressure,
	elif (
		int(id[sensor[0]]) > CautionLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CautionLimits.MIN_TYRE_PRESSURE
	):
		# Return the constatn "caution" (yellow)
		return caution
	# Otherwise
	else:
		# Return the constant good (green)
		return good


func trailer_wheel_limits(id: Dictionary, wheel: String):
	var sensor = sensors[wheel]
	
	# If the tyre pressure sensor exceeds or underceeds the critical limits for
	# tyre pressure,
	if (
		int(id[sensor[0]]) > CriticalLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CriticalLimits.MIN_TYRE_PRESSURE
	):
		# Return the  constant "warning" (red)
		return warning
	# Else, if the tyre pressure sensor exceeds or underceeds the caution limits
	# for the tyre pressure,
	elif (
		int(id[sensor[0]]) > CautionLimits.MAX_TYRE_PRESSURE
		or int(id[sensor[0]]) < CautionLimits.MIN_TYRE_PRESSURE
	):
		# Return the constatn "caution" (yellow)
		return caution
	# Else, if the brake pad sensor underceeds the critical limit for brake pads,
	elif int(id[sensor[1]]) < CriticalLimits.MIN_BRAKE_PADS:
		# Return the  constant "warning" (red)
		return warning
	# Else, if the brake pad sensor underceeds teh caution limit for brake pads,
	elif int(id[sensor[1]]) < CautionLimits.MIN_BRAKE_PADS:
		# Return the constatn "caution" (yellow)
		return caution
	# Otherwise
	else:
		# Return the constant good (green)
		return good


# Compares values in the database to the critical limits/cautions
func freezer_limits(id: Dictionary):
	# This loop will allow us to run through the different temp sensors (0-2)
	# without too much code. If there's nothign wrong with the sensors, it will move on
	# to checking the weight.
	for i in range(2):
		# Compares the freezer temperatures to the critical limit but only if the 
		# freezer is loaded (the weight is greater than 1) 
		# i will equal a value inclusive of 0-2, which will when applied below
		# will results in the freezer temps being returned
		if ( 
			int(id[sensors["Cube"][i]]) > CriticalLimits.MAX_FREEZER_TEMP 
			and freezer_is_loaded
			):
			# Will return the warning color (red)
			return warning
	# Compares the freezer weight to the critical limit
	if id[sensors["Cube"][3]] > CriticalLimits.MAX_WEIGHT:
		# Will return warning color (red) and break the loop
		return warning
	# Else, if the freezer weigh tis greater than the caution limit for max weight
	elif id[sensors["Cube"][3]] > CautionLimits.MAX_WEIGHT:
		# Return the constatn "caution" (yellow)
		return caution
	# Otherwise
	else:
		# Return the constant good (green)
		return good

# This function sets the color (which is passed through) of the material
# of the node passed through
func set_material(node, color):
	# The node's next pass surface material has the it's albedo (colour) parameter
	# changed to whatever colour is passed through
	node.get_surface_material(0).next_pass.set_shader_param("albedo", color)
	
# This sets the status for all the meshes on the truck, passing through the variable
# holdingg their nodes in througgh the "set_material" function, then setting the 
# colour to whatever is returned by their respective satus returning function.
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
