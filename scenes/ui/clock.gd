extends Label

# Start time
var start_timestamp = _datetime_to_unix(2025, 9, 25, 12, 30, 20)
var elapsed_seconds := 0
var timer : Timer

func _ready():
	# Create Timer in code
	timer = Timer.new()
	timer.wait_time = 1.0      # update every second
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	
	# Initial display
	_update_label()

func _on_timer_timeout():
	elapsed_seconds += 1
	_update_label()

func _update_label():
	var total_seconds = start_timestamp + elapsed_seconds
	var t = Time.get_datetime_dict_from_unix_time(total_seconds)
	
	text = "%04d-%02d-%02d %02d:%02d:%02d" % [
		t.year, t.month, t.day,
		t.hour, t.minute, t.second
	]

# Helper: convert a specific datetime to Unix timestamp
func _datetime_to_unix(year, month, day, hour, minute, second):
	var dt = {
		"year": year,
		"month": month,
		"day": day,
		"hour": hour,
		"minute": minute,
		"second": second
	}
	return  Time.get_unix_time_from_datetime_dict(dt)
