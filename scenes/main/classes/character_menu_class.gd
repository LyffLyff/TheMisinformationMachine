extends Control
class_name CharacterMenu

@onready var header: VBoxContainer = %HeaderBar


func _on_popup_top_bar_close_menu() -> void:
	self.queue_free()
