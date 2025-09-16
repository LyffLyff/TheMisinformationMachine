extends CanvasLayer

const UPGRADE_MENU = preload("uid://dy8snr10xmwmw")

@onready var pause_menu: PanelContainer = %PauseMenu

func _on_world_map_pause() -> void:
	print(!pause_menu.visible)
	pause_menu.visible = !pause_menu.visible


func _on_open_upgrades_button_pressed() -> void:
	var menu := UPGRADE_MENU.instantiate()
	self.add_child(menu)
