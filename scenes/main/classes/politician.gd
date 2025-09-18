extends Character
class_name Politician

var bribe_money_per_day : float = 0.0

# 0 -> 1
var influence : float = 0.0

func _init(
	bribe : float,
	) -> void:
		bribe_money_per_day  = bribe
		influence = randf_range(0.0, 1.0)
	
