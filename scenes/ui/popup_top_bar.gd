extends BoxContainer

@export var title : String = ""
@onready var bar_title: Label = %BarTitle

signal close_menu

func _ready() -> void:
	bar_title.text = title

func _on_return_pressed() -> void:
	emit_signal("close_menu")
