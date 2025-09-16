extends MarginContainer

const GENERAL_COUNTRY_INFO = preload("res://scenes/ui/general_country_info.tscn")
const TIME_MODIFIER = preload("uid://bcykwg0e386nb")

@onready var country_title_label: Label = %CountryTitle
@onready var country_details: PanelContainer = %CountryDetails
@onready var left_column_menu_container: VBoxContainer = %LeftColumnMenuContainer
@onready var bottom_middle_container: Control = %BottomMiddleContainer

var general_info_menu : Control

func _ready() -> void:
	# UI Skill SIGNAL Connects
	Global.connect("time_modifier_unlocked", self.show_time_modifier)
	
	country_details.hide()

func _on_world_map_country_entered(title : String) -> void:
	country_title_label.text = "Country: " + title.to_upper()

func _on_world_map_country_exited(country_polygon) -> void:
	if !country_polygon:
		# only empty label when the mouse actually isn't within any country
		country_title_label.text = "Country: /"

func show_country_menu(country_title : String, details) -> void:
	Global.CURRENT_COUNTRY = country_title
	country_details.show_details(country_title, details)

func load_general_country_info(country_title : String) -> void:
	if !general_info_menu:
		general_info_menu = GENERAL_COUNTRY_INFO.instantiate()
		left_column_menu_container.add_child(general_info_menu)
		#general_info_menu.connect("tree_exited", self)
	general_info_menu.init_country_info(country_title, CountryData.get_country_data_dict(country_title))


func show_time_modifier() -> void:
	var modifier := TIME_MODIFIER.instantiate()
	bottom_middle_container.add_child(modifier)
