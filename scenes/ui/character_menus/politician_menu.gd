extends CharacterMenu

@onready var data_container: VBoxContainer = %DataContainer

func _ready() -> void:
	#  TODO: Maybe cache that value
	var base_bribes := CountryData.get_current_base_money_for_all_countries(true)
	for n in base_bribes.size():
		var label := Label.new()
		label.text = base_bribes.keys()[n] + ": %0.2f/day" % base_bribes.values()[n]
		data_container.add_child(label)
