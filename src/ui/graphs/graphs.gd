extends PanelContainer

const PLACEHOLDER_DAY := 5

var _selected_chart: Chart
var _selected_chart_old_x_decim: int

onready var graphs_grid: GridContainer = $GraphsGrid
onready var graphs_grid_columns_default = graphs_grid.columns


func _ready() -> void:
	for chart in graphs_grid.get_children():
		chart = chart as LineChart
		chart.connect("clicked", self, "_on_LineChart_clicked", [chart])
		chart.origin_at_zero = true
	_plot_data()


func _plot_data(specific_chart: Chart = null) -> void:
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
	if specific_chart:
		specific_chart.plot_from_array(formatted_data)
	else:
		for chart in graphs_grid.get_children():
			chart = chart as LineChart
			chart.plot_from_array(formatted_data)


func _on_LineChart_clicked(chart: LineChart) -> void:
	if chart == _selected_chart:
		graphs_grid.columns = graphs_grid_columns_default
		for graph in graphs_grid.get_children():
			graph.visible = true
		_selected_chart.x_decim = _selected_chart_old_x_decim
		_selected_chart.show_points = false
		_plot_data(_selected_chart)
		_selected_chart = null
	else:
		_selected_chart = chart
		graphs_grid.columns = 1
		for graph in graphs_grid.get_children():
			graph.visible = graph == _selected_chart
		_selected_chart_old_x_decim = _selected_chart.x_decim
		_selected_chart.x_decim = 1
		_selected_chart.show_points = true
		_plot_data(_selected_chart)
