extends PanelContainer

const CARD = preload("res://scenes/ui/card.tscn")

@onready var card_container: HBoxContainer = %CardContainer

signal card_selected

const CARD_CLASSES := {
	"JOKER" : [preload("res://assets/portraits/scifi/SFCP 1-07.jpg")],
	"SCAMMER" : [preload("res://assets/portraits/scifi/SFCP 1-20.jpg")],
	"CONSPIRACY_THEORIST" : [preload("res://assets/portraits/scifi/SFCP 1-110.png")],
	"INSIDER"  : [preload("res://assets/portraits/green_female_grey.png")],
	"POLITICIAN" : [preload("res://assets/portraits/scifi/SFCP 1-07.jpg")]
}

func _ready() -> void:
	for n in CARD_CLASSES.size():
		var new_card := CARD.instantiate()
		new_card.title = CARD_CLASSES.keys()[n]
		new_card.texture = CARD_CLASSES.values()[n][0]
		card_container.add_child(new_card)
