extends RefCounted
class_name Character
# Base Class for every type of character

var action_duration : float  = 1.0

var converted_per_action : float = 1.0

var money_per_action : float = 1.0

func get_converted_people_per_second() -> float:
	return (converted_per_action / action_duration) * Global.CHARACTER_MULTIPLIER

func get_money_per_second() -> float:
	return (money_per_action / action_duration) * Global.CHARACTER_MULTIPLIER

func calc_action_duration(max_action_duration: float, effectiveness: float, min_duration := 0.1) -> float:
	var duration = max_action_duration * (1.0 - clamp(effectiveness, 0.0, 1.0))
	return max(duration, min_duration)
