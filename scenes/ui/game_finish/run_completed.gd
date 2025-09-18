extends GameEnd

const MAIN_MENU = preload("uid://bvyvobfrdrd7i")

func _ready() -> void:
	Dialogic.start("run_completed")
	Dialogic.connect("timeline_ended", self.on_timeline_finished)


func on_timeline_finished() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
