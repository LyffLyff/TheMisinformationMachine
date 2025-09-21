extends PanelContainer

@onready var abandon_run_button: Button = %AbandonRun

var is_hovered : bool = false

func _on_abandon_run_mouse_entered() -> void:
	if !is_hovered:
			is_hovered = true
			abandon_run_button.text = "-%s-" % abandon_run_button.text

func _on_abandon_run_mouse_exited() -> void:
	is_hovered = false
	abandon_run_button.text = abandon_run_button.text.trim_prefix("-").trim_suffix("-")


func _on_abandon_run_pressed() -> void:
	await Transition.fade_out()
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_packed", load("res://scenes/ui/main_menu.tscn"))
