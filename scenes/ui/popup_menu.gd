extends PanelContainer

const CARD = preload("res://scenes/ui/card.tscn")

@onready var card_container: HBoxContainer = %CardContainer
@onready var popup_top_bar: VBoxContainer = $ContentContainer/PanelContainer/VBoxContainer/PopupTopBar


signal card_selected

const CARD_CLASSES := {
	"JOKER" : [preload("uid://cbki7y1qq0vbk")],
	"SCAMMER" : [preload("uid://bg7oec372ttlk")],
	"CONSPIRATOR" : [preload("uid://bg7oec372ttlk")],
	"INSIDER"  : [preload("res://assets/portraits/green_female_grey.png")],
	"POLITICIAN" : [preload("res://assets/portraits/scifi/SFCP 1-07.jpg")]
}

func _ready() -> void:
	popup_top_bar.bar_title.text = Global.CURRENT_COUNTRY
	for n in CARD_CLASSES.size():
		var new_card := CARD.instantiate()
		new_card.title = CARD_CLASSES.keys()[n]
		new_card.texture = CARD_CLASSES.values()[n][0]
		card_container.add_child(new_card)


func _on_popup_top_bar_close_menu() -> void:
	self.queue_free()
