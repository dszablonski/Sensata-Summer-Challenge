extends PanelContainer

# If a chart has been clicked on then it is considered "selected".
var _selected_chart: Chart
# When a chart is selected the x-axis scale becomes more "zoomed in" so you can
# see more of the x-axis values (0 all the way to 23).
# However, when it is unselected after being selected, we want to undo this change.
# To do so, we must save the original value.
var _selected_chart_old_x_decim: float

onready var charts_grid: GridContainer = $ChartsGrid
# When a chart is selected only one chart becomes displayed at a time.
# When that chart is then unselected, we want to undo that change by reverting
# the number of columns back to this value.
onready var charts_grid_columns_default = charts_grid.columns

onready var weight_chart: LineChart = $ChartsGrid/WeightChart
onready var weight_chart_keys: VBoxContainer = weight_chart.get_node("Key")
onready var CHART_TO_SENSORS := {
	$ChartsGrid/TyrePressureChart: "TyrePressure",
	$ChartsGrid/TruckWheelBearingTempChart: "TruckWheelBearingTemp",
	$ChartsGrid/TruckBrakePadsChart: "TruckBrakePads",
}


func _ready() -> void:
	# When the date/time is changed the charts should be updated
	GlobalDate.connect("date_time_changed", self, "_update_charts")
	# Iterate over every chart.
	for chart in charts_grid.get_children():
		# Connects the chart's clicked signal so that when it is clicked it
		# becomes selected.
		chart.connect("clicked", self, "_on_LineChart_clicked", [chart])
	_update_charts()


func _update_charts() -> void:
	# Iterate over every chart.
	for chart in charts_grid.get_children():
		_plot_chart(chart)
	# Update the selected chart's hour marker (if there is one).
	if _selected_chart:
		_selected_chart.update()


func _plot_chart(chart: Chart) -> void:
	if chart == weight_chart:
		_plot_weight_chart()
	else:
		var sensor_name: String = CHART_TO_SENSORS[chart]
		_plot_data(chart, sensor_name)


func _plot_weight_chart() -> void:
	var weight_formatted_data = _get_formatted_chart_data("TrailerWeight")
	var freezer_formatted_y_datas = _get_formatted_chart_data(
		"TrailerTemperature",
		PoolStringArray(["A", "B", "C"]),
		true
	)
	var fridge_formatted_y_datas = _get_formatted_chart_data(
		"TrailerTemperature",
		PoolStringArray(["D", "E", "F"]),
		true
	)
	weight_chart.plot_from_array_multiple(
		weight_formatted_data,
		freezer_formatted_y_datas,
		fridge_formatted_y_datas
	)


func _get_formatted_chart_data(
	sensor_name: String,
	identifiers := PoolStringArray(),
	just_average := false
) -> Array:
	# sensor_name represents the kind of sensors we want to take the values from.
	# For example, if sensor_name was "TrailerWeight" it would get the average
	# of every trailer weight sensor.

	# The identifier represents the letter at the end of the sensor.
	# identifiers is a PoolStringArray containing identifiers.
	# This allows the data to be even more specific.
	# For example ["B", "C", "D"] would only average the sensor values for the
	# sensor {sensor_name} that also either end in B, C, or D.

	# just_average allows you to determine if it returns a one dimensional array
	# containing just the average (y-axis) values or a two dimensional array
	# containing both the average (y-axis) and the time (x-axis).

	var formatted_data := []
	if not just_average:
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
		var num := 0
		# The hourly data is a dictionary containing the sensor name as the key
		# and the sensor's value as the dictionary's value.
		# This iterates over every sensor name.
		for sensor in hourly_data:
			# Ignore every sensor that isn't the sensor we want.
			if not sensor_name in sensor:
				continue
			# Ignore identifiers that we don't want.
			var identifier: String = sensor[-1]
			if not identifiers.empty() and not identifier in identifiers:
				continue
			var value: int = hourly_data[sensor]
			total += value
			num += 1
		# Calculate the average.
		var average := int(total / num)
		if just_average:
			formatted_data.append(average)
		else:
			formatted_data[0].append(i)
			formatted_data[1].append(average)
	return formatted_data


func _plot_data(chart: Chart, sensor_name: String) -> void:
	# chart represents the chart we want to plot the data to.
	# sensor_name represents the kind of sensors we want to take the values from.
	# For example, if sensor_name was "TrailerWeight" it would plot the average
	# of every trailer weight sensor.
	
	var formatted_data = _get_formatted_chart_data(sensor_name)
	# Plot the data on the chart.
	chart.plot_from_array(formatted_data)


func _on_LineChart_clicked(chart: LineChart) -> void:
	# When a chart is clicked it should become bigger.
	# However, if a chart that is already selected is clicked then it should be
	# unselected.
	if chart == _selected_chart:  # If the chart is aleady selected.
		charts_grid.columns = charts_grid_columns_default
		_selected_chart.x_decim = _selected_chart_old_x_decim
		_selected_chart.show_points = false
		_selected_chart = null
		# Make every chart visible and plot them.
		for chart in charts_grid.get_children():
			chart.visible = true
			chart.plot()
		if _selected_chart == weight_chart:
			weight_chart.ChartName.visible = true
			weight_chart_keys.visible = false
	else:  # If the chart is not selected.
		_selected_chart = chart
		charts_grid.columns = 1
		# Make all the charts invisible (except the selected chart).
		for chart in charts_grid.get_children():
			chart.visible = chart == _selected_chart
		_selected_chart_old_x_decim = _selected_chart.x_decim
		_selected_chart.x_decim = 1
		_selected_chart.show_points = true
		# Plot the selected chart.
		_selected_chart.plot()
		if _selected_chart == weight_chart:
			weight_chart.ChartName.visible = false
			weight_chart_keys.visible = true
