extends PanelContainer
# Idle Core just does stuff for visuals in the Machine Menu
# With Upgrades this core may do Idle Tasks in the Future

@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
@onready var timer: Timer = $Timer

func _ready() -> void:
	_idle_core()

func _idle_core() -> void:
	while true:
		var tw := create_tween()
		tw.tween_property(
			progress_bar,
			"value",
			100,
			randf_range(0.5, 3.5)
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		
		await tw.finished
		progress_bar.value = 0.0

func delete_idle_core():
	self.queue_free()
