extends CanvasLayer

const RUN_FAILED = preload("uid://di3cfsc8a1ps3")


const GENERAL_COUNTRY_INFO = preload("res://scenes/ui/general_country_info.tscn")
const UPGRADE_MENU = preload("uid://dy8snr10xmwmw")
const CHARACTER_MENUS : Array[PackedScene]  = [
	preload("uid://buyu42ltal2u7"),		# JOKER
	preload("uid://b7txeh62p4i8q"),		# SCAMMER
	preload("uid://b3boouhv04ia6"),		# CONSPIRATOR
	preload("uid://bacgvwdsmiltv"),		# Politician
]

@onready var pause_menu: PanelContainer = %PauseMenu
@onready var card_menu_button_bar: VBoxContainer = %CardMenuButtonBar
@onready var remaining_time_label : Label = $UIRoot/PanelContainer/VBoxContainer/Top/VBoxContainer2/RemainingTime
@onready var popup_container: Control = %PopupContainer
@onready var skill_points_counter_label: Button = %SkillPointsCounterLabel


func _ready() -> void:
	card_menu_button_bar.connect("character_menu_button_selected", self.show_character_menu)
	remaining_time_label.connect("time_run_out", self.run_failed.bind("TIMEOUT"))
	skill_points_counter_label.connect("pressed", _on_open_upgrades_button_pressed)
	Global.connect("skill_points_changed", self.update_skill_point_display)
	Global.connect("death_by_overclock", self.run_failed.bind("OVERCLOCK"))

func _on_world_map_pause() -> void:
	pause_menu.visible = !pause_menu.visible


func _on_open_upgrades_button_pressed() -> void:
	var menu := UPGRADE_MENU.instantiate()
	popup_container.add_child(menu)


func run_failed(death_type : String) -> void:
	Global.REASON_OF_DEATH = death_type
	await Transition.fade_out()
	get_tree().change_scene_to_packed(RUN_FAILED)


func show_character_menu(idx : int) -> void:
	var menu
	if idx == -1:
		menu = UPGRADE_MENU.instantiate()
	else:
		menu = CHARACTER_MENUS[idx].instantiate()
		menu.is_global = true
	popup_container.add_child(menu)


func update_skill_point_display(new_amount : int) -> void:
	skill_points_counter_label.text =  str(new_amount)


func load_general_country_info(country_title : String) -> void:
	var general_info_menu = GENERAL_COUNTRY_INFO.instantiate()
	popup_container.add_child(general_info_menu)
	general_info_menu.init_country_info(country_title, CountryData.get_country_data_dict(country_title))
