extends CharacterMenu
# Descpription
# Current Actions of this Character
# Limits -> pass
# Expected Growth

@onready var country_label: Label = %CountryLabel

func _ready() -> void:
	if !is_global:
		#  Showing country data of Character
		country_label.text = Global.CURRENT_COUNTRY
		header.bar_title.text = Global.CURRENT_COUNTRY
		var country_character_data : Array = Global.get_current_country_character_data()["JOKER"]
		for idx in country_character_data.size():
			country_character_data[idx]._print_joker()
	else:
		# Show Global Stats
		country_label.text = "GLOBAL"
