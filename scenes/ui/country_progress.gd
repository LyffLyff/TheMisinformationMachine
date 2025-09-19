extends VBoxContainer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var next_unlock_label: Label = $NextUnlockLabel
@onready var total_label: Label = $TotalLabel

const UNLOCKS := [
	"10%",
	"25%",
	"40%",
	"/"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CountryData.connect("progression_updated", self.update_progress)


func _on_visibility_changed() -> void:
	if Global.CURRENT_COUNTRY != "":
		set_next_unlock(CountryData.get_progression_idx())


func update_progress(val : float) -> void:
	print("PROGRESS" + str(val))
	progress_bar.value = val

func set_next_unlock(idx : int):
	next_unlock_label.text = "Next Milestone: %s" % UNLOCKS[idx]

func init_progress():
	progress_bar.value = CountryData.get_total_progression()


func _process(_delta: float) -> void:
	if Global.CURRENT_COUNTRY != "":
		total_label.text = "Total: %d" % CountryData.get_country_total_lost_specimen()
