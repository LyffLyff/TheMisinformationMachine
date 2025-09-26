extends Control
class_name CharacterMenu

@onready var header: VBoxContainer = %HeaderBar

var is_global : bool = false

func _enter_tree() -> void:
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

func _on_popup_top_bar_close_menu() -> void:
	self.get_tree().paused = false
	self.queue_free()
