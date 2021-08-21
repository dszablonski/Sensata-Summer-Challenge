extends PopupPanel

#onready var Chartspopup: Popup 
# Declare member variables here. Examples:
var chart = chart as LineChart
var specific_chart= chart
var day=3
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	#popup_centered()
	#call_deferred("popup_centered")
	#$HSplitContainer/LineChart.origin_at_zero=true
	#$HSplitContainer/LineChart2.origin_at_zero=true
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func plot_graph(day: int, attribute: String):
	var formatted_data := [
		[0],  # I don't have a clue what this 0 is for but changing it seems to do nothing
		[""],
	]
	for i in 24:
		var hourly_data := DatabaseFetch.read_db_time_new(2021,6,day, i)
		var total_brake_wear := 0.0
		var num_brake_sensors := 0
		for sensor in hourly_data:
			if not attribute in sensor:
				continue
			var value: int = hourly_data[sensor]
			total_brake_wear += value
			num_brake_sensors += 1
		var average_brake_wear := int(total_brake_wear)
		formatted_data[0].append(i)
		formatted_data[1].append(average_brake_wear)
	$HSplitContainer/LineChart.plot_from_array(formatted_data)
	call_deferred("popup_centered")
	
func plot_graph2(day: int, attribute: String):
	var formatted_data := [
		[0],  # I don't have a clue what this 0 is for but changing it seems to do nothing
		[""],
	]
	for i in 24:
		var hourly_data := DatabaseFetch.read_db_time_new(2021,6,day, i)
		var total_brake_wear := 0.0
		var num_brake_sensors := 0
		for sensor in hourly_data:
			if not attribute in sensor:
				continue
			var value: int = hourly_data[sensor]
			total_brake_wear += value
			num_brake_sensors += 1
		var average_brake_wear := int(total_brake_wear)
		formatted_data[0].append(i)
		formatted_data[1].append(average_brake_wear)
	$HSplitContainer/LineChart2.plot_from_array(formatted_data)
	call_deferred("popup_centered")

func _on_StaticBody_brake_wear_sensor_ab():  # May not work
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckBrakePadsA")
	plot_graph2(day, "TruckBrakePadsB")
	#print("Functional")

func _on_StaticBody_brake_wear_sensor_da():  # May not work
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	print("Functional")
	plot_graph(day,"TrailerWeightA")
	plot_graph2(day,"TrailerWeightD")
	
func _on_StaticBody_brake_wear_sensor_eb():  # May not work
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	print("Functional")
	plot_graph(day,"TrailerWeightE")
	plot_graph2(day, "TrailerWeightB")

func _on_StaticBody_brake_wear_sensor_fc():  # May not work
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	print("Functional")
	plot_graph(day,"TrailerWeightF")
	plot_graph2(day, "TrailerWeightC")


func _on_StaticBody_truck_wheel_a():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	print("Functional")
	plot_graph(day,"TruckTyrePressureA")
	plot_graph2(day,"TruckWheelBearingTempA")

func _on_StaticBody_truck_wheel_b():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckTyrePressureB")
	plot_graph2(day, "TruckWheelBearingTempB")


func _on_StaticBody_truck_wheel_c():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckTyrePressureC")
	plot_graph2(day, "TrailerWeightG")


func _on_StaticBody_truck_wheel_d():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckTyrePressureD")
	plot_graph2(day, "TruckWheelBearingTempD")


func _on_StaticBody_truck_wheel_e():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckTyrePressureE")
	plot_graph2(day, "TrailerWeightG")


func _on_StaticBody_truck_wheel_f():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TruckTyrePressureF")
	plot_graph2(day, "TruckWheelBearingTempF")


func _on_StaticBody_trailer_wheel_a():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureA")
	plot_graph2(day, "TrailerBrakePadsA")


func _on_StaticBody_trailer_wheel_b():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureB")
	plot_graph2(day, "TrailerBrakePadsB")


func _on_StaticBody_trailer_wheel_c():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureC")
	plot_graph2(day, "TrailerBrakePadsC")


func _on_StaticBody_trailer_wheel_d():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureD")
	plot_graph2(day, "TrailerBrakePadsD")

func _on_StaticBody_trailer_wheel_e():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureE")
	plot_graph2(day, "TrailerBrakePadsE")


func _on_StaticBody_trailer_wheel_f():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTyrePressureF")
	plot_graph2(day, "TrailerBrakePadsF")


func _on_StaticBody_freezer():
	$HSplitContainer/LineChart.origin_at_zero=false
	$HSplitContainer/LineChart2.origin_at_zero=false
	plot_graph(day,"TrailerTemperatureA")
	plot_graph2(day, "TrailerTemperatureB")


func _on_StaticBody_fridge():
	$HSplitContainer/LineChart.origin_at_zero=true
	$HSplitContainer/LineChart2.origin_at_zero=true
	plot_graph(day,"TrailerTemperatureD")
	plot_graph2(day, "TrailerTemperatureE")

