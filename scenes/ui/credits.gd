extends PanelContainer

func _ready() -> void:
	await Transition.fade_in()


func _on_popup_top_bar_close_menu() -> void:
	await Transition.fade_out()
	get_tree().change_scene_to_packed(load("res://scenes/ui/main_menu.tscn"))
