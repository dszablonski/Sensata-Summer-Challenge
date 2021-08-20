extends PanelContainer

const WARNING_LABEL_SCENE := preload("res://ui/warnings/warning_label.tscn")

const DATA_CATEGORY_INDEXES := [0, 6, 8, 12, 18, 21, 24, 29]

const TRAILER_START_INDEX := 12

const DATA_CATEGORY_SORT_DESCENDING := [
	true,
	false,
	true,
	true,
	false,
	true,
	true,
	false,
]

const TYRE_UNPRESSURIZED_CRITICAL_WARNING := "%s tyre %s [color=#ff0000]pressure too low![/color] (%s psi)"
const TYRE_UNPRESSURIZED_CAUTION_WARNING := "%s tyre %s [color=#FFFF00]pressure very low![/color] (%s psi)"
const TYRE_PRESSURIZED_CRITICAL_WARNING := "%s tyre %s [color=#ff0000]pressure too high![/color] (%s psi)"
const TYRE_PRESSURIZED_CAUTION_WARNING := "%s tyre %s [color=#FFFF00]pressure very high![/color] (%s psi)"

const BRAKE_PADS_CRITICAL_WARNING := "%s brake pad %s [color=#ff0000]too worn down![/color] (%s%% left)"
const BRAKE_PADS_CAUTION_WARNING := "%s brake pad %s [color=#FFFF00]very worn down![/color] (%s%% left)"

const WHEEL_BEARING_CRITICAL_WARNING := "%s wheel bearing %s [color=#ff0000]too hot![/color] (%s°C)"
const WHEEL_BEARING_CAUTION_WARNING := "%s wheel bearing %s [color=#FFFF00]very hot![/color] (%s°C)"

const FREEZER_TEMP_COLD_CRITICAL_WARNING := "Freezer temperature at point %s [color=#ff0000]too cold![/color] (%s°C)"
const FRIDGE_TEMP_WARM_CRITICAL_WARNING := "Fridge temperature at point %s [color=#ff0000]too warm![/color] (%s°C)"

const TRAILER_HEAVY_CRITICAL_WARNING := "Trailer weight at point %s [color=#ff0000]too heavy![/color] (%s kg)"
const TRAILER_HEAVY_CAUTION_WARNING := "Trailer weight at point %s [color=#FFFF00]very heavy![/color] (%s kg)"

const WEIGHT_EVENLY_DISPERSED_CRITICAL_WARNING := "Trailer weight [color=#ff0000]not evenly dispersed![/color]"
const WEIGHT_EVENLY_DISPERSED_CAUTION_WARNING := "Trailer weight [color=#FFFF00]not very evenly dispersed![/color]"

var _critical_warnings: Array
var _caution_warnings: Array

onready var critical_warnings_vbox: VBoxContainer = $VSplitContainer/HSplitContainer/Critical/ScrollContainer/CriticalWarnings
onready var caution_warnings_vbox: VBoxContainer = $VSplitContainer/HSplitContainer/Caution/ScrollContainer/CautionWarnings
onready var limits_popup: Popup = $LimitsPopup


func _ready() -> void:
	# When the date/time is changed the warnings should be updated.
	GlobalDate.connect("date_time_changed", self, "_update_warnings_based_on_date_time")


func _update_warnings_based_on_date_time() -> void:
	var data := DatabaseFetch.read_db_time_current()
	data.erase("ID")
	data.erase("DateTime")
	data.erase("Hour")
	_update_warnings(data)


func _update_warnings(data: Dictionary) -> void:
	_clear_warning_labels()
	_critical_warnings = []
	_caution_warnings = []
	var trailer_weights := Util.get_trailer_weights(data)
	var has_cargo := Util.has_cargo(trailer_weights)
	var sensors := _get_sorted_sensors(data)
	for i in range(len(sensors)):
		var sensor: String = sensors[i]
		var identifier: String = sensor[-1]
		var component := "Truck" if i < TRAILER_START_INDEX else "Trailer"
		var value: int = data[sensor]
		if "TyrePressure" in sensor:
			_add_warning_text(
				value,
				[component, identifier, value],
				CriticalLimits.MIN_TYRE_PRESSURE,
				TYRE_UNPRESSURIZED_CRITICAL_WARNING,
				CautionLimits.MIN_TYRE_PRESSURE,
				TYRE_UNPRESSURIZED_CAUTION_WARNING,
				CriticalLimits.MAX_TYRE_PRESSURE,
				TYRE_PRESSURIZED_CRITICAL_WARNING,
				CautionLimits.MAX_TYRE_PRESSURE,
				TYRE_PRESSURIZED_CAUTION_WARNING
			)
		elif "BrakePads" in sensor:
			_add_warning_text(
				value,
				[component, identifier, value],
				CriticalLimits.MIN_BRAKE_PADS,
				BRAKE_PADS_CRITICAL_WARNING,
				CautionLimits.MIN_BRAKE_PADS,
				BRAKE_PADS_CAUTION_WARNING
			)
		elif "TruckWheelBearingTemp" in sensor:
			_add_warning_text(
				value,
				[component, identifier, value],
				null,
				"",
				null,
				"",
				CriticalLimits.MAX_WHEEL_BEARING_TEMP,
				WHEEL_BEARING_CRITICAL_WARNING,
				CautionLimits.MAX_WHEEL_BEARING_TEMP,
				WHEEL_BEARING_CAUTION_WARNING
			)
		elif "TrailerTemperature" in sensor:
			if not has_cargo:
				continue
			if identifier in ["A", "B", "C"]:
				_add_warning_text(
					value,
					[identifier, value],
					CriticalLimits.MIN_FREEZER_TEMP,
					FREEZER_TEMP_COLD_CRITICAL_WARNING
				)
			elif identifier in ["D", "E", "F"]:
				_add_warning_text(
					value,
					[identifier, value],
					null,
					"",
					null,
					"",
					CriticalLimits.MAX_FRIDGE_TEMP,
					FRIDGE_TEMP_WARM_CRITICAL_WARNING
				)
		elif "TrailerWeight" in sensor:
			_add_warning_text(
				value,
				[identifier, value],
				null,
				"",
				null,
				"",
				CriticalLimits.MAX_WEIGHT,
				TRAILER_HEAVY_CRITICAL_WARNING,
				CautionLimits.MAX_WEIGHT,
				TRAILER_HEAVY_CAUTION_WARNING
			)
		if i == data.keys().find("TrailerWeightG"):
			var weight_differential: int = trailer_weights.max() - trailer_weights.min()
			_add_warning_text(
				weight_differential,
				[],
				null,
				"",
				null,
				"",
				CriticalLimits.MAX_WEIGHT_DIFFERENTIAL,
				WEIGHT_EVENLY_DISPERSED_CRITICAL_WARNING,
				CautionLimits.MAX_WEIGHT_DIFFERENTIAL,
				WEIGHT_EVENLY_DISPERSED_CAUTION_WARNING
			)
	_add_warning_labels()


func _clear_warning_labels() -> void:
	for label in critical_warnings_vbox.get_children():
		label.queue_free()
	for label in caution_warnings_vbox.get_children():
		label.queue_free()


func _get_sorted_sensors(data: Dictionary) -> Array:
	# How it works:
	# 1. Splits the sensors into categories
	# 2. Sorts the sensors based on how dangerous their values are
	# (for some this may be descending order but for others it may be ascending)
	# 3. Flattens the sorted sensor categories into one big sorted sensor array
	# (note that the sensor categories themselves do not get sorted)
	var sorted_sensors := []
	var sensors := data.keys()
	var num_sensors := len(sensors)
	var num_categories := len(DATA_CATEGORY_INDEXES)
	for i in range(num_categories):
		var start_index: int = DATA_CATEGORY_INDEXES[i]
		var end_index: int
		if i + 1 >= num_categories:
			end_index = num_sensors - 1
		else:
			end_index = DATA_CATEGORY_INDEXES[i + 1] - 1
		var sensor_category := sensors.slice(start_index, end_index)

		var sensor_category_and_values := []
		for sensor in sensor_category:
			var value: int = data[sensor]
			sensor_category_and_values.append([sensor, value])

		var should_sort_descending: bool = DATA_CATEGORY_SORT_DESCENDING[i]
		if should_sort_descending:
			sensor_category_and_values.sort_custom(self, "_sort_sensor_category_descending")
		else:
			sensor_category_and_values.sort_custom(self, "_sort_sensor_category_ascending")

		for sensor_value_pair in sensor_category_and_values:
			sorted_sensors.append(sensor_value_pair[0])
	return sorted_sensors


func _sort_sensor_category_descending(a: Array, b: Array) -> bool:
	return a[1] > b[1]


func _sort_sensor_category_ascending(a: Array, b: Array) -> bool:
	return a[1] < b[1]


func _add_warning_text(
	value: int,
	fill_ins := [],
	min_value_critical = null,
	min_value_critical_warning := "",
	min_value_caution = null,
	min_value_caution_warning := "",
	max_value_critical = null,
	max_value_critical_warning := "",
	max_value_caution = null,
	max_value_caution_warning := ""
) -> void:
	if min_value_critical and value < min_value_critical:
		var warning := min_value_critical_warning % fill_ins
		_critical_warnings.append(warning)
	elif min_value_caution and value < min_value_caution:
		var warning := min_value_caution_warning % fill_ins
		_caution_warnings.append(warning)
	elif max_value_critical and value > max_value_critical:
		var warning := max_value_critical_warning % fill_ins
		_critical_warnings.append(warning)
	elif max_value_caution and value > max_value_caution:
		var warning := max_value_caution_warning % fill_ins
		_caution_warnings.append(warning)


func _add_warning_labels() -> void:
	for critical_warning in _critical_warnings:
		var warning_label := WARNING_LABEL_SCENE.instance()
		warning_label.bbcode_text = critical_warning
		critical_warnings_vbox.add_child(warning_label)
	for caution_warning in _caution_warnings:
		var warning_label := WARNING_LABEL_SCENE.instance()
		warning_label.bbcode_text = caution_warning
		caution_warnings_vbox.add_child(warning_label)


func _on_PingButton_pressed() -> void:  # TODO
	print("Ping button pressed!")


func _on_LimitsButton_pressed() -> void:
	limits_popup.popup_centered()
