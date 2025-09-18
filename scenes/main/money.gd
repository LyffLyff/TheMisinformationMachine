extends HBoxContainer

@onready var money_jingle_player: AudioStreamPlayer = $"../MoneyJinglePlayer"

@onready var incoming_money_per_second_button: Button = $"../IncomingMoneyPerSecondButton"
@onready var outgoing_money_per_second_button: Button = $"../OutgoingMoneyPerSecondButton"
@onready var static_money_label: Label = $StaticMoneyLabel

var static_money : float = 0.0


func _ready() -> void:
	static_money_label.text = str(static_money) + "$"


func set_stattic_money_counter(new_value : float) -> void:
	static_money_label.text = str(static_money) + "$"
