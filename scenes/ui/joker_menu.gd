extends CharacterMenu
# Descpription
# Current Actions of this Character
# Limits -> pass
# Expected Growth

func _ready() -> void:
	return
	#  Showing country data of Character
	header.bar_title.text = Global.CURRENT_COUNTRY
	#var country_character_data : Array = CountryData.character_data_per_country[Global.CURRENT_COUNTRY]["JOKER"]
