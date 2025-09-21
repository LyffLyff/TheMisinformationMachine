extends VBoxContainer

@onready var label: Label = %Label
@onready var modifier: HSlider = %Modifier

func _ready() -> void:
	_on_reset_pressed()

func _on_modifier_value_changed(value: float) -> void:
	label.text = "  " +str(value)
	Engine.time_scale = value

func _on_reset_pressed() -> void:
	modifier.value = 1.0
