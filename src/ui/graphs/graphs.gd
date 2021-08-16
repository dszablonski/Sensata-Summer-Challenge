extends PanelContainer

const PLACEHOLDER_DAY := 5

onready var line_chart: LineChart = $LineChart


func _ready() -> void:
	var formatted_data := [
		[0],  # I don't have a clue what this 0 is for but changing it seems to do nothing
		[""],
	]
	for i in 24:
		var hourly_data := DatabaseFetch.read_db_time(PLACEHOLDER_DAY, i)
		var total_weight_acting_on_sensors := 0.0
		var num_weight_sensors := 0
		for sensor in hourly_data:
			if not "TrailerWeight" in sensor:
				continue
			var value: int = hourly_data[sensor]
			total_weight_acting_on_sensors += value
			num_weight_sensors += 1
		var average_weight := int(total_weight_acting_on_sensors / num_weight_sensors)
		formatted_data[0].append(i)
		formatted_data[1].append(average_weight)
	line_chart.origin_at_zero = true
	line_chart.plot_from_array(formatted_data)
