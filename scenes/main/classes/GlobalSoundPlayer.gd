extends  Node

var playback:AudioStreamPlaybackPolyphonic

const UI_SKILL_UNLOCK = preload("uid://bn66jrjhw8sqn")
const SFX_GAMES_ARCADE = preload("uid://cgb6xhdmpnmqa")
const COUNTRY_COMPLETE_JINGLE = preload("uid://bjrkmaqiu4xf1")
const NEXT_CHARACTER_CLASS_UNLOCK = preload("uid://d4lfbq8n3q25i")
const SELECT = preload("uid://bg6162d7lkkmj")
const HOVER = preload("uid://cmui2ge67jad2")
const DENIED = preload("uid://b3ki8ntx13xwo")



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


func play_skill_jingle() -> void:
	playback.play_stream(UI_SKILL_UNLOCK, 0, 0, randf_range(0.9, 1.1))

func play_generic_task_jingle():
	playback.play_stream(SFX_GAMES_ARCADE, 0, 0, randf_range(0.9, 1.1))

func play_country_unlock_jingle():
	playback.play_stream(COUNTRY_COMPLETE_JINGLE, 0, 0, randf_range(0.9, 1.1))

func play_country_progression_jingle():
	playback.play_stream(NEXT_CHARACTER_CLASS_UNLOCK, 0, 0, randf_range(0.9, 1.1))

func play_selected_sound():
	playback.play_stream(SELECT, 0, 0, randf_range(0.7, 1.3))

func play_hover() -> void:
	playback.play_stream(HOVER, 0, 0, randf_range(0.9, 1.1))

func play_insufficient_skill_points() -> void:
	playback.play_stream(DENIED, 0, 0, randf_range(0.5, 1.4))

func bribed_politician() -> void:
	playback.play_stream(UI_SKILL_UNLOCK, 0, 0, randf_range(0.5, 1.4))
