extends PanelContainer

func _ready() -> void:
	await Transition.fade_in()


func _on_popup_top_bar_close_menu() -> void:
	GlobalSoundPlayer.play_selected_sound()
	await Transition.fade_out()
	get_tree().change_scene_to_packed(load("res://scenes/ui/main_menu.tscn"))


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
