extends BaseGame
class_name PausingHandler

const PAUSE_MENU = preload("res://scenes/ui/pause_menu.tscn")

@onready var ui: Control = $"UI/UIRoot"

signal pause

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause")
		get_tree().paused = !get_tree().paused
