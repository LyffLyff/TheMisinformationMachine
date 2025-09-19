extends Node


enum TASK_TYPES {
	CHARACTER_CREATION,
	NETWORKING,
	BRIBING_POLITICIAN,
}

# Defines the  Costs of each Character Class
const class_costs : Dictionary = {
	"JOKER" : 1,	# time in seconds -> initial value -> upgrades can speed up this time
	"POLITICIAN" : 2,
	"SCAMMER" : 20,
	"CONSPIRATOR" : 30,
}

# VARIABLES THAT MUST BE UPDATED REGULARLY
var CURRENT_COUNTRY : String 	# holds the country name which currently is in focus

func tween_label_counter(label : Label, new_value, duration : float = 1.0, is_float : bool = false) -> void:
	var val
	var current_val
	if is_float:
		val = float(new_value)
		current_val = float(label.text)
	else:
		val = int(new_value)
		current_val = int(label.text)
	
	print("C: %d, N: %d" % [current_val, val])
		
	create_tween().tween_method(
		func(value): 
			if label:
				if is_float:
					label.text = "%.1f" % value  # 1 decimal place for floats
				else:
					label.text = str(int(value)),  # No decimals for integers
		current_val,                      
		val,                        
		duration                     
	)

# SKILLS #
signal start_skill_task
signal skill_points_changed
signal insufficient_skill_points

# Time Modifier
signal time_modifier_unlocked
signal time_modifier_changed
var time_modifier : float = 1.0

var SKILL_POINTS : int = 0 

var UNLOCKED_SKILLS : PackedStringArray = [] # LIST OF ALL UNLOCKED SKILL IDs

func unlock_skill(skill_to_unlock : Skill) -> void:
	# CHECK FOR MONEY & SKILL POINTS
	if skill_to_unlock.skill_point_cost > SKILL_POINTS:
		emit_signal("insufficient_skill_points", skill_to_unlock.identifier)
		return
	
	# START CORE  IF TIME IS GREATER THAN ZERO
	emit_signal("start_skill_task", skill_to_unlock)


func skill_unlocked(unlocked_skill_id : String):
	UNLOCKED_SKILLS.append(unlocked_skill_id)
	match unlocked_skill_id:
		"TIME_MULTIPLIER":
			emit_signal("time_modifier_unlocked")
			self.connect("time_modifier_changed", self._set_time_modifier)
		_:
			printerr("UNKNOWN SKILL")
		
	# Audio
	GlobalSoundPlayer.play_skill_jingle()

func add_skill_point() -> void:
	SKILL_POINTS += 1
	emit_signal("skill_points_changed", SKILL_POINTS)

func spend_skill_points(cost : int) -> bool:
	if cost > SKILL_POINTS:
		SKILL_POINTS -= cost
		emit_signal("skill_points_changed", SKILL_POINTS)
		return true
	return false

func _set_time_modifier(new_time_modifier_value : float) -> void:
	time_modifier = new_time_modifier_value


func get_current_country_character_data() -> Dictionary:
	# Fetches the Current Data Dictionary from the Game's Root
	return get_tree().root.get_child(get_tree().root.get_child_count() - 1).country_data[CURRENT_COUNTRY]


func get_normalized_country_name(country_name : String) -> String:
	return country_name.capitalize().replace("_", " ")

func unselect_country():
	Global.CURRENT_COUNTRY = ""
