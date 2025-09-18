extends Character
class_name Scammer

var effectiveness : float = 0.0
var outreach : float = 0.0
var smartness : float = 0.0

func _init() -> void:
	effectiveness = randf_range(0.5, 1.0)
	outreach =  randf_range(1000.0, 1000000.0)
	smartness = randf_range(0.0, 1.0)
	calculate_societal_dmg()


func calculate_societal_dmg() -> void:
	median_societal_damage_per_second = outreach * effectiveness * smartness
