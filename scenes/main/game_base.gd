extends Node2D
class_name BaseGame

const RUN_COMPLETED = preload("uid://bcj0vspx44k06")
const RUN_FAILED = preload("uid://di3cfsc8a1ps3")

signal country_data_updated
signal median_character_action_speed_updated
signal lost_specimen_speed_updated

@onready var lost_specimen_counter_label : Label = %LostSpecimenLabel
@onready var per_second_label: Label = %PerSecondLabel
@onready var completion_percentage: Label = %CompletionPercentage
@onready var money_counter: Timer = %MoneyCounter


var earth_population : int = 8.23 * 100000000 	# around 7 billion down there
var lost_specimen : float = 0.0						# amount of people converted/lost hope
var lost_speciment_percentage : float = 0.0
var lost_specimen_per_second : float = 0.0
var specimen_timer : Timer

# MONEY
signal finances_changed
const MAX_DEBT_AMOUNT : int = 10000
var incoming_money_ps : float = 0.0
var outgoing_money_ps : float = 0.0
var static_money : float = 0.0

var time_scale : int = 1.0						# time can be sped up

func check_run_completion() -> bool:
	# run counts as completed when 90% of the earths population is demoralized
	lost_speciment_percentage = ( lost_specimen / earth_population)
	completion_percentage.text = str("%0.5f" % (lost_speciment_percentage * 100))+"%"
	return false if lost_speciment_percentage < 0.9 else true


func new_character_created(character_type : String, country : String) -> void:
	# MATCH CHARACTER CLASS ->  TODO MAKE CLEANER WITHOUT MATCHING -> DICT OR STH
	var new_character_object : Character
	match character_type:
		"JOKER":
			new_character_object = Joker.new(country)
		"SCAMMER":
			new_character_object = Scammer.new()
		"CONSPIRATOR":
			new_character_object = Conspirator.new(country)
		"POLITICIAN":
			new_character_object = Politician.new(CountryData.get_politician_idx(country))
		_:
			printerr("INVALID CHARACTER CLASS")
			breakpoint
	
	CountryData.check_progression_started(country)
	
	var country_characters : Dictionary = CountryData.character_data_per_country[country]
	country_characters[character_type].append(new_character_object)
	CountryData.character_data_per_country[country] = country_characters

	
	# Re-Calculate Influence Function
	lost_specimen_calculator()
	
	# Update Country Progression
	
	# Emits signal with the updated countries name and values
	emit_signal("country_data_updated", country, CountryData.character_data_per_country[country])
	print("NEW CHAR: ", character_type, country)
	
	# Emit Signal with new median action speed of updated character class
	emit_signal("median_character_action_speed_updated", _get_character_action_speed(country, character_type))


func lost_specimen_calculator() -> void:
	# This is the Core function of the Game_
	# 	It combines the classes of eeach country working for you 
	#	and calculates the amount of lost specimen in a specific interval
	var lost_specimen_per_second_globally : float
	var lost_specimen_per_second_per_country : float

	for country_idx in CountryData.character_data_per_country.size():
		lost_specimen_per_second_per_country = 0.0
		# calculate damage per country
		for character_class_idx in CountryData.character_data_per_country.values()[country_idx].size():
			for n in CountryData.character_data_per_country.values()[country_idx].values()[character_class_idx].size():
				var tmp_character : Character = CountryData.character_data_per_country.values()[country_idx].values()[character_class_idx][n]
				lost_specimen_per_second_per_country += tmp_character.get_converted_people_per_second()
		
		# with factors such as  population, size, age, corruption -> calculatee the lost specimen per second
		var country_name : String = CountryData.character_data_per_country.keys()[country_idx]
		#print("-------------------------")
		#print(country_name + ":")
		#print("sum_of_damage_per_country" + str(sum_of_damage_per_country))
		#print("CountryData.get_country_defence_value(country_name)" + str(CountryData.get_country_defence_value(country_name)))
		#print("-------------------------")
		# lost_specimen_per_second_per_country = converted_people_per_second 
		#print(country_name, lost_specimen_per_second_per_country)
		CountryData.set_lost_specimen_per_country(country_name, lost_specimen_per_second_per_country)
		lost_specimen_per_second_globally += lost_specimen_per_second_per_country
		# add sum of damage of country to global value
		
	update_lost_specimen_per_second(lost_specimen_per_second_globally)


func update_lost_specimen_per_second(new_value :float) -> void:
	lost_specimen_per_second = new_value
	emit_signal("lost_specimen_speed_updated", lost_specimen_per_second)


func _get_character_action_speed(country : String, character : String) -> float:
	# action speed for a class in a country is the sum of their action speed divided by how many of them there are
	# used for progress bars on country menu
	var sum : int = 0
	var character_type_data : Array = CountryData.character_data_per_country.get(country)[character]
	for idx in character_type_data.size():
		sum += character_type_data[idx].action_speed_in_seconds
	return sum / character_type_data.size()


func update_calculations() -> void:
	lost_specimen_calculator()


func _process(delta: float) -> void:
	# Counting up lost specimens
	lost_specimen += lost_specimen_per_second * delta
	Global.LOST_SPECIMEN = lost_specimen
	# For each country aswell :(
	CountryData.update_lost_specimen(delta)
	
	print(lost_specimen)
	
	lost_specimen_counter_label.text = str(
		int(lost_specimen + 
		CountryData.get_total_static_lost_specimen()
		) # static offset)
	)
	
	# Check Completion
	if check_run_completion():
		get_tree().change_scene_to_packed(RUN_COMPLETED)


func add_static_money(added_money : float = randf_range(0.0, 2.0)) -> void:
	# if no money specified -> lost individual random amount
	static_money += added_money
	emit_signal("finances_changed", static_money, incoming_money_ps, outgoing_money_ps)


func _on_money_counter_timeout() -> void:
	# Count Up Static Money with the difference of Money
	static_money += (incoming_money_ps - outgoing_money_ps)
	if -static_money > MAX_DEBT_AMOUNT:
		get_tree().change_scene_to_packed(RUN_FAILED)
	emit_signal("finances_changed", static_money, incoming_money_ps, outgoing_money_ps)


func add_outgoing_money(amount) -> void:
	outgoing_money_ps += amount
	emit_signal("finances_changed", static_money, incoming_money_ps, outgoing_money_ps)


func _on_politicians_button_pressed() -> void:
	# TODO CHECK MONEY
	var bribe_money_ps := CountryData.get_next_bribe_cost_per_day() / 24 / 60 / 60
	if incoming_money_ps  - outgoing_money_ps > bribe_money_ps or static_money > bribe_money_ps:
		# Player can go into debt
		add_outgoing_money(bribe_money_ps)
		new_character_created("POLITICIAN", Global.CURRENT_COUNTRY)
	else:
		printerr("NOT ENOUGH MONEY")
