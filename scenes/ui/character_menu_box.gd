extends VBoxContainer

@export var title : String = ""
@export var button_text : String = ""

@onready var add_button: Button = $AddButton
@onready var header_label: Label = $HBoxContainer/HeaderLabel
@onready var character_count_label: Label = $HBoxContainer/CharacterCountLabel
@onready var progress_bar: ProgressBar = $ProgressBar

signal button_pressed

var progress_per_second : float = 0	# in % of 100
var progression_started : bool = false

func _ready() -> void:
	header_label.text = title
	add_button.text = button_text

func start_progression() -> void:
	while true:
		var tw := create_tween()
		tw.tween_property(
			progress_bar,
			"value",
			100,
			progress_per_second / 100
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		
		await tw.finished
		progress_bar.value = 0.0 


func update_count(new_count : int) -> void:
	character_count_label.text = str(new_count)


func update_progress_speed(new_progress : float) -> void:
	progress_per_second = new_progress
	if !progression_started:
		progression_started = true
		start_progression()


func _on_add_button_pressed() -> void:
	emit_signal("button_pressed")
