extends VBoxContainer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var next_unlock_label: Label = $NextUnlockLabel

const UNLOCKS := [
	"10%",
	"25%",
	"40%",
	"/"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CountryData.connect("progression_updated", self.update_progress)
	CountryData.connect("character_unlocked", self.set_next_unlock)


func update_progress(val : float) -> void:
	print("PROGRESS" + str(val))
	progress_bar.value = val

func set_next_unlock(idx : int):
	next_unlock_label.text = UNLOCKS[idx]

func init_progress():
	progress_bar.value = CountryData.get_progression()
