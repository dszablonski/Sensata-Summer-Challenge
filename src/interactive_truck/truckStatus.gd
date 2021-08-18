extends Spatial

# When everything is okay, green
const good = Color(0,1,0)
# When something is near a limit, yellow
const caution = Color(1,1,0)
# When something is at a critical point, red
const warning = Color(1,0,0)

var current_date = 1
var current_time = 0
var current_id

var sensors = {
	"Cube": ["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC",
	"TrailerWeightG"],
	"Cube001": ["TrailerTemperatureD", "TrailerTemperatuerE", "TrailerTemperatureF",
	"TrailerWeightA", "TrailerWeightD", "TrailerWeightC", "TrailerWeightF"],
	"Truck Wheel A": ["TruckTyrePressureA", "TruckBreakPadsA", "TruckWheelBearingTempA"],
	"Truck Wheel B": ["TruckTyrePressureB", "TruckBreakPadsB", "TruckWheelBearingTempB"],
	"Truck Wheel C": ["TruckTyrePressureC", "TruckWheelBearingTempC"],
	"Truck Wheel D": ["TruckTyrePressureD", "TruckWheelBearingTempD"],
	"Truck Wheel F": ["TruckTyrePressureF", "TruckWheelBearingTempF"],
	"Trailer Wheel A": ["TrailerTyrePressureA"],
	"Trailer Wheel B": ["TrailerTyrePressureB"],
	"Trailer Wheel C": ["TrailerTyrePressureC"],
	"Trailer Wheel D": ["TrailerTyrePressureD"],
	"Trailer Wheel E": ["TrailerTyrePressureE"],
	"Trailer Wheel F": ["TrailerTyrePressureF"]
	}

onready var freezer = get_node("Cube")
onready var fridge = get_node("Cube001")
onready var truck_wheel_a = get_node("Truck Wheel A")
onready var truck_wheel_b = get_node("Truck Wheel B")
onready var truck_wheel_c = get_node("Truck Wheel C")
onready var truck_wheel_d = get_node("Truck Wheel D")
onready var truck_wheel_e = get_node("Truck Wheel E")
onready var truck_wheel_f = get_node("Truck Wheel F")
onready var trailer_wheel_a = get_node("Trailer Wheel A")
onready var trailer_wheel_b = get_node("Trailer Wheel B")
onready var trailer_wheel_c = get_node("Trailer Wheel C")
onready var trailer_wheel_d = get_node("Trailer Wheel D")
onready var trailer_wheel_e = get_node("Trailer Wheel E")
onready var trailer_wheel_f = get_node("Trailer Wheel F")

func get_limits(sensor):
	return null

func _process(delta):
	current_id = DatabaseFetch.read_db_time(current_date, current_time)

