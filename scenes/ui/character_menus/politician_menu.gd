extends CharacterMenu

const BRIBE_SORTED_DISPLAYER = preload("uid://bcubw5t3fpyvq")

@onready var data_container: VBoxContainer = %DataContainer
@onready var amount_label: Label = %AmountLabel

func _ready() -> void:
	#  TODO: Maybe cache that value
	var base_bribes := CountryData.get_current_base_money_for_all_countries(true)
	var max_bribe : float =  base_bribes.values()[0]
	for n in base_bribes.size():
		var displayer := BRIBE_SORTED_DISPLAYER.instantiate()
		data_container.add_child(displayer)
		displayer.init_menu(
			base_bribes.values()[n] / max_bribe,
			base_bribes.values()[n],
			base_bribes.keys()[n],
		)
