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
var POISONING_MULTIPLIER : int = 10
var CORE_MULTIPLIER : float = 1.0		# speed modifier for each task of a core -> idle or normal
var IDLE_CORES_ACTIVATED : bool = false
var AUTO_RESTART_CORE_TASKS : bool = false
var AUTOCLICKER_ACTIVATED :  bool = false
var AUTO_CLICKER_SPEED : float = 1.0
var CHARACTER_MULTIPLIER : float = 1.0	# multiplier for effectiveness of all characters

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

signal autoclicker_unlocked
signal unlock_idle_core_miner
signal overclock_cores
signal auto_restart_core_tasks
signal autoclicker_activated

# Time Modifier
signal time_modifier_unlocked
signal time_modifier_changed
var time_modifier : float = 1.0

var SKILL_POINTS : int = 100
var LOST_SPECIMEN :  float

var UNLOCKED_SKILLS : PackedStringArray = [] # LIST OF ALL UNLOCKED SKILL IDs

func unlock_skill(skill_to_unlock : Skill) -> void:
	# CHECK FOR MONEY & SKILL POINTS
	if skill_to_unlock.skill_point_cost > SKILL_POINTS:
		emit_signal("insufficient_skill_points", skill_to_unlock.identifier)
		return
	
	# START CORE  IF TIME IS GREATER THAN ZERO
	emit_signal("start_skill_task", skill_to_unlock)
	UNLOCKED_SKILLS.append(skill_to_unlock.identifier)


func skill_unlocked(unlocked_skill_id : String):
	match unlocked_skill_id:
		"TIME_MULTIPLIER":
			emit_signal("time_modifier_unlocked")
			self.connect("time_modifier_changed", self._set_time_modifier)
		"OVERCLOCK":
			pass
		"IDLE_CORE_MINER":
			IDLE_CORES_ACTIVATED = true
			emit_signal("unlock_idle_core_miner")
		"INCREASE_EFFICIENCY":
			POISONING_MULTIPLIER += 1
		"AUTO_RESTART_CORE_TASKS":
			AUTO_RESTART_CORE_TASKS = true
			emit_signal("auto_restart_core_tasks")
		"BACKGROUND_SCRIPT":
			AUTOCLICKER_ACTIVATED = true
			emit_signal("autoclicker_activated")
			call_deferred("autoclicker")
		"GROUP_PROPAGANDA":
			pass
		"BANK_HEISTS":
			pass
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

func get_game_base() -> BaseGame:
	# Fetches the Current Data Dictionary from the Game's Root
	return get_tree().root.get_child(get_tree().root.get_child_count() - 1)


func get_normalized_country_name(country_name : String) -> String:
	return country_name.capitalize().replace("_", " ")

func unselect_country():
	Global.CURRENT_COUNTRY = ""


func autoclicker() -> void:
	var autoclicker_timer := Timer.new()
	autoclicker_timer.autostart = true
	autoclicker_timer.one_shot = true
	self.add_child(autoclicker_timer)
	while true:
		autoclicker_timer.wait_time = 1.0 * AUTO_CLICKER_SPEED
		autoclicker_timer.start()
		
		await autoclicker_timer.timeout
		
		CountryData.increment_static_specimen_for_all_countries()
