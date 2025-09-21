extends PanelContainer

@onready var next_unlock_label: Label = %NextUnlockLabel
@onready var remaining_specimen: Label = %RemainingSpecimen

func _process(delta: float) -> void:
	next_unlock_label.text = str(CountryData.SKILL_POINT_UNLOCKS[CountryData.current_skill_lvl])
