extends MarginContainer

@onready var country_title: Label = %CountryTitle
@onready var country_details: PanelContainer = %CountryDetails


func _ready() -> void:
	country_details.hide()


func _on_world_map_country_entered(title : String) -> void:
	country_title.text = "Name: " + title.capitalize()


func _on_world_map_country_exited() -> void:
	country_title.text = "/"


func show_country_menu(country_title : String, details) -> void:
	Global.CURRENT_COUNTRY = country_title
	country_details.show_details(country_title, details)
