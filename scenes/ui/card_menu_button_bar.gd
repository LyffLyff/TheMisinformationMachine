extends VBoxContainer

signal character_menu_button_selected

@onready var buttons : Array[TextureButton] = [
	%Joker, 
	%Scammer,
	%Conspirator,
	%Politician,
]

func _ready() -> void:
	for n in buttons:
		n.tooltip_text = n.name
		n.connect(
			"pressed",
			emit_signal.bind("character_menu_button_selected", n.get_parent().get_index())
		)
