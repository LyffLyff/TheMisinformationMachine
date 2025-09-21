extends HBoxContainer

@onready var money_jingle_player: AudioStreamPlayer = $"../MoneyJinglePlayer"

@onready var incoming_money_per_second_button: Button = $"../IncomingMoneyPerSecondButton"
@onready var outgoing_money_per_second_button: Button = $"../OutgoingMoneyPerSecondButton"
@onready var money_label: Label = %MoneyLabel

var static_money : float = 0.0


func _ready() -> void:
	money_label.text = str(money_label) + "$"
