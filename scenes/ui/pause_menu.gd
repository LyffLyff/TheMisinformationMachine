extends PanelContainer

const MAIN_MENU : PackedScene = preload("uid://bvyvobfrdrd7i")

@onready var abandon_run_button: Button = %AbandonRun
@onready var transition_rect: ColorRect = $TransitionRect

var is_hovered : bool = false


func _on_abandon_run_mouse_entered() -> void:
	if !is_hovered:
			is_hovered = true
			abandon_run_button.text = "-%s-" % abandon_run_button.text

func _on_abandon_run_mouse_exited() -> void:
	is_hovered = false
	abandon_run_button.text = abandon_run_button.text.trim_prefix("-").trim_suffix("-")


func _on_abandon_run_pressed() -> void:
	await create_tween().tween_property(
		transition_rect.material,
		"shader_parameter/animation_progress",
		1.0,
		0.5
	).from(0.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).finished
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU)
