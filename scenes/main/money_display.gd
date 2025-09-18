extends VBoxContainer

@onready var money_jingle_player: AudioStreamPlayer = $MoneyJinglePlayer
@onready var static_money_label: Label = $HBoxContainer/StaticMoneyLabel
@onready var diff_money_per_second_button: Button = $DiffMoneyPerSecondButton


const COINS_JINGLE_01 = preload("uid://bfe5b2uxv5i5")
const COINS_JINGLE_02 = preload("uid://bmulusx68djmc")
const COINS_JINGLE_03 = preload("uid://kctaw1v0chx8")
const COINS_JINGLE_04 = preload("uid://cafsw61bj7bmm")
var COIN_JINGLES := [COINS_JINGLE_01,COINS_JINGLE_02,COINS_JINGLE_03,COINS_JINGLE_04]

var static_money : float = 0.0
var diff_money_per_second : float = 0.0

func _ready() -> void:
	update_values(0.0, 0.0, 0.0)
	diff_money_per_second_button.connect("pressed", open_incoming_outgoing_money_menu)


func update_values(s_money, incoming, outgoing):
	diff_money_per_second = incoming - outgoing
	Global.tween_label_counter(static_money_label, s_money, 1.0, true)
	if diff_money_per_second > 0.0:
		play_random_jingle()


func open_incoming_outgoing_money_menu() -> void:
	print("INCOMING/outgoing MONEY MENU")


func play_random_jingle():
	var random_index = randi() % COIN_JINGLES.size()
	money_jingle_player.stream = COIN_JINGLES[random_index]
	money_jingle_player.play()
