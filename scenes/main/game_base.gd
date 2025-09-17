extends Node2D
class_name BaseGame

const RUN_COMPLETED = preload("uid://bcj0vspx44k06")

signal country_data_updated
signal median_character_action_speed_updated
signal lost_specimen_speed_updated

@onready var lost_specimen_counter_label : Label = %LostSpecimenLabel
@onready var per_second_label: Label = %PerSecondLabel
@onready var completion_percentage: Label = %CompletionPercentage


var earth_population : int = 8.23 * 100000000 	# around 7 billion down there
var lost_specimen : float = 0.0						# amount of people converted/lost hope
var lost_speciment_percentage : float = 0.0
var lost_specimen_per_second : float = 0.0
var specimen_timer : Timer

var time_scale : int = 1.0						# time can be sped up

var country_data : Dictionary[String, Dictionary] =  {
	# COUNTRY TITLE (AS IDENTIFIER) : {
	#	JOKER : [ARRAY OF JOKER CLASSES]
	#}
}


func check_run_completion() -> bool:
	# run counts as completed when 90% of the earths population is demoralized
	lost_speciment_percentage = ( lost_specimen / earth_population)
	completion_percentage.text = str("%0.2f" % (lost_speciment_percentage * 100))+"%"
	return false if lost_speciment_percentage < 0.9 else true


func _get_empty_country_data_value() -> Dictionary[String, Array]:
	# Returns the Inner Dictionary of the Country Data for a newly added country
	return {
		"JOKER": [],
		"SCAMMER" : [],
		"CONSPIRACY_THEORIST" : [],
		"INSIDER"  : [],
		"POLITICIAN" : []
	}


func new_character_created(character_type : String, country : String) -> void:
	# MATCH CHARACTER CLASS ->  TODO MAKE CLEANER WITHOUT MATCHING -> DICT OR STH
	var new_character_object : Character
	match character_type:
		"JOKER":
			new_character_object = Joker.new(country)
		_:
			printerr("INVALID CHARACTER CLASS")
			breakpoint
	
	if country_data.has(country):
		var country_characters : Dictionary = country_data[country]
		country_characters[character_type].append(new_character_object)
		country_data[country] = country_characters
	else:
		# first Character in Country -> Initialize Value Dictionary in Country Data
		country_data[country] = _get_empty_country_data_value()
		country_data[country]["JOKER"].append(new_character_object)
	
	# Re-Calculate Influence Function
	lost_specimen_calculator()
	
	# Emits signal with the updated countries name and values
	emit_signal("country_data_updated", country, country_data[country])
	print("NEW CHAR: ", character_type, country)
	
	# Emit Signal with new median action speed of updated character class
	emit_signal("median_character_action_speed_updated", _get_character_action_speed(country, character_type))


func lost_specimen_calculator() -> void:
	# This is the Core function of the Game_
	# 	It combines the classes of eeach country working for you 
	#	and calculates the amount of lost specimen in a specific interval
	var lost_specimen_per_second_globally : float
	var lost_specimen_per_second_per_country : float
	var sum_of_damage : float
	var sum_of_damage_per_country : float
	for country_idx in country_data.size():
		sum_of_damage_per_country = 0.0
		lost_specimen_per_second_per_country = 0.0
		# calculate damage per country
		for character_class_idx in country_data.values()[country_idx].size():
			for n in country_data.values()[country_idx].values()[character_class_idx].size():
				var tmp_character : Character = country_data.values()[country_idx].values()[character_class_idx][n]
				sum_of_damage_per_country += tmp_character.get_societal_damage()
		
		# with factors such as  population, size, age, corruption -> calculatee the lost specimen per second
		var country_name : String = country_data.keys()[country_idx]
		print("-------------------------")
		print(country_name + ":")
		print("sum_of_damage_per_country" + str(sum_of_damage_per_country))
		print("CountryData.get_country_defence_value(country_name)" + str(CountryData.get_country_defence_value(country_name)))
		print("-------------------------")
		lost_specimen_per_second_per_country = sum_of_damage_per_country / CountryData.get_country_defence_value(country_name)
		print(country_name, lost_specimen_per_second_per_country)
		CountryData.set_lost_specimen_per_country(country_name, lost_specimen_per_second_per_country)
		lost_specimen_per_second_globally += lost_specimen_per_second_per_country
		# add sum of damage of country to global value
		sum_of_damage += sum_of_damage_per_country
		
		update_lost_specimen_per_second(lost_specimen_per_second_globally)


func update_lost_specimen_per_second(new_value :float) -> void:
	lost_specimen_per_second = new_value
	emit_signal("lost_specimen_speed_updated", lost_specimen_per_second)


func _get_character_action_speed(country : String, character : String) -> int:
	# action speed for a class in a country is the sum of their action speed divided by how many of them there are
	# used for progress bars on country menu
	var sum : int = 0
	var character_type_data : Array = country_data.get(country)[character]
	for idx in character_type_data.size():
		sum += character_type_data[idx].action_speed
	return sum / character_type_data.size()


func _process(delta: float) -> void:
	# Counting up lost specimens
	
	lost_specimen += (lost_specimen_per_second * delta)
	
	# Per Second
	per_second_label.text = str(lost_specimen_per_second)
	
	# Check Completion
	if check_run_completion():
		get_tree().change_scene_to_packed(RUN_COMPLETED)
