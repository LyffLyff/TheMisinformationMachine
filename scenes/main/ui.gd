extends CanvasLayer

@onready var pause_menu: PanelContainer = %PauseMenu

func _on_world_map_pause() -> void:
	print(!pause_menu.visible)
	pause_menu.visible = !pause_menu.visible
