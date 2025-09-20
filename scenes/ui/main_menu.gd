extends UISoundManager

const INTRO = preload("uid://f3ae7mhybktn")
const CREDITS = preload("uid://qk3loi4ipjq4")
const SETTINGS = preload("uid://crhspbnnhna6t")

@onready var button_container: VBoxContainer = %ButtonContainer
@onready var start_game: Button = %StartGame
@onready var settings: Button = %Settings
@onready var quit: Button = %Quit
@onready var credits: Button = %Credits


func _ready() -> void:
	Transition.fade_in()
	for n in button_container.get_children():
		n.connect("pressed", on_menu_option_pressed.bind(n.get_index()))
		n.connect("mouse_entered", on_menu_mouse_entered.bind(n.get_index()))
		n.connect("mouse_exited", on_menu_mouse_exited.bind(n.get_index()))


func on_menu_option_pressed(idx : int) -> void:
	match idx:
		0:
			await Transition.fade_out()
			get_tree().change_scene_to_packed(INTRO)
		1:
			await Transition.fade_out()
			get_tree().change_scene_to_packed(SETTINGS)
		2:
			await Transition.fade_out()
			get_tree().change_scene_to_packed(CREDITS)
		3:
			await Transition.fade_out()
			get_tree().quit()
		_:
			printerr("INVALID MENU OPTION IDX")


func on_menu_mouse_entered(idx : int):
	button_container.get_child(idx).text = "-" + button_container.get_child(idx).text + "-"

func on_menu_mouse_exited(idx: int):
	button_container.get_child(idx).text = button_container.get_child(idx).text.trim_suffix("-").trim_prefix("-")
