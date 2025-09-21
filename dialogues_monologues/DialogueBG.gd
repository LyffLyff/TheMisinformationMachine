extends DialogicLayoutLayer


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _on_dialogic_signal(arg : String):
	if arg == "start_fade":
		create_tween().tween_property(
			get_child(0),
			"modulate:a",
			0.0,
			2.0
		).from(1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
