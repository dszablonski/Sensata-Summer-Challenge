extends PanelContainer

const WARNING_LABEL_SCENE := preload("res://ui/warnings/warning_label.tscn")

# This array contains the first sensor of each new category.
# Each category should be independently sorted while keeping the position of
# each category as a whole constant.
const DATA_CATEGORIES := [
	"TruckTyrePressureA",
	"TruckBrakePadsA",
	"TruckWheelBearingTempA",
	"TrailerTyrePressureA",
	"TrailerTemperatureA",  # Freezer
	"TrailerTemperatureD",  # Fridge
	"TrailerWeightA",
	"TrailerBrakePadsA",
]

# This dictionary says whether or not a category should be sorted in descending
# order.
# Data categories should be sorted with the most noteworthy values at the top
# so for some this may mean sorting in descending order (biggest at the top)
# but for others it may mean sorting in ascending order (smallest at the top).
const DATA_CATEGORY_TO_SORT_DESCENDING := {
	"TruckTyrePressureA": true,
	"TruckBrakePadsA": false,
	"TruckWheelBearingTempA": true,
	"TrailerTyrePressureA": true,
	"TrailerTemperatureA": false,  # Freezer
	"TrailerTemperatureD": true,  # Fridge
	"TrailerWeightA": true,
	"TrailerBrakePadsA": false,
}

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
	_update_warnings_based_on_date_time()


func _update_warnings_based_on_date_time() -> void:
	var data := DatabaseFetch.read_db_time_current()
	# The ID, DateTime, and Hour columns are not sensors so they can be discarded.
	data.erase("ID")
	data.erase("DateTime")
	data.erase("Hour")
	_update_warnings(data)


func _update_warnings(data: Dictionary) -> void:
	_clear_warning_labels()
	_critical_warnings = []
	_caution_warnings = []
	var trailer_weights := Util.get_trailer_weights(data)
	# Many values are only important to take into consideration if the trailer
	# actually has cargo.
	# For example, while there is no cargo it does not matter if the freezer
	# or fridge is at room temperature.
	var has_cargo := Util.has_cargo(trailer_weights)
	var unsorted_sensors := data.keys()
	var sensors := _get_sorted_sensors(data)
	# The last trailer weight sensor index is necessary as the "weight not
	# evenly dispersed" warning should only appear after the "trailer weight
	# too heavy" warnings.
	# It's important that the unsorted list of sensors is used instead of the
	# sorted one as in the sorted array TrailerWeightG might not be the last
	# trailer weight sensor displayed.
	var last_trailer_weight_sensor_index := unsorted_sensors.find("TrailerWeightG")
	for i in range(len(sensors)):
		var sensor: String = sensors[i]
		# The identifier refers to the letter at the end of a sensor which
		# differentiates it from other similar sensors in the same category.
		var identifier: String = sensor[-1]
		var component := "Truck" if "Truck" in sensor else "Trailer"
		var value: int = data[sensor]
		# Match the sensor to the correct type and check if it fits within its
		# appropriate limits.
		# If not, add the corresponding warning message to the an array based
		# on if it's marked as "critical" or "caution".
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
			# If there is no cargo then it does not matter what the temperature
			# values are.
			if not has_cargo:
				continue
			if identifier in ["A", "B", "C"]:  # Freezer sensors
				_add_warning_text(
					value,
					[identifier, value],
					CriticalLimits.MIN_FREEZER_TEMP,
					FREEZER_TEMP_COLD_CRITICAL_WARNING
				)
			elif identifier in ["D", "E", "F"]:  # Fridge sensors
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
		# The weight differential warning should only appear after the trailer
		# weight warnings.
		if i == last_trailer_weight_sensor_index:
			# Calculate the weight differential (difference between heaviest
			# point and lightest point).
			var weight_differential: int = trailer_weights.max() - trailer_weights.min()
			# Add the warning test to the appropriate array if it exceeds the
			# safety limits.
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
	# 1. Split the sensors into categories.
	# 2. Sort the sensors based on how dangerous their values are
	# (for some this may be descending order but for others it may be ascending).
	# 3. Flatten the sorted sensor categories into one big sorted sensor array
	# (note that the sensor categories themselves do not get sorted so their
	# position relative to each other will be constant).
	var sorted_sensors := []
	var sensors := data.keys()
	var num_sensors := len(sensors)
	var num_categories := len(DATA_CATEGORIES)
	for i in range(num_categories):
		# Split the sensors into categories.
		# The end result in this step should be an array containing the sensor
		# names for just this category.
		# For example:
		# [TrailerTemperatureA, TrailerTemperatureB, TrailerTemperatureC]
		# This is an array containing just the freezer's sensors.

		# Get the first sensor in this category.
		# For the freezer's sensors this would be "TrailerTemperatureA".
		var category = DATA_CATEGORIES[i]
		# Get the index of this initial sensor.
		var start_index: int = sensors.find(category)
		var end_index: int
		if i + 1 >= num_categories:
			# If this is the last category then the final index for this category
			# should just be the final index.
			end_index = num_sensors - 1
		else:
			# The final index of this category is the same as the initial index
			# of the next category minus 1.
			var next_category = DATA_CATEGORIES[i + 1]
			end_index = sensors.find(next_category) - 1
		# Splice just the sensors from the category we want out of the main
		# sensors array.
		var sensor_category := sensors.slice(start_index, end_index)

		# Get the value of each sensor in this category and combine them into
		# an array.
		# The final output here is a 2 dimensional array.
		# For example:
		# [[TrailerTemperatureA, -3], [TrailerTemperatureB, -3], [TrailerTemperatureC, -3]]
		# The first index of each nested array contains the sensor name while
		# the second index contains the sensor's value.
		var sensor_category_and_values := []
		for sensor in sensor_category:
			var value: int = data[sensor]
			sensor_category_and_values.append([sensor, value])

		# Check if the category should be sorted in descending order.
		# If it should be, then sort it in descending order.
		# If not, then sort it in ascending order.
		var should_sort_descending: bool = DATA_CATEGORY_TO_SORT_DESCENDING[category]
		if should_sort_descending:
			sensor_category_and_values.sort_custom(self, "_sort_sensor_category_descending")
		else:
			sensor_category_and_values.sort_custom(self, "_sort_sensor_category_ascending")

		# Flatten the array by remove all the sensor values and merging the
		# sensor names into one array.
		for sensor_value_pair in sensor_category_and_values:
			sorted_sensors.append(sensor_value_pair[0])
	return sorted_sensors


func _sort_sensor_category_descending(a: Array, b: Array) -> bool:
	# Sort in descending order based on the sensor's value (the second index).
	return a[1] > b[1]


func _sort_sensor_category_ascending(a: Array, b: Array) -> bool:
	# Sort in ascending order based on the sensor's value (the second index).
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
	# value represents the sensor's value that should be checked.
	# fill_ins represents the values that should be plugged into the warning
	# message templates.

	if min_value_critical and value < min_value_critical:
		# If the value is less than the minimum value required for a critical
		# warning then append the warning text.
		var warning := min_value_critical_warning % fill_ins
		_critical_warnings.append(warning)
	elif min_value_caution and value < min_value_caution:
		# If the value is less than the minimum value required for a caution
		# warning then append the warning text.
		var warning := min_value_caution_warning % fill_ins
		_caution_warnings.append(warning)
	elif max_value_critical and value > max_value_critical:
		# If the value is bigger than the maximum value required for a critical
		# warning then append the warning text.
		var warning := max_value_critical_warning % fill_ins
		_critical_warnings.append(warning)
	elif max_value_caution and value > max_value_caution:
		# If the value is bigger than the maximum value required for a caution
		# warning then append the warning text.
		var warning := max_value_caution_warning % fill_ins
		_caution_warnings.append(warning)


func _add_warning_labels() -> void:
	# Iterate over the critical warnings and add a label for each of them.
	for critical_warning in _critical_warnings:
		var warning_label := WARNING_LABEL_SCENE.instance()
		warning_label.bbcode_text = critical_warning
		critical_warnings_vbox.add_child(warning_label)
	# Iterate over the caution warnings and add a label for each of them.
	for caution_warning in _caution_warnings:
		var warning_label := WARNING_LABEL_SCENE.instance()
		warning_label.bbcode_text = caution_warning
		caution_warnings_vbox.add_child(warning_label)


func _on_PingButton_pressed() -> void:  # Left unimplemented
	# This is left as a proof of concept for how the ping button could work.
	# Upon clicking the ping button the truck driver should receive some kind
	# of notification.
	# This could be implemented through the use of Godot's HTTPRequest node
	# which would allow us to send a POST request to a web server (potentially
	# hosted on the truck's software).
	# The truck could then display an appropriate notification based on the
	# severity and type of warning.
	# A ping could also be sent to the truck automatically if there are any
	# critical warnings.
	print("Ping button pressed!")


func _on_LimitsButton_pressed() -> void:
	# The safety limits popup should appear at the center of the screen.
	limits_popup.popup_centered()
