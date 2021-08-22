tool
class_name Clock
extends Control

signal time_changed(new_time)

const PLACEHOLDER_DAY := 3

const TIME_BUTTON_SCENE := preload("res://ui/clock/time_button.tscn")

const IS_ANTIALIASED := true

const OUTLINE_COLOR := Color("181425")
const OUTLINE_THICKNESS := 2.0

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
		var safety_value := 0
		# Grabbing the data for that hour.
		var hourly_data := DatabaseFetch.read_db_time_current_date(i)
		hourly_data.erase("ID")
		hourly_data.erase("DateTime")
		hourly_data.erase("Hour")
		var trailer_weights := Util.get_trailer_weights(hourly_data)
		var has_cargo := Util.has_cargo(trailer_weights)
		for sensor in hourly_data:
			var value: int = hourly_data[sensor]
			var identifier: String = sensor[-1]
			var temp_safety_value: int
			if "TyrePressure" in sensor:
				temp_safety_value = _get_safety_value(
					value,
					CriticalLimits.MIN_TYRE_PRESSURE,
					CautionLimits.MIN_TYRE_PRESSURE,
					CriticalLimits.MAX_TYRE_PRESSURE,
					CautionLimits.MAX_TYRE_PRESSURE
				)
			elif "BrakePads" in sensor:
				temp_safety_value = _get_safety_value(
					value,
					CriticalLimits.MIN_BRAKE_PADS,
					CautionLimits.MIN_BRAKE_PADS
				)
			elif "TruckWheelBearingTemp" in sensor:
				temp_safety_value = _get_safety_value(
					value,
					null,
					null,
					CriticalLimits.MAX_WHEEL_BEARING_TEMP,
					CautionLimits.MAX_WHEEL_BEARING_TEMP
				)
			elif "TrailerTemperature" in sensor:
				if not has_cargo:
					continue
				if identifier in ["A", "B", "C"]:
					temp_safety_value = _get_safety_value(
						value,
						CriticalLimits.MIN_FREEZER_TEMP
					)
				elif identifier in ["D", "E", "F"]:
					temp_safety_value = _get_safety_value(
						value,
						null,
						null,
						CriticalLimits.MAX_FRIDGE_TEMP
					)
			elif "TrailerWeight" in sensor:
				temp_safety_value = _get_safety_value(
					value,
					null,
					null,
					CriticalLimits.MAX_WEIGHT,
					CautionLimits.MAX_WEIGHT
				)
			if temp_safety_value > safety_value:
				safety_value = temp_safety_value
				# If the safety value is at critical then there is no need to
				# check further as it can't go any higher.
				if safety_value == 2:
					break
		var weight_differential: int = trailer_weights.max() - trailer_weights.min()
		var weight_differential_safety_value = _get_safety_value(
			weight_differential,
			null,
			null,
			CriticalLimits.MAX_WEIGHT_DIFFERENTIAL,
			CautionLimits.MAX_WEIGHT_DIFFERENTIAL
		)
		if weight_differential_safety_value > safety_value:
			safety_value = weight_differential_safety_value
		hour_safety_values.append(safety_value)
	return hour_safety_values


func _get_safety_value(
	value: int,
	min_value_critical = null,
	min_value_caution = null,
	max_value_critical = null,
	max_value_caution = null
) -> int:
	if (
		(min_value_critical and value < min_value_critical) or
		(max_value_critical and value > max_value_critical)
	):
		return 2
	elif (
		(min_value_caution and value < min_value_caution) or
		(max_value_caution and value > max_value_caution)
	):
		return 1
	return 0


func _add_time_buttons() -> void:
	var time_diff := 24.0 / TIME_NUM_SEGMENTS
	for i in TIME_NUM_SEGMENTS:
		var time: float = time_diff * i
		var button := TIME_BUTTON_SCENE.instance()
		button.text = Util.to_time_string(time)
		add_child(button)
		button.connect("pressed", self, "_on_Time_Button_pressed", [button, time])
		_time_to_buttons[time] = button


func _on_rect_changed() -> void:
	_center = rect_size / 2
	_clock_radius = min(rect_size.x, rect_size.y) / 2
	if Engine.editor_hint:
		return
	_set_time_button_positions()


func _set_time_button_positions() -> void:
	var segment_angle := TAU / TIME_NUM_SEGMENTS
	for i in get_child_count():
		var button := get_child(i)
		var angle: float = segment_angle * i
		var dir := Vector2.UP.rotated(angle)
		var vec := dir * _clock_radius
		var offset: Vector2 = -button.rect_size / 2
		button.rect_position = _center + vec + offset


func _on_Time_Button_pressed(button: Button, time: float) -> void:
	for child in get_children():
		if child == button:
			child.disabled = true
			continue
		child.pressed = false
		child.disabled = false
	emit_signal("time_changed", time)


func _draw_main_circle() -> void:
	draw_arc(_center, _clock_radius, 0, TAU, 64, OUTLINE_COLOR, OUTLINE_THICKNESS, IS_ANTIALIASED)


func _draw_hour_safety_sectors() -> void:
	var hour_angle := TAU / 24
	for i in range(24):
		var start_angle := hour_angle * i - TAU / 4
		var end_angle := hour_angle * (i + 1) - TAU / 4
		var safety_value: int = _hour_safety_values[i]
		var color: Color = SAFETY_VALUE_TO_COLOR[safety_value]
		_draw_sector(_center, _clock_radius, start_angle, end_angle, color, IS_ANTIALIASED)


func _draw_hour_safety_segments() -> void:
	var hour_angle := TAU / 24
	for i in range(24):
		var prev_safety_value: float = _hour_safety_values[(i - 1) % 24]
		var safety_value: float = _hour_safety_values[i]
		if safety_value != prev_safety_value:
			var angle := hour_angle * i
			var dir := Vector2.UP.rotated(angle)
			var vec := dir * _clock_radius
			var final_pos := _center + vec
			draw_line(_center, final_pos, OUTLINE_COLOR, OUTLINE_THICKNESS, IS_ANTIALIASED)


func _draw_sector(
	center: Vector2,
	radius: float,
	start_angle: float,
	end_angle: float,
	color: Color,
	antialiased: bool = false
) -> void:
	var nb_points := 32
	var points_arc := PoolVector2Array([center])
	var colors := PoolColorArray([color])
	for i in range(nb_points + 1):
		var angle = start_angle + i * (end_angle - start_angle) / nb_points + TAU / 4
		var vec := Vector2.UP.rotated(angle) * radius
		var point := center + vec
		points_arc.push_back(point)
	draw_polygon(points_arc, colors, PoolVector2Array(), null, null, antialiased)


func _on_Clock_item_rect_changed() -> void:
	_on_rect_changed()
