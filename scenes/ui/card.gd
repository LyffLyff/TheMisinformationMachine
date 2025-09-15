extends Control

@onready var card_texture: TextureRect = %Texture
@onready var label: Label = %CardTitle

@export var title : String = ""
@export var texture : Texture2D

func _ready() -> void:
	label.text = title
	card_texture.texture = texture
