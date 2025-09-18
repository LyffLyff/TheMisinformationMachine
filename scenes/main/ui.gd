extends CanvasLayer

const RUN_FAILED = preload("uid://di3cfsc8a1ps3")

const UPGRADE_MENU = preload("uid://dy8snr10xmwmw")
const CHARACTER_MENUS : Array[PackedScene]  = [
	preload("uid://buyu42ltal2u7"),		# JOKER
	preload("uid://b7txeh62p4i8q"),		# SCAMMER
	preload("uid://bacgvwdsmiltv"),		# Politician
	preload("uid://b3boouhv04ia6"),		# CONSPIRATOR
]

@onready var pause_menu: PanelContainer = %PauseMenu
@onready var card_menu_button_bar: VBoxContainer = %CardMenuButtonBar
@onready var remaining_time_label : Label = $UIRoot/PanelContainer/VBoxContainer/Top/VBoxContainer2/RemainingTime
@onready var popup_container: Control = %PopupContainer


func _ready() -> void:
	card_menu_button_bar.connect("character_menu_button_selected", self.show_character_menu)
	remaining_time_label.connect("time_run_out", self.run_failed)

func _on_world_map_pause() -> void:
	pause_menu.visible = !pause_menu.visible


func _on_open_upgrades_button_pressed() -> void:
	var menu := UPGRADE_MENU.instantiate()
	self.add_child(menu)


func run_failed() -> void:
	get_tree().change_scene_to_packed(RUN_FAILED)


func show_character_menu(idx : int) -> void:
	var menu
	if idx == -1:
		menu = UPGRADE_MENU.instantiate()
	else:
		menu = CHARACTER_MENUS[idx].instantiate()
		menu.is_global = true
	popup_container.add_child(menu)
