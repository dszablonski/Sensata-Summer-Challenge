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

static func get_trailer_weights(data: Dictionary) -> Array:
	var trailer_weights := []
	for sensor in data:
		if "TrailerWeight" in sensor:
			var value: int = data[sensor]
			trailer_weights.append(value)
	return trailer_weights

static func has_cargo(trailer_weights: Array) -> bool:
	for weight in trailer_weights:
		if weight > 0:
			return true
	return false
