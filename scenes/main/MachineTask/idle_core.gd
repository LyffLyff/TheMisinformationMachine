extends PanelContainer
# Idle Core just does stuff for visuals in the Machine Menu
# With Upgrades this core may do Idle Tasks in the Future

@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
@onready var timer: Timer = $Timer

signal money_mined

func _ready() -> void:
	if !Global.IDLE_CORES_ACTIVATED:
		Global.connect("unlock_idle_core_miner", self.start_mining)
		_idle_core()
	else:
		pass

func _idle_core() -> void:
	while !Global.IDLE_CORES_ACTIVATED:
		var tw := create_tween()
		tw.tween_property(
			progress_bar,
			"value",
			100,
			randf_range(0.5, 3.5)
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		
		await tw.finished
		progress_bar.value = 0.0


func start_mining() -> void:
	timer.start()
	while true:
		await timer.timeout
		emit_signal("money_mined", randf_range(0.1, 100.0))


func delete_idle_core():
	self.queue_free()
