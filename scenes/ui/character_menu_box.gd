extends VBoxContainer

@export var title : String = ""
@export var button_text : String = ""
@export var character_texture : Texture2D

@onready var add_button: Button = %AddButton
@onready var header_label: Label = $HBoxContainer2/VBoxContainer/HBoxContainer/HeaderLabel
@onready var character_count_label: Label = $HBoxContainer2/VBoxContainer/HBoxContainer/CharacterCountLabel
@onready var progress_bar: ProgressBar = $HBoxContainer2/VBoxContainer/ProgressBar
@onready var character_icon: TextureRect = $HBoxContainer2/CharacterIcon

signal button_pressed

# JOKER, SCAMMER & CONSPIRATOR
var progress_per_second : float = 0.0  # in % per second
var progression_started : bool = false
var progress : float = 0.0
var politician_mode : bool = false

func _ready() -> void:
	header_label.text = title
	add_button.text = button_text
	character_icon.texture = character_texture

func _process(delta: float) -> void:
	if progression_started and progress_per_second > 0:
		progress = progress_bar.value + (progress_per_second * delta)
		progress_bar.value = progress
		if progress_bar.value >= 100.0:
			progress_bar.value = 0.0
			progress = 0.0

func update_count(new_count : int) -> void:
	character_count_label.text = str(new_count)
	

func init_character_box(character_name : String) -> void:
	update_count(CountryData.get_character_amount_per_country(Global.CURRENT_COUNTRY, character_name))
	update_progress_speed(CountryData.get_median_character_action_speed(Global.CURRENT_COUNTRY, character_name))
	if politician_mode:
		# update bribe cost
		set_to_politican_mode()

func update_progress_speed(new_progress : float) -> void:
	progress_per_second = new_progress
	if !progression_started:
		progression_started = true

func set_to_politican_mode():
	politician_mode = true
	print(CountryData.get_next_bribe_cost_per_day(), "RBIRBIRBIRB")
	add_button.text = "Bribe: %0.2f$/day" % CountryData.get_next_bribe_cost_per_day()

func _on_add_button_pressed() -> void:
	emit_signal("button_pressed")
