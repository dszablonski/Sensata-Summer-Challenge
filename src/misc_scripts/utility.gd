class_name Util
extends Object

static func to_time_string(num_hours: float) -> String:
	var whole_hours := int(num_hours)
	var remaining_hours := num_hours - whole_hours
	var remaining_mins := remaining_hours * 60
	return "%02d:%02d" % [whole_hours, remaining_mins]
