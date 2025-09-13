extends MarginContainer

@onready var country_title: Label = %CountryTitle

func _on_world_map_country_entered(title : String) -> void:
	country_title.text = "Name: " + title


func _on_world_map_country_exited() -> void:
	country_title.text = "Name: /"
