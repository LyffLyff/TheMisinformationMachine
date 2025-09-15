extends PanelContainer

@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar
@onready var timer: Timer = $Timer

signal task_finished

var task_price : int = 1 # update with specific changes to a class/value/money

func _init_task(title : String, task_time : int) -> void:
	task_label.text = title
	
	# every percent change it updates the progress bar
	timer.wait_time = time_per_percent(task_time)
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
