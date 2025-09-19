extends RefCounted
class_name Character
# Base Class for every type of character

var median_societal_damage_per_second : float = 0

var action_speed_in_seconds : int  = 1

var converted_per_action : int = 1

var money_per_action : int = 1

# Time this Character was Created -> Important for many Damage Calculation
var CREATION_TIME := Time.get_unix_time_from_system()

func generate_id() -> int:
	# random id -> time
	return Time.get_unix_time_from_system()

func get_societal_damage() -> float:
	# Calculate this functions retuirn value in specific Character Class
	# -> Each Character must be calculated differently
	return median_societal_damage_per_second

func get_converted_people_per_second() -> float:
	return (converted_per_action / action_speed_in_seconds) * Global.CHARACTER_MULTIPLIER

func get_money_per_second() -> float:
	return (money_per_action / action_speed_in_seconds) * Global.CHARACTER_MULTIPLIER
