extends PanelContainer

const WORLD_MAP = preload("uid://brnpe61hgy7ud")

@onready var trigger_warning: Label = %TriggerWarning


func _ready() -> void:
	Transition.fade_in()
	# TRIGGER WARNING
	await create_tween().tween_property(
		trigger_warning,
		"modulate:a",
		1.0,
		0.3
		).from(0.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).finished
	await get_tree().create_timer(15).timeout
	await create_tween().tween_property(
		trigger_warning,
		"modulate:a",
		0.0,
		0.3
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).finished

	# ACTUAL START
	Dialogic.connect("timeline_ended", load_run)
	Dialogic.start("intro")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		load_run()


func load_run() -> void:
	await Transition.fade_out()
	Dialogic.end_timeline(true)
	get_tree().change_scene_to_packed(WORLD_MAP)
