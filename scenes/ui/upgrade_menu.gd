extends PanelContainer

const UPGRADE_MENUS : Array[PackedScene] = [
	preload("uid://bv453ybl43dp3"),			# MACHINE/SELF
	
]

@onready var close_menu_button: TextureButton = $MarginContainer/VBoxContainer/UpgradeTypeSelector/CloseMenuButton
@onready var self_button: Button = %SelfButton
@onready var joker_button: Button = %JokerButton
@onready var scammer_button: Button = %ScammerButton
@onready var politician_button: Button = %PoliticianButton
@onready var conspiracy_theorist_button: Button = %ConspiracyTheoristButton
@onready var insider_button: Button = %InsiderButton
@onready var upgrade_menu_buttons : Array[Control] = [
	self_button,
	joker_button,
	scammer_button,
	politician_button,
	conspiracy_theorist_button,
	insider_button,
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
	upgrade_container.add_child(UPGRADE_MENUS[menu_idx].instantiate())

func _close_update_menu():
	self.queue_free()
