extends PanelContainer

const WORLD_MAP = preload("uid://brnpe61hgy7ud")

func _ready() -> void:
	await Transition.fade_in()
	Dialogic.connect("timeline_ended", load_run)
	Dialogic.start("intro")


func load_run() -> void:
	await Transition.fade_out()
	Dialogic.end_timeline(true)
	get_tree().change_scene_to_packed(WORLD_MAP)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		load_run()
