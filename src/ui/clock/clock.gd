class_name Clock
extends Control

signal time_changed(new_time)

const TIME_BUTTON_SCENE := preload("res://ui/clock/time_button.tscn")

const IS_ANTIALIASED := true

const OUTLINE_COLOR := Color("181425")
const OUTLINE_THICKNESS := 2.0
const OUTLINE_NUM_POINTS := 64

const INNER_CIRCLE_RADIUS_PROPORTION := 0.25
const INNER_CIRCLE_OUTLINE_THICKNESS := 2.0
const INNER_CIRCLE_NUM_SEGMENTS := 8

const TIME_NUM_SEGMENTS := 24

const SAFE_COLOR := Color("63c74d")
const WARNING_COLOR := Color("feae34")
const CRITICAL_COLOR := Color("cc2530")

const SAFETY_VALUE_TO_COLOR := {
	0: SAFE_COLOR,
	1: WARNING_COLOR,
	2: CRITICAL_COLOR,
}

var _hour_safety_values: Array
var _center: Vector2
var _clock_radius: float
# A dictionary containing time float values that match up to their time button
# node instances.
var _time_to_buttons := {}


func _ready() -> void:
	# When the date/time is changed the clock should be updated.
	GlobalDate.connect("date_time_changed", self, "_update_safety_values")
	_update_safety_values()
	_add_time_buttons()
	_on_rect_changed()


func _draw() -> void:
	_draw_hour_safety_sectors()
	_draw_hour_safety_segments()
	_draw_main_circle()


func force_press_time_button(time: float) -> void:
	var button: Button = _time_to_buttons[time]
	button.pressed = true
	button.disabled = true


func _update_safety_values() -> void:
	_hour_safety_values = _get_hour_safety_values()
	update()


func _get_hour_safety_values() -> Array:
	var hour_safety_values := []
	# Iterating through every hour (0 to 23).
	for i in 24:
		var safety_value := Util.get_safety_value_current_date(i)
		# Append the final hourly safety value to the array of safety values for
		# that day.
		hour_safety_values.append(safety_value)
	return hour_safety_values


func _add_time_buttons() -> void:
	# Calculate the gap in time between each time button segment based on the
	# number of time segments there should be.
	var time_diff := 24.0 / TIME_NUM_SEGMENTS
	for i in TIME_NUM_SEGMENTS:
		# Calculate the button's time based on the time gap between each time
		# button and the index of the current time button.
		var time: float = time_diff * i
		var button := TIME_BUTTON_SCENE.instance()
		# Set the time button's text to a string formatted version of the time.
		button.text = Util.to_time_string(time)
		add_child(button)
		button.connect("pressed", self, "_on_Time_Button_pressed", [button, time])
		_time_to_buttons[time] = button


func _on_Clock_item_rect_changed() -> void:
	_on_rect_changed()


func _on_rect_changed() -> void:
	# Reset any parameters that are dependent on the clock's rect size if the
	# rect is changed.
	_center = rect_size / 2
	_clock_radius = min(rect_size.x, rect_size.y) / 2
	_set_time_button_positions()


func _set_time_button_positions() -> void:
	# Get the angle between each time button (relative to the clock's center).
	var segment_angle := TAU / TIME_NUM_SEGMENTS
	for i in get_child_count():
		var button := get_child(i)
		# Get the total angle deviation from midnight. 
		var angle: float = segment_angle * i
		# Get the direction unit vector.
		var dir := Vector2.UP.rotated(angle)
		# Calculate the button's position.
		var vec := dir * _clock_radius
		# An offset must be applied to the button's position so that it is
		# centered.
		var offset: Vector2 = -button.rect_size / 2
		# The new button position should also take the position of the clock's
		# center in mind.
		button.rect_position = _center + vec + offset


func _on_Time_Button_pressed(button: Button, time: float) -> void:
	# If a time button is pressed then it should be disabled
	# and all the other buttons should be unpressed and undisabled.
	for child in get_children():
		if child == button:
			child.disabled = true
			continue
		child.pressed = false
		child.disabled = false
	emit_signal("time_changed", time)


func _draw_main_circle() -> void:
	# Draw the clock's outline.
	draw_arc(
		_center,
		_clock_radius,
		0,
		TAU,
		OUTLINE_NUM_POINTS,
		OUTLINE_COLOR,
		OUTLINE_THICKNESS,
		IS_ANTIALIASED
	)


func _draw_hour_safety_sectors() -> void:
	# Calculate the angle between each hour (keep in mind there are 24 hours).
	var hour_angle := TAU / 24
	# Iterate over every hour.
	for i in range(24):
		# Calculate the initial angle for that hour sector.
		var start_angle := hour_angle * i
		# Calculate the end angle for that hour sector.
		var end_angle := hour_angle * (i + 1)
		# Get the safety value for that hour.
		var safety_value: int = _hour_safety_values[i]
		# Get the color based on that safety value.
		var color: Color = SAFETY_VALUE_TO_COLOR[safety_value]
		# Draw the sector.
		_draw_sector(_center, _clock_radius, start_angle, end_angle, color, IS_ANTIALIASED)


func _draw_hour_safety_segments() -> void:
	# Calculate the angle between each hour (keep in mind there are 24 hours).
	var hour_angle := TAU / 24
	# Iterate over every hour
	for i in range(24):
		# Get the previous safety value (hour - 1).
		# Keep in mind it should wrap so if it is currently 00:00 then the
		# previous hour would be 23:00.
		var prev_safety_value: float = _hour_safety_values[(i - 1) % 24]
		# Get the current safety value for that hour.
		var safety_value: float = _hour_safety_values[i]
		# If the current safety value is different from the previous safety
		# value then draw a segment division.
		if safety_value != prev_safety_value:
			# Calculate the angle of that segment division.
			var angle := hour_angle * i
			# Calculate the direction unit vector.
			var dir := Vector2.UP.rotated(angle)
			# Calculate the offset the division should end at relative to the
			# clock's center.
			var vec := dir * _clock_radius
			# Calculate the division's final position by taking into account
			# the clock's center.
			var final_pos := _center + vec
			# Draw the segment division line.
			draw_line(_center, final_pos, OUTLINE_COLOR, OUTLINE_THICKNESS, IS_ANTIALIASED)


func _draw_sector(
	center: Vector2,
	radius: float,
	start_angle: float,
	end_angle: float,
	color: Color,
	antialiased: bool = false
) -> void:
	# Credit: https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#arc-polygon-function
	var nb_points := 32
	# The points in the sector should consistent of the center as well as the
	# points that lie on the sector's arc.
	var points_arc := PoolVector2Array([center])
	var colors := PoolColorArray([color])
	for i in range(nb_points + 1):
		# Calculate the angle of this point of the arc.
		var angle = start_angle + i * (end_angle - start_angle) / nb_points
		# Calculate the offset of the point relative to the center.
		var vec := Vector2.UP.rotated(angle) * radius
		# Calculate the final point position.
		var point := center + vec
		points_arc.push_back(point)
	# Draw the sector.
	draw_polygon(points_arc, colors, PoolVector2Array(), null, null, antialiased)
