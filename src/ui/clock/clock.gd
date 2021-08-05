tool
extends Control

const OUTLINE_COLOR := Color("181425")
const OUTLINE_THICKNESS := 2.0

const INNER_CIRCLE_RADIUS_PROPORTION := 0.25
const INNER_CIRCLE_OUTLINE_THICKNESS := 2.0
const INNER_CIRCLE_NUM_SEGMENTS := 8

const TIME_NUM_SEGMENTS := 24

const SAFE_COLOR := Color("63c74d")
const WARNING_COLOR := Color("feae34")
const DANGER_COLOR := Color("cc2530")

const SAFETY_VALUE_TO_COLOR := {
	1.0: SAFE_COLOR,
	0.5: WARNING_COLOR,
	0.0: DANGER_COLOR,
}

# Placeholder values while the database is still being worked on
# 1 is safe
# 0.5 is a warning
# 0 is dangerous
export (Array, int) var hour_safety_values := [
	1.0,  # 00:00
	1.0,  # 01:00
	1.0,  # 02:00
	1.0,  # 03:00
	1.0,  # 04:00
	1.0,  # 05:00
	1.0,  # 06:00
	1.0,  # 07:00
	1.0,  # 08:00
	1.0,  # 09:00
	1.0,  # 10:00
	1.0,  # 11:00
	1.0,  # 12:00
	1.0,  # 13:00
	1.0,  # 14:00
	1.0,  # 15:00
	1.0,  # 16:00
	1.0,  # 17:00
	1.0,  # 18:00
	1.0,  # 19:00
	1.0,  # 20:00
	1.0,  # 21:00
	1.0,  # 22:00
	1.0,  # 23:00
] setget _set_hour_safety_values

var _center: Vector2
var _clock_radius: float


func _ready() -> void:
	_on_rect_changed()


func _draw() -> void:
	_draw_hour_safety_sectors()
	_draw_hour_safety_segments()
	_draw_main_circle()
	_draw_inner_circle()


func _draw_main_circle() -> void:
	draw_arc(_center, _clock_radius, 0, TAU, 64, OUTLINE_COLOR, OUTLINE_THICKNESS)


func _draw_inner_circle() -> void:
	var radius := _clock_radius * INNER_CIRCLE_RADIUS_PROPORTION
	draw_arc(_center, radius, 0, TAU, 64, OUTLINE_COLOR, OUTLINE_THICKNESS)
	_draw_inner_circle_segments(radius)


func _draw_inner_circle_segments(length: float) -> void:
	var segment_angle := TAU / INNER_CIRCLE_NUM_SEGMENTS
	for i in INNER_CIRCLE_NUM_SEGMENTS:
		var angle: float = segment_angle * i
		var dir := Vector2.UP.rotated(angle)
		var vec := dir * length
		draw_line(_center, _center + vec, OUTLINE_COLOR, INNER_CIRCLE_OUTLINE_THICKNESS)


func _draw_hour_safety_sectors() -> void:
	var hour_angle := TAU / 24
	for i in range(24):
		var start_angle := hour_angle * i - TAU / 4
		var end_angle := hour_angle * (i + 1) - TAU / 4
		var safety_value: float = hour_safety_values[i]
		var color: Color = SAFETY_VALUE_TO_COLOR[safety_value]
		_draw_sector(_center, _clock_radius, start_angle, end_angle, color)


func _draw_hour_safety_segments() -> void:
	var hour_angle := TAU / 24
	for i in range(24):
		var prev_safety_value: float = hour_safety_values[(i - 1) % 24]
		var safety_value: float = hour_safety_values[i]
		if safety_value != prev_safety_value:
			var angle := hour_angle * i
			var dir := Vector2.UP.rotated(angle)
			var vec := dir * _clock_radius
			var final_pos := _center + vec
			draw_line(_center, final_pos, OUTLINE_COLOR, OUTLINE_THICKNESS)


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


func _on_rect_changed() -> void:
	_center = rect_size / 2
	_clock_radius = min(rect_size.x, rect_size.y) / 2
	if Engine.editor_hint:
		return
	_add_time_buttons()


func _add_time_buttons() -> void:
	for child in get_children():
		child.queue_free()
	var segment_angle := TAU / TIME_NUM_SEGMENTS
	var time_diff := 24.0 / TIME_NUM_SEGMENTS
	for i in TIME_NUM_SEGMENTS:
		var angle: float = segment_angle * i
		var time: float = time_diff * i
		var dir := Vector2.UP.rotated(angle)
		var vec := dir * _clock_radius
		var button = Button.new()
		button.rect_position = _center + vec
		button.text = _to_time_string(time)
		add_child(button)
		button.rect_position -= button.rect_size / 2
		button.connect("pressed", self, "_on_Time_pressed", [time])


func _to_time_string(num_hours: float) -> String:
	var whole_hours := int(num_hours)
	var remaining_hours := num_hours - whole_hours
	var remaining_mins := remaining_hours * 60
	return "%02d:%02d" % [whole_hours, remaining_mins]


func _on_Time_pressed(time: float) -> void:  # TODO
	print("Time %s was pressed!" % time)


func _set_hour_safety_values(value: Array) -> void:
	hour_safety_values = value
	update()
