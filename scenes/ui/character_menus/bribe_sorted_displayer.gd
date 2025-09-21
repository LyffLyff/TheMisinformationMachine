extends HBoxContainer

@onready var country_label: Label = %CountryLabel
@onready var bribe_ratio_bar: ProgressBar = %BribeRatioBar
@onready var bribe_amount_label: Label = %BribeAmountLabel

func init_menu(
	ratio : float,
	amount  : float,
	country_name : String
	) -> void:
	country_label.text = Global.get_normalized_country_name(country_name) + ":"
	bribe_ratio_bar.value = ratio * 100.0
	bribe_amount_label.text = "  " + str(amount).pad_decimals(2)
