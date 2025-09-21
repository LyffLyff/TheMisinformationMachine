extends VBoxContainer

@onready var money_jingle_player: AudioStreamPlayer = $MoneyJinglePlayer
@onready var money_label: Label = %MoneyLabel
@onready var diff_money_per_second_label : Label = %DiffMoneyPerSecondLabel

signal death_by_debt

var diff_money_per_second : float = 0.0

func _ready() -> void:
	update_values(0.0, 0.0, 0.0)


func update_values(s_money : float, incoming, outgoing):
	diff_money_per_second = incoming - outgoing
	money_label.text = "%0.2f$" % s_money
	diff_money_per_second_label.text = "%0.2f/per second" % (incoming - outgoing)
	if diff_money_per_second > 0.0:
		diff_money_per_second_label.modulate = Color.SEA_GREEN
	elif diff_money_per_second == 0.0:
		diff_money_per_second_label.modulate = Color.WHITE
	else:
		diff_money_per_second_label.modulate = Color.RED
