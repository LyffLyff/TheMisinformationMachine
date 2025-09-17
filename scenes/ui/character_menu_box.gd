extends VBoxContainer

@export var title : String = ""
@export var button_text : String = ""

@onready var add_button: Button = $AddButton
@onready var header_label: Label = $HBoxContainer/HeaderLabel
@onready var character_count_label: Label = $HBoxContainer/CharacterCountLabel
@onready var progress_bar: ProgressBar = $ProgressBar

signal button_pressed

var progress_per_second : float = 0.0  # in % per second
var progression_started : bool = false
var progress : float = 0.0

func _ready() -> void:
	header_label.text = title
	add_button.text = button_text

func _process(delta: float) -> void:
	if progression_started and progress_per_second > 0:
		progress = progress_bar.value + (progress_per_second * delta)
		progress_bar.value = progress
		if progress_bar.value >= 100.0:
			progress_bar.value = 0.0
			progress = 0.0

func update_count(new_count : int) -> void:
	character_count_label.text = str(new_count)

func update_progress_speed(new_progress : float) -> void:
	progress_per_second = new_progress
	if !progression_started:
		progression_started = true

func _on_add_button_pressed() -> void:
	emit_signal("button_pressed")

func _on_world_map_median_character_action_speed_updated(median_action_speed) -> void:
	print(median_action_speed)
	update_progress_speed(1.0 / median_action_speed * 100)
