extends Node

# Defines the  Costs of each Character Class
const class_costs : Dictionary = {
	"JOKER" : 1	# time in seconds -> initial value -> upgrades can speed up this time
}

# VARIABLES THAT MUST BE UPDATED REGULARLY
var CURRENT_COUNTRY : String 	# holds the country name which currently is in focus

func tween_label_counter(label : Label, new_value, duration : float = 0.5) -> void:
	create_tween().tween_method(
		func(value): label.text = str(int(new_value)),
		int(label.text),                      
		new_value,                        
		duration                     
	)

# SKILLS #
signal start_skill_task

# Time Modifier
signal time_modifier_unlocked
signal time_modifier_changed
var time_modifier : float = 1.0

var SKILL_POINTS : int = 0 

var UNLOCKED_SKILLS : PackedStringArray = [] # LIST OF ALL UNLOCKED SKILL IDs

func unlock_skill(skill_to_unlock : Skill) -> void:
	# CHECK FOR MONEY & SKILL POINTS
	print(skill_to_unlock)
	
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

func _set_time_modifier(new_time_modifier_value : float) -> void:
	time_modifier = new_time_modifier_value


func get_current_country_character_data() -> Dictionary:
	# Fetches the Current Data Dictionary from the Game's Root
	return get_tree().root.get_child(get_tree().root.get_child_count() - 1).country_data[CURRENT_COUNTRY]
