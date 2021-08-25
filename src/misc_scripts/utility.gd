class_name Util
extends Object

static func to_time_string(num_hours: float) -> String:
	# Converts the number of hours into a string.
	# For example, hour 0 means midnight so it would be "00:00".
	# Hour 23 would be "23:00".
	# It also works with fractional hours so 3.5 would be "03:30".
	var whole_hours := int(num_hours)
	var remaining_hours := num_hours - whole_hours
	var remaining_mins := remaining_hours * 60
	return "%02d:%02d" % [whole_hours, remaining_mins]

static func randi_range(from: int, to: int) -> int:
	var r := range(from, to + 1)
	return r[randi() % r.size()]

static func get_trailer_weights(data: Dictionary) -> Array:
	var trailer_weights := []
	for sensor in data:
		if "TrailerWeight" in sensor:
			var value: int = data[sensor]
			trailer_weights.append(value)
	return trailer_weights

static func is_freezer_in_use(data: Dictionary) -> bool:
	return data["TrailerWeightG"] > 0

static func is_fridge_in_use(data: Dictionary) -> bool:
	return (
		data["TrailerWeightA"] > 0
		or data["TrailerWeightD"] > 0
		or data["TrailerWeightC"] > 0
		or data["TrailerWeightF"] > 0
	)

static func _get_individual_safety_value(
	value: int,
	min_value_critical = null,
	min_value_caution = null,
	max_value_critical = null,
	max_value_caution = null
) -> int:
	if (
		(min_value_critical and value < min_value_critical)
		or (max_value_critical and value > max_value_critical)
	):
		# If the value is critical.
		return 2
	elif (
		(min_value_caution and value < min_value_caution)
		or (max_value_caution and value > max_value_caution)
	):
		# If the value is caution.
		return 1
	# If the value is safe.
	return 0

static func get_safety_value(year: int, month: int, day: int, hour: int) -> int:
	var safety_value := 0
	# Grabbing the data for that hour.
	var hourly_data := DatabaseFetch.read_db_time_new(year, month, day, hour)
	# We only need the sensor values so the ID, DateTime, and Hour can be
	# erased.
	hourly_data.erase("ID")
	hourly_data.erase("DateTime")
	hourly_data.erase("Hour")
	var trailer_weights := get_trailer_weights(hourly_data)
	# If the freezer is not in use then its temperature values can be ignored.
	var is_freezer_in_use := is_freezer_in_use(hourly_data)
	# If the fridge is not in use then its temperature values can be ignored.
	var is_fridge_in_use := is_fridge_in_use(hourly_data)
	# Iterate over the sensors.
	for sensor in hourly_data:
		var value: int = hourly_data[sensor]
		# The identifier refers to the letter at the end of a sensor which
		# differentiates it from other similar sensors in the same category.
		var identifier: String = sensor[-1]
		# The temp safety value is the safety value (0 means safe, 1 means
		# caution, 2 means critical) for that specific sensor value.
		# If the temp safety value is greater than the hourly safety value
		# then the hourly safety value should be replaced with the temp
		# safety value.
		# This essentially means that any caution (1) warnings will override
		# the rest of the sensor values being safe (0).
		# And any critical (2) warnings will override the rest of the sensor
		# values being safe (0) or caution (1).
		var temp_safety_value: int
		# Match the sensor to the correct type and assign the temp safety
		# value based on if it fits within its appropriate limits.
		if "TyrePressure" in sensor:
			temp_safety_value = _get_individual_safety_value(
				value,
				CriticalLimits.MIN_TYRE_PRESSURE,
				CautionLimits.MIN_TYRE_PRESSURE,
				CriticalLimits.MAX_TYRE_PRESSURE,
				CautionLimits.MAX_TYRE_PRESSURE
			)
		elif "BrakePads" in sensor:
			temp_safety_value = _get_individual_safety_value(
				value, CriticalLimits.MIN_BRAKE_PADS, CautionLimits.MIN_BRAKE_PADS
			)
		elif "TruckWheelBearingTemp" in sensor:
			temp_safety_value = _get_individual_safety_value(
				value,
				null,
				null,
				CriticalLimits.MAX_WHEEL_BEARING_TEMP,
				CautionLimits.MAX_WHEEL_BEARING_TEMP
			)
		elif "TrailerTemperature" in sensor:
			# If either the freezer or fridge are not in use then it does not
			# matter what their temperature values are.
			if is_freezer_in_use and identifier in ["A", "B", "C"]:  # Freezer sensors
				temp_safety_value = _get_individual_safety_value(
					value, null, null, CriticalLimits.MAX_FREEZER_TEMP
				)
			elif is_fridge_in_use and identifier in ["D", "E", "F"]:  # Fridge sensors
				temp_safety_value = _get_individual_safety_value(
					value, null, null, CriticalLimits.MAX_FRIDGE_TEMP
				)
		elif "TrailerWeight" in sensor:
			temp_safety_value = _get_individual_safety_value(
				value, null, null, CriticalLimits.MAX_WEIGHT, CautionLimits.MAX_WEIGHT
			)
		if temp_safety_value > safety_value:
			safety_value = temp_safety_value
			# If the safety value is at critical then there is no need to
			# check further as it can't go any higher.
			if safety_value == 2:
				break
	# Calculate the weight differential (difference between heaviest point
	# and lightest point).
	var weight_differential: int = trailer_weights.max() - trailer_weights.min()
	# Apply the previous logic but just for the weight differential.
	var weight_differential_safety_value = _get_individual_safety_value(
		weight_differential,
		null,
		null,
		CriticalLimits.MAX_WEIGHT_DIFFERENTIAL,
		CautionLimits.MAX_WEIGHT_DIFFERENTIAL
	)
	if weight_differential_safety_value > safety_value:
		safety_value = weight_differential_safety_value
	return safety_value

static func get_safety_value_current_date(hour: int) -> int:
	return get_safety_value(
		GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay, hour
	)
