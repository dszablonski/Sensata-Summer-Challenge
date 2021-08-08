extends Label


func setup(time: float) -> void:
	var time_string = Util.to_time_string(time)
	text = "1/6/2021 %s" % time_string
