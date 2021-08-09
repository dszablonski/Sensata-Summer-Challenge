extends PanelContainer

const WARNING_LABEL_SCENE := preload("res://ui/warnings/warning_label.tscn")

# Placeholder data while the database is being worked on
const DATA := {
	"TruckTyrePressureA": 130,
	"TruckTyrePressureB": 135,
	"TruckTyrePressureC": 122,
	"TruckTyrePressureD": 121,
	"TruckTyrePressureE": 119,
	"TruckTyrePressureF": 123,
	"TruckBrakePadsA": 13,
	"TruckBrakePadsB": 12,
	"TruckWheelBearingTempA": 56,
	"TruckWheelBearingTempB": 56,
	"TruckWheelBearingTempD": 57,
	"TruckWheelBearingTempF": 56,
	"TrailerTyrePressureA": 112,
	"TrailerTyrePressureB": 110,
	"TrailerTyrePressureC": 107,
	"TrailerTyrePressureD": 113,
	"TrailerTyrePressureE": 108,
	"TrailerTyrePressureF": 109,
	"TrailerTemperatureA": -3,
	"TrailerTemperatureB": -3,
	"TrailerTemperatureC": -3,
	"TrailerTemperatureD": 5,
	"TrailerTemperatureE": 5,
	"TrailerTemperatureF": 5,
	"TrailerWeightA": 745,
	"TrailerWeightC": 786,
	"TrailerWeightD": 545,
	"TrailerWeightF": 654,
	"TrailerWeightG": 658,
	"TrailerBrakePadsA": 13,
	"TrailerBrakePadsB": 16,
	"TrailerBrakePadsC": 15,
	"TrailerBrakePadsD": 14,
	"TrailerBrakePadsE": 16,
	"TrailerBrakePadsF": 14,
}

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

const TYRE_UNPRESSURIZED_CRITICAL_WARNING := "%s tyre %s too unpressurized! (%s psi)"
const TYRE_UNPRESSURIZED_CAUTION_WARNING := "%s tyre %s almost too unpressurized! (%s psi)"
const TYRE_PRESSURIZED_CRITICAL_WARNING := "%s tyre %s too pressurized! (%s psi)"
const TYRE_PRESSURIZED_CAUTION_WARNING := "%s tyre %s almost too pressurized! (%s psi)"

const BRAKE_PADS_CRITICAL_WARNING := "%s brake pad %s too worn down! (%s%% left)"
const BRAKE_PADS_CAUTION_WARNING := "%s brake pad %s almost too worn down! (%s%% left)"

const WHEEL_BEARING_CRITICAL_WARNING := "%s wheel bearing %s too hot! (%s°C)"
const WHEEL_BEARING_CAUTION_WARNING := "%s wheel bearing %s almost too hot! (%s°C)"

const FREEZER_TEMP_COLD_CRITICAL_WARNING := "Freezer temperature at point %s too cold! (%s°C)"
const FRIDGE_TEMP_WARM_CRITICAL_WARNING := "Fridge temperature at point %s too warm! (%s°C)"

const TRAILER_HEAVY_CRITICAL_WARNING := "Trailer weight at point %s too heavy! (%s kg)"
const TRAILER_HEAVY_CAUTION_WARNING := "Trailer weight at point %s almost too heavy! (%s kg)"

const WEIGHT_EVENLY_DISPERSED_CRITICAL_WARNING := "Trailer weight not evenly dispersed!"
const WEIGHT_EVENLY_DISPERSED_CAUTION_WARNING := "Trailer weight almost not evenly dispersed!"

const WEIGHT_UNBALANCED_CAUTION_WARNING := "Trailer weight at point %s too unbalanced! (%s kg)"

var _critical_warnings: Array
var _caution_warnings: Array

onready var critical_warnings_vbox: VBoxContainer = $VSplitContainer/HSplitContainer/Critical/ScrollContainer/CriticalWarnings
onready var caution_warnings_vbox: VBoxContainer = $VSplitContainer/HSplitContainer/Caution/ScrollContainer/CautionWarnings
onready var limits_popup: Popup = $LimitsPopup


func _ready() -> void:
	_update_warnings(DATA)


func _update_warnings(data: Dictionary) -> void:
	_clear_warning_labels()
	_critical_warnings = []
	_caution_warnings = []
	var trailer_weights := {}
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
			trailer_weights[sensor] = value
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
		if i == DATA.keys().find("TrailerWeightG"):
			var weight_values := trailer_weights.values()
			var weight_differential: int = weight_values.max() - weight_values.min()
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
			for weight_sensor in trailer_weights:
				var weight_identifier: String = weight_sensor[-1]
				var weight_value: int = trailer_weights[weight_sensor]
				var warning := WEIGHT_UNBALANCED_CAUTION_WARNING % [weight_identifier, weight_value]
				_caution_warnings.append(warning)
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
