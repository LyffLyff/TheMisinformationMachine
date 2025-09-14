extends Node2D

func _ready() -> void:
	# check if a dialog is already running
	if Dialogic.current_timeline != null:
		return

	Dialogic.start('test')
	get_viewport().set_input_as_handled()
