extends Control

const UPGRADE_MENUS : Array[PackedScene] = [
	preload("uid://bv453ybl43dp3"),			# MACHINE/SELF
	preload("uid://cc7nig7l6cc6l"),			# SKILL POINTS
	preload("uid://dhdmdnaydc7lm")
]

@onready var close_menu_button: TextureButton = %CloseMenuButton
@onready var self_button: Button = %SelfButton
@onready var upgrade_menu_buttons : Array[Control] = [
	self_button,
	%SkillPathButton,
	%CountryProgression
]

@onready var upgrade_container: PanelContainer = %UpgradeContainer

func _ready() -> void:
	close_menu_button.connect("pressed", self._close_update_menu)
	for n in upgrade_menu_buttons.size():
		upgrade_menu_buttons[n].connect("pressed", _load_upgrade_menu.bind(n))
	_load_upgrade_menu(0)

func _load_upgrade_menu(menu_idx : int) -> void:
	for n in upgrade_container.get_children():
		n.queue_free()
	var menu := UPGRADE_MENUS[menu_idx].instantiate()
	Global.connect("start_skill_task", _close_update_menu)
	upgrade_container.add_child(UPGRADE_MENUS[menu_idx].instantiate())

func _close_update_menu(_skill = null):
	self.queue_free()
