extends GameEnd

const MAIN_MENU = preload("uid://bvyvobfrdrd7i")

func _ready() -> void:
	Global.game_data["completed_runs"] += 1
	Dialogic.start("run_completed")
	Dialogic.connect("timeline_ended", self.on_timeline_finished)


func on_timeline_finished() -> void:
	await Transition.fade_out()
	get_tree().change_scene_to_packed(MAIN_MENU)
