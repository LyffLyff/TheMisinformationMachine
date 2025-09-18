extends VBoxContainer

@onready var money_jingle_player: AudioStreamPlayer = $MoneyJinglePlayer
@onready var static_money_label: Label = $HBoxContainer/StaticMoneyLabel
@onready var diff_money_per_second_button: Button = $DiffMoneyPerSecondButton

var static_money : float = 0.0
var diff_money_per_second : float = 0.0

func _ready() -> void:
	update_values(0.0, 0.0, 0.0)
	diff_money_per_second_button.connect("pressed", open_incoming_outgoing_money_menu)


func update_values(s_money, incoming, outgoing):
	diff_money_per_second = incoming - outgoing
	Global.tween_label_counter(static_money_label, s_money, 1.0, true)


func open_incoming_outgoing_money_menu() -> void:
	print("INCOMING/outgoing MONEY MENU")
