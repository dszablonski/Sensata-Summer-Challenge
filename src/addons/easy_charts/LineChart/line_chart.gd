#tool
extends ScatterChartBase
class_name LineChart

# [Linechart] - General purpose node for Line Charts
# A line chart or line plot or line graph or curve chart is a type of chart which
# displays information as a series of data points called 'markers'
# connected by straight line segments.
# It is a basic type of chart common in many fields. It is similar to a scatter plot
# except that the measurement points are ordered (typically by their x-axis value)
# and joined with straight line segments.
# A line chart is often used to visualize a trend in data over intervals of time -
# a time series - thus the line is often drawn chronologically.
# In these cases they are known as run charts.
# Source: Wikipedia

signal clicked  # Hack

export var units := ""  # Hack

var additional_y_datas: Array  # Hack
var additional_point_values: Array
var additional_point_positions: Array
var additional_function_colors: Array
var additional_units: Array
var additional_y_ranges: Array
var additional_y_decims: Array

var show_points := true
var function_line_width : int = 2


func _ready() -> void:  # Hack
	$PointData/PointData.units = units


func build_property_list():
	.build_property_list()
	
	property_list.append(
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Display/show_points",
		"type": TYPE_BOOL
	})
	
	#Find first element of Chart Display
	var position
	for i in property_list.size():
		if property_list[i]["name"].find("Chart_Style") != -1: #Found
			position = i
			break
		
	property_list.insert(position + 2, #I want it to be below point shape and function colors
	{
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1, 100, 1",
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"name": "Chart_Style/function_line_width",
		"type": TYPE_INT
	})


func _get_property_list():
	property_list[0].name = "LineChart"
	return property_list


func _get(property):
	match property:
		"Chart_Display/show_points":
			return show_points
		"Chart_Style/function_line_width":
			return function_line_width


func _set(property, value):
	match property:
		"Chart_Display/show_points":
			show_points = value
			return true
		"Chart_Style/function_line_width":
			function_line_width = value
			return true


func _draw():
	clear_points()
	draw_grid()
	draw_chart_outlines()
	if show_points:
		draw_points()
	draw_lines()
	draw_treshold()


func draw_lines():
	draw_lines_array(point_values, point_positions, function_colors)
	for i in additional_y_datas.size():  # Hack
		var add_point_values = additional_point_values[i]
		var add_point_positions = additional_point_positions[i]
		var add_function_colors = PoolColorArray([additional_function_colors[i]])
		draw_lines_array(add_point_values, add_point_positions, add_function_colors)


func draw_lines_array(
	point_values_array: Array,
	point_positions_array: Array,
	function_colors_array: Array
) -> void:  # Hack
	for function in point_values_array.size():
		for function_point in range(1, point_values_array[function].size()):
			draw_line(
				point_positions_array[function][function_point - 1],
				point_positions_array[function][function_point],
				function_colors_array[function],
				function_line_width, 
				true
			)


func plot_from_array_multiple(
	array: Array,
	additional_y_datas: Array,
	additional_function_colors: PoolColorArray,
	additional_units: Array,
	additional_y_ranges := [],
	additional_y_decims := [],
	y_chors_right := []
) -> void:  # Hack
	self.additional_y_datas = additional_y_datas
	self.additional_function_colors = additional_function_colors
	self.additional_units = additional_units
	self.additional_y_ranges = additional_y_ranges
	self.additional_y_decims = additional_y_decims
	self.y_chors_right = y_chors_right
	plot_from_array(array)
	redraw_multiple()


func calculate_coords(
	point_values_array: Array,
	point_positions_array: Array,
	y_datas_array: Array
) -> void:  # Hack
	point_values_array.clear()
	point_positions_array.clear()
	
	for _i in y_labels.size():
		point_values_array.append([])
		point_positions_array.append([])
	
	for function in y_labels.size():
		for val in x_datas[function].size():
			var value_x = (x_datas[function][val] - x_margin_min) * x_pass / h_dist if h_dist else 0 \
					if not show_x_values_as_labels else x_chors.find(String(x_datas[function][val])) * x_pass
			var value_y = (y_datas_array[function][val] - y_margin_min) * y_pass / v_dist if v_dist else 0
	
			point_values_array[function].append([x_datas[function][val], y_datas_array[function][val]])
			point_positions_array[function].append(Vector2(value_x + origin.x, origin.y - value_y))


func redraw():  # Hack
	.redraw()
	if additional_y_datas:
		redraw_multiple()


func redraw_multiple() -> void:  # Hack
	additional_point_values = []
	additional_point_positions = []
	for i in additional_y_datas.size():
		var orig_y_range = y_range
		var orig_y_decim = y_decim
		if additional_y_ranges and additional_y_ranges[i]:
			y_range = additional_y_ranges[i]
		if additional_y_decims and additional_y_decims[i] > 0:
			y_decim = additional_y_decims[i]
		if additional_y_ranges or additional_y_decims:
			calculate_tics()
		var add_y_datas = additional_y_datas[i]
		var add_point_values = []
		var add_point_positions = []
		additional_point_values.append(add_point_values)
		additional_point_positions.append(add_point_positions)
		calculate_coords(add_point_values, add_point_positions, [add_y_datas])
		y_range = orig_y_range
		y_decim = orig_y_decim
	if additional_y_ranges or additional_y_decims:
		calculate_tics()


func draw_points() -> void:  # Hack
	.draw_points()
	for i in additional_y_datas.size():  # Hack
		var add_point_values = additional_point_values[i]
		var add_point_positions = additional_point_positions[i]
		var add_function_colors = PoolColorArray([additional_function_colors[i]])
		var add_units = additional_units[i]
		draw_points_array(add_point_values, add_point_positions, add_function_colors, add_units)


func draw_points_array(
	point_values_array: Array,
	point_positions_array: Array,
	function_colors_array: PoolColorArray,
	units: String
) -> void:  # Hack
	for function in point_values_array.size():
		var PointContainer : Control = Control.new()
		Points.add_child(PointContainer)
		
		for function_point in point_values_array[function].size():
			var point : Point = point_node.instance()
			point.connect("_point_pressed",self,"point_pressed")
			point.connect("_mouse_entered",self,"show_data")
			point.connect("_mouse_exited",self,"hide_data")
			
			point.create_point(points_shape[function], function_colors_array[function], 
			Color.white, point_positions_array[function][function_point], 
			point.format_value(point_values_array[function][function_point], false, false), 
			y_labels[function],
			units)
			
			PointContainer.add_child(point)


func _on_Points_gui_input(event: InputEvent) -> void:  # Hack
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("clicked")
