extends UISoundManager

const INTRO = preload("uid://f3ae7mhybktn")
const CREDITS = preload("uid://qk3loi4ipjq4")
const SETTINGS = preload("uid://crhspbnnhna6t")

@onready var button_container: VBoxContainer = %ButtonContainer
@onready var start_game: Button = %StartGame
@onready var quit: Button = %Quit
@onready var credits: Button = %Credits
@onready var completed_runs_label: Label = %CompletedRunsLabel
@onready var failed_runs_label: Label = %FailedRunsLabel

func _ready() -> void:
	Engine.time_scale = 1.0
	completed_runs_label.text = "COMPLETED RUNS: " + str(Global.game_data["completed_runs"])
	failed_runs_label.text = "FAILED RUNS: " + str(Global.game_data["failed_runs"])
	Transition.fade_in()
	for n in button_container.get_children():
		n.connect("pressed", on_menu_option_pressed.bind(n.get_index()))
		n.connect("mouse_entered", on_menu_mouse_entered.bind(n.get_index()))
		n.connect("mouse_entered", GlobalSoundPlayer.play_hover)
		n.connect("mouse_exited", on_menu_mouse_exited.bind(n.get_index()))


func on_menu_option_pressed(idx : int) -> void:
	match idx:
		0:
			await Transition.fade_out()
			Global.game_data["playthroughs"] += 1
			reset_sigleton_vars()
			get_tree().change_scene_to_packed(INTRO)
		1:
			await Transition.fade_out()
			get_tree().change_scene_to_packed(CREDITS)
		2:
			await Transition.fade_out()
			get_tree().quit()
		_:
			printerr("INVALID MENU OPTION IDX")


func reset_sigleton_vars() -> void:
	# RESET SINGLETON DATA
	Global.SKILL_POINTS = 0
	Global.LOST_SPECIMEN = 0.0
	Global.CURRENT_COUNTRY = ""
	Global.POISONING_MULTIPLIER = 1
	Global.CORE_MULTIPLIER = 1.0
	Global.IDLE_CORES_ACTIVATED= false
	Global.AUTO_RESTART_CORE_TASKS= false
	Global.AUTOCLICKER_ACTIVATED = false
	Global.AUTO_CLICKER_SPEED = 1.0
	Global.CHARACTER_MULTIPLIER = 1.0
	Global.time_modifier = 1.0
	Global.UNLOCKED_SKILLS = []
	CountryData.current_skill_lvl = 0
	CountryData.init_extra_details()


func on_menu_mouse_entered(idx : int):
	button_container.get_child(idx).text = "- " + button_container.get_child(idx).text + " -"

func on_menu_mouse_exited(idx: int):
	button_container.get_child(idx).text = button_container.get_child(idx).text.trim_suffix(" -").trim_prefix("- ")
