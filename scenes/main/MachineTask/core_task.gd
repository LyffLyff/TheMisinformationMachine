extends PanelContainer

const UPGRADE_TASK = preload("uid://c835belg2ate2")
const CHARACTER_TASK = preload("uid://dtjeyk0ieed3c")

@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar
@onready var timer: Timer = $Timer

signal task_finished

var task_price : int = 1 # update with specific changes to a class/value/money
var task_time : float

func _init_task(title : String, time : float, is_upgrade_task : bool = false) -> void:
	# Style
	self.add_theme_stylebox_override(
		"panel",
		UPGRADE_TASK if is_upgrade_task else CHARACTER_TASK
	)
	
	task_label.text = title
	
	# every percent change it updates the progress bar
	Global.connect("time_modifier_changed", self._update_task_speed)
	task_time = time
	timer.wait_time = time_per_percent(task_time / Global.time_modifier)
	print("TASK WAIT: ", time_per_percent(task_time / Global.time_modifier))
	timer.connect("timeout", _update_progess)
	timer.start()
	
# Returns the time (in seconds) for 1% progress
func time_per_percent(total_time: float) -> float:
	return total_time / 100.0

func _update_progess() -> void:
	# called for every percent change
	var new_value : int = task_progress_bar.value + 1
	if new_value == 100:
		emit_signal("task_finished")
		_close_core()
	task_progress_bar.set_value_no_signal(new_value)

func _close_core():
	# When the Task finishes
	self.queue_free()


func _update_task_speed() -> void:
	timer.wait_time = time_per_percent(task_time / Global.time_modifier)
