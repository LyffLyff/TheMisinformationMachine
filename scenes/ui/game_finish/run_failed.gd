extends PanelContainer

func _ready() -> void:
	Engine.time_scale = 1.0
	await Transition.fade_in()
	Global.game_data["failed_runs"] += 1
	var timeline : String = ""
	match Global.REASON_OF_DEATH:
		"OVERCLOCK":
			timeline = "death_by_overclock"
		"TIMEOUT":
			timeline = "run_failed"
		"DEBT":
			timeline = "money_run_out"
	Dialogic.start(timeline)
	Dialogic.connect("timeline_ended", self.on_timeline_finished)


func on_timeline_finished() -> void:
	await Transition.fade_out()
	get_tree().change_scene_to_packed(load("uid://bvyvobfrdrd7i"))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip_dialogue"):
		Dialogic.end_timeline(true)
		on_timeline_finished()
