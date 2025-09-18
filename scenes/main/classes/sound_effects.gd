extends  Control
class_name UISoundManager

var playback:AudioStreamPlaybackPolyphonic

const CLOSE_SOUND = preload("uid://m5y5dt38h6n7")


func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	
	if node.is_in_group("menu_option") or node.is_in_group("increase_button"):
		node.pressed.connect(_menu_button_pressed)
	elif node.is_in_group("close"):
		node.pressed.connect(_play_close_sound)
	elif node is Button or node is TextureButton:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)


func _play_hover() -> void:
	playback.play_stream(preload("res://assets/sounds/ui_effects/SFX_User_Interface_Alert_Notification_Mobile_App_General_04_SND76973.wav"), 0, 0, randf_range(0.9, 1.1))

func _play_close_sound():
	playback.play_stream(CLOSE_SOUND)

func _menu_button_pressed() -> void:
	playback.play_stream(
		preload("res://assets/sounds/ui_effects/SFX_User_Interface_Beep_Button_Happy_Select_Confirm_Deselect_Cancel_SND68348.wav"), 0, 0, randf_range(0.9, 1.1))
