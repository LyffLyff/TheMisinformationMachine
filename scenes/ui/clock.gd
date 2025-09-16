extends Label

signal time_run_out

 # 10 days in seconds -> Time for the entire game
const START_SECONDS := 10 * 24 * 60 * 60

var remaining_seconds: int = START_SECONDS
var timer: Timer
var time_multiplier: float = 10.0
var display_seconds: float = START_SECONDS

func _ready():
	# Timer setup
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	#Global.connect("time_modifier_changed",  _update_global_timer_speed)

	timer.timeout.connect(Callable(self, "_on_timer_timeout"))

	_update_label()

func _on_timer_timeout():
	# Subtract time with multiplier
	remaining_seconds -= int(1 * time_multiplier)
	if remaining_seconds < 0:
		remaining_seconds = 0
		emit_signal("time_run_out")
		timer.stop()

	# Tween smoothly towards the new remaining time
	create_tween().tween_property(
		self, 
		"display_seconds",
		float(remaining_seconds), 
		1.0
		).set_trans(Tween.TRANS_LINEAR)


func _process(delta: float):
	_update_label()

func _update_label():
	var t = _seconds_to_dhms(int(display_seconds))
	text = "%02d days \n%02dh %02dm %02ds" % [
		t.days, t.hours, t.minutes, t.seconds
	]

func _seconds_to_dhms(seconds: int) -> Dictionary:
	var days = seconds / 86400
	var hours = (seconds % 86400) / 3600
	var minutes = (seconds % 3600) / 60
	var secs = seconds % 60
	return {
		"days": days,
		"hours": hours,
		"minutes": minutes,
		"seconds": secs
	}
