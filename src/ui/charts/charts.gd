extends PanelContainer

const BLUE := Color("0099DB")
const RED := Color("E43B44")
const GREEN := Color("63C74D")
const GREY_3 := Color("3A4466")
const GREY_4 := Color("5A6988")
const GREY_5 := Color("8B9BB4")
const GREY_6 := Color("C0CBDC")

# If a chart has been clicked on then it is considered "selected".
var _selected_chart: Chart
# When a chart is selected the x-axis scale becomes more "zoomed in" so you can
# see more of the x-axis values (0 all the way to 23).
# However, when it is unselected after being selected, we want to undo this change.
# To do so, we must save the original value.
var _selected_chart_old_x_decim: float

onready var charts_grid: GridContainer = $MarginContainer/ChartsGrid
# When a chart is selected only one chart becomes displayed at a time.
# When that chart is then unselected, we want to undo that change by reverting
# the number of columns back to this value.
onready var charts_grid_columns_default = charts_grid.columns

onready var avg_weight_chart: LineChart = $MarginContainer/ChartsGrid/WeightChart
onready var avg_tyre_pressure_chart: LineChart = $MarginContainer/ChartsGrid/TyrePressureChart
onready var avg_wheel_bearing_chart: LineChart = $MarginContainer/ChartsGrid/TruckWheelBearingTempChart
onready var avg_brake_pads_chart: LineChart = $MarginContainer/ChartsGrid/TruckBrakePadsChart
onready var weight_tab_container: TabContainer = $MarginContainer/WeightTabContainer
onready var tyre_pressure_tab_container: TabContainer = $MarginContainer/TyrePressureTabContainer
onready var wheel_bearing_tab_container: TabContainer = $MarginContainer/WheelBearingTabContainer
onready var brake_pads_tab_container: TabContainer = $MarginContainer/BrakePadsTabContainer
onready var trailer_weight_chart: LineChart = $"MarginContainer/WeightTabContainer/Trailer Weight"
onready var truck_tyre_pressure_chart: LineChart = $"MarginContainer/TyrePressureTabContainer/Truck Tyre Pressure"
onready var trailer_tyre_pressure_chart: LineChart = $"MarginContainer/TyrePressureTabContainer/Trailer Tyre Pressure"
onready var wheel_bearing_chart: LineChart = $"MarginContainer/WheelBearingTabContainer/Truck Wheel Bearing Temp"
onready var truck_brake_wear: LineChart = $"MarginContainer/BrakePadsTabContainer/Truck Brake Wear %"
onready var trailer_brake_wear: LineChart = $"MarginContainer/BrakePadsTabContainer/Trailer Brake Wear %"
onready var CHART_TO_LINE_SENSORS := {
	avg_weight_chart: [
		["TrailerWeightA", "TrailerWeightC", "TrailerWeightD", "TrailerWeightF", "TrailerWeightG"],
		["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC"],
		["TrailerTemperatureD", "TrailerTemperatureE", "TrailerTemperatureF"],
	],
	avg_tyre_pressure_chart: [
		[
			"TruckTyrePressureA", "TruckTyrePressureB", "TruckTyrePressureC",
			"TruckTyrePressureD", "TruckTyrePressureE", "TruckTyrePressureF"
		],
		[
			"TrailerTyrePressureA", "TrailerTyrePressureB", "TrailerTyrePressureC",
			"TrailerTyrePressureD", "TrailerTyrePressureE", "TrailerTyrePressureF"
		],
	],
	avg_wheel_bearing_chart: [
		[
			"TruckWheelBearingTempA", "TruckWheelBearingTempB",
			"TruckWheelBearingTempC", "TruckWheelBearingTempD"
		],
	],
	avg_brake_pads_chart: [
		["TruckBrakePadsA", "TruckBrakePadsB"],
		[
			"TrailerBrakePadsA", "TrailerBrakePadsB", "TrailerBrakePadsC",
			"TrailerBrakePadsD", "TrailerBrakePadsE", "TrailerBrakePadsF",
		],
	],
	trailer_weight_chart: [
		["TrailerWeightA"],
		["TrailerWeightC"],
		["TrailerWeightD"],
		["TrailerWeightF"],
		["TrailerWeightG"],
		["TrailerTemperatureA", "TrailerTemperatureB", "TrailerTemperatureC"],
		["TrailerTemperatureD", "TrailerTemperatureE", "TrailerTemperatureF"],
	],
	truck_tyre_pressure_chart: [
		["TruckTyrePressureA"],
		["TruckTyrePressureB"],
		["TruckTyrePressureC"],
		["TruckTyrePressureD"],
		["TruckTyrePressureE"],
		["TruckTyrePressureF"],
	],
	trailer_tyre_pressure_chart: [
		["TrailerTyrePressureA"],
		["TrailerTyrePressureB"],
		["TrailerTyrePressureC"],
		["TrailerTyrePressureD"],
		["TrailerTyrePressureE"],
		["TrailerTyrePressureF"],
	],
	wheel_bearing_chart: [
		["TruckWheelBearingTempA"],
		["TruckWheelBearingTempB"],
		["TruckWheelBearingTempC"],
		["TruckWheelBearingTempD"],
	],
	truck_brake_wear: [
		["TruckBrakePadsA"],
		["TruckBrakePadsB"],
	],
	trailer_brake_wear: [
		[
			"TrailerBrakePadsA", "TrailerBrakePadsB", "TrailerBrakePadsC",
			"TrailerBrakePadsD", "TrailerBrakePadsE", "TrailerBrakePadsF",
		],
	],
}
onready var CHART_TO_ADDITIONAL_FUNCTION_COLORS := {
	avg_weight_chart: PoolColorArray([
		BLUE,
		RED,
	]),
	avg_tyre_pressure_chart: PoolColorArray([
		GREEN,
	]),
	avg_wheel_bearing_chart: PoolColorArray(),
	avg_brake_pads_chart: PoolColorArray([
		GREEN,
	]),
	trailer_weight_chart: PoolColorArray([
		GREY_3,
		GREY_4,
		GREY_5,
		GREY_6,
		BLUE,
		RED,
	]),
	truck_tyre_pressure_chart: PoolColorArray([
		GREY_3,
		GREY_4,
		GREY_5,
		GREY_6,
		Color.white,
	]),
	trailer_tyre_pressure_chart: PoolColorArray([
		GREY_3,
		GREY_4,
		GREY_5,
		GREY_6,
		Color.white,
	]),
	wheel_bearing_chart: PoolColorArray([
		GREY_3,
		GREY_4,
		GREY_5,
	]),
	truck_brake_wear: PoolColorArray([
		GREY_3,
	]),
	trailer_brake_wear: PoolColorArray(),
}
onready var CHART_TO_ADDITIONAL_UNITS := {
	avg_weight_chart: ["°C", "°C"],
	avg_tyre_pressure_chart: [" psi"],
	avg_wheel_bearing_chart: [],
	avg_brake_pads_chart: ["%"],
	trailer_weight_chart: [" kg", " kg", " kg", " kg", "°C", "°C"],
	truck_tyre_pressure_chart: [" psi", " psi", " psi", " psi", " psi"],
	trailer_tyre_pressure_chart: [" psi", " psi", " psi", " psi", " psi"],
	wheel_bearing_chart: ["°C", "°C", "°C"],
	truck_brake_wear: ["%"],
	trailer_brake_wear: [],
}
onready var CHART_TO_TAB_CONTAINER := {
	avg_weight_chart: $MarginContainer/WeightTabContainer,
	avg_tyre_pressure_chart: $MarginContainer/TyrePressureTabContainer,
	avg_wheel_bearing_chart: $MarginContainer/WheelBearingTabContainer,
	avg_brake_pads_chart: $MarginContainer/BrakePadsTabContainer,
}
onready var back_button: Button = $MarginContainer/BackButton


func _ready() -> void:
	back_button.visible = false
	# When the date/time is changed the charts should be updated
	GlobalDate.connect("date_time_changed", self, "_update_charts")
	# Iterate over every basic chart.
	for chart in charts_grid.get_children():
		# Connects the chart's clicked signal so that when it is clicked it
		# becomes selected.
		chart.connect("clicked", self, "_on_LineChart_clicked", [chart])
	_update_charts()


func _update_charts() -> void:
	# Iterate over every chart if its parent is visible.
	if charts_grid.visible:
		for chart in charts_grid.get_children():
			_plot_chart(chart)
	if weight_tab_container.visible:
		for chart in weight_tab_container.get_children():
			_plot_chart(chart)
	if tyre_pressure_tab_container.visible:
		for chart in tyre_pressure_tab_container.get_children():
			_plot_chart(chart)
	if wheel_bearing_tab_container.visible:
		for chart in wheel_bearing_tab_container.get_children():
			_plot_chart(chart)
	if brake_pads_tab_container.visible:
		for chart in brake_pads_tab_container.get_children():
			_plot_chart(chart)


func _plot_chart(chart: LineChart) -> void:
	var line_sensors: Array = CHART_TO_LINE_SENSORS[chart]
	var additional_function_colors: PoolColorArray = CHART_TO_ADDITIONAL_FUNCTION_COLORS[chart]
	var additional_units: Array = CHART_TO_ADDITIONAL_UNITS[chart]
	var sensor_names_line_one: Array = line_sensors[0]
	var main_formatted_data := _get_formatted_chart_data(sensor_names_line_one)
	var additional_y_datas := []
	for i in range(1, line_sensors.size()):
		var sensor_names: Array = line_sensors[i]
		var y_data := _get_formatted_chart_data(sensor_names, true)
		additional_y_datas.append(y_data)
	if chart == avg_weight_chart:
		chart.plot_from_array_multiple(
			main_formatted_data,
			additional_y_datas,
			additional_function_colors,
			additional_units,
			[[-4, 20], [-4, 20]],
			[4, 4],
			["-4", "0", "4", "8", "12", "16", "20"]
		)
	elif chart == trailer_weight_chart:
		chart.plot_from_array_multiple(
			main_formatted_data,
			additional_y_datas,
			additional_function_colors,
			additional_units,
			[[], [], [], [], [-4, 20], [-4, 20]],
			[0, 0, 0, 0, 4, 4],
			["-4", "0", "4", "8", "12", "16", "20"]
		)
	else:
		chart.plot_from_array_multiple(
			main_formatted_data,
			additional_y_datas,
			additional_function_colors,
			additional_units
		)


func _get_formatted_chart_data(
	sensor_names: Array,
	just_y_axis := false
) -> Array:
	# sensor_names represents the sensors we want to take the values from.
	# If there are multiple elements in sensor_names then an average will be taken.

	# just_y_axis allows you to determine if it returns a one dimensional array
	# with just the y-axis values or a two dimensional array with both the y-axis
	# and the x-axis (where the x-axis has the hours 0-23).

	var formatted_data := []
	if not just_y_axis:
		# The data array contains two nested arrays.
		# The first row (index 0 array) contains the x-axis values.
		# The second row (index 1 array) contains the y-axis values.
		# I'm not sure what the first element of each nested array does but changing
		# their value does not need to affect the charts.
		formatted_data = [
			[0],
			[0],
		]
	# Iterating through every hour (0 to 23).
	for i in 24:
		# Grabbing the data for that hour.
		var hourly_data := DatabaseFetch.read_db_time_current_date(i)
		# To calculate the average for that hour we need the total and the
		# number of sensors (because average = total / num).
		var total := 0.0
		var num := len(sensor_names)
		# The hourly data is a dictionary containing the sensor name as the key
		# and the sensor's value as the dictionary's value.
		# This iterates over every sensor name.
		for sensor in hourly_data:
			# Ignore every sensor that isn't one of the sensors we want.
			if not sensor in sensor_names:
				continue
			var value: int = hourly_data[sensor]
			total += value
		# Calculate the average.
		var average := int(total / num)
		if just_y_axis:
			formatted_data.append(average)
		else:
			formatted_data[0].append(i)
			formatted_data[1].append(average)
	return formatted_data


func _on_LineChart_clicked(chart: LineChart) -> void:
	_select_chart(chart)
	_update_charts()


func _on_BackButton_pressed() -> void:
	_unselect_chart()
	_update_charts()


func _select_chart(chart: Chart) -> void:
	_selected_chart = chart
	charts_grid.visible = false
	var tab_container: TabContainer = CHART_TO_TAB_CONTAINER[_selected_chart]
	tab_container.visible = true
	back_button.visible = true


func _unselect_chart() -> void:
	var tab_container: TabContainer = CHART_TO_TAB_CONTAINER[_selected_chart]
	tab_container.visible = false
	charts_grid.visible = true
	_selected_chart = null
	back_button.visible = false
