extends MarginContainer

const GENERAL_COUNTRY_INFO = preload("res://scenes/ui/general_country_info.tscn")

@onready var country_title_label: Label = %CountryTitle
@onready var country_details: PanelContainer = %CountryDetails
@onready var left_column_menu_container: VBoxContainer = %LeftColumnMenuContainer

func _ready() -> void:
	country_details.hide()


func _on_world_map_country_entered(title : String) -> void:
	country_title_label.text = "Name: " + title.to_upper()


func _on_world_map_country_exited() -> void:
	country_title_label.text = "/"


func show_country_menu(country_title : String, details) -> void:
	Global.CURRENT_COUNTRY = country_title
	country_details.show_details(country_title, details)

func load_general_country_info(country_title : String) -> void:
	var general_info := GENERAL_COUNTRY_INFO.instantiate()
	left_column_menu_container.add_child(general_info)
	general_info.init_country_info(country_title, CountryData.get_country_data_dict(country_title))
