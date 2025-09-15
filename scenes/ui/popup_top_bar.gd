extends BoxContainer

signal close_menu

func _on_return_pressed() -> void:
	emit_signal("close_menu")
