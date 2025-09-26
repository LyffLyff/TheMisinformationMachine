class_name BaseGame
extends Node2D

signal country_data_updated
signal median_conspirator_speed_updated
signal median_scammer_speed_updated
signal median_joker_speed_updated
signal median_politician_speed_updated

signal lost_specimen_speed_updated

# MONEY
signal finances_changed

const RUN_COMPLETED = preload("uid://bcj0vspx44k06")
const RUN_FAILED = preload("uid://di3cfsc8a1ps3")

const CHARACTER_SIGNALS := {
	"CONSPIRATOR": "median_conspirator_speed_updated",
	"SCAMMER": "median_scammer_speed_updated",
	"JOKER": "median_joker_speed_updated",
	"POLITICIAN": "median_politician_speed_updated"
}
const MAX_DEBT_AMOUNT: int = 10000

var lost_specimen: float = 0.0 # amount of people converted/lost hope
var lost_speciment_percentage: float = 0.0
var lost_specimen_per_second: float = 0.0
var specimen_timer: Timer
var incoming_money_ps: float = 0.0
var outgoing_money_ps: float = 0.0
var static_money: float = 0.0

var time_scale: int = 1.0 # time can be sped up

var total: int
var completion: float
var display_total := []

@onready var lost_specimen_counter_label: Label = %LostSpecimenLabel
@onready var lost_specimen_multiplier_label: Label = %LostSpecimenMultiplierLabel
@onready var per_second_label: Label = %PerSecondLabel
@onready var completion_percentage: Label = %CompletionPercentage


func _process(delta: float) -> void:
	if !get_tree().paused:
		# Counting up lost specimens
		lost_specimen += lost_specimen_per_second * delta
		Global.LOST_SPECIMEN = lost_specimen
		# For each country aswell :(
		CountryData.update_lost_specimen(delta)
		CountryData.update_country_calculations(delta)

		total = int(lost_specimen +
			CountryData.get_total_static_lost_specimen()
		) # static offset)

		display_total = Global.format_big_number(total)
		lost_specimen_counter_label.text = display_total[0]
		lost_specimen_multiplier_label.text = display_total[1]

		completion = (total / CountryData.get_global_population())
		completion_percentage.text = ("CONVERTED: %0.1f" % (completion * 100.0) + "%")

		# Count Up Static Money with the difference of Money
		static_money += ((incoming_money_ps - outgoing_money_ps) * delta)
		if - static_money > MAX_DEBT_AMOUNT:
			Global.REASON_OF_DEATH = "DEBT"
			get_tree().change_scene_to_packed(RUN_FAILED)
		emit_signal("finances_changed", static_money, incoming_money_ps, outgoing_money_ps)

		# Check Completion
		if check_run_completion(completion):
			get_tree().change_scene_to_packed(RUN_COMPLETED)


func check_run_completion(progress) -> bool:
	# run counts as completed when 90% of the earths population is demoralized
	return false if progress < 0.9 else true


func new_character_created(character_type: String, country: String) -> void:
	var new_character_properties: Array # Action Duration, Converted per Action, Money per action
	var previous_actions : Array
	var new_character_amount : int
	var new_character_median_action_speed : float
	match character_type:
		"JOKER":
			previous_actions = CountryData[country]["JOKER_ACTIONS"]
			new_character_amount = previous_actions[3] + 1
			new_character_properties = Characters.get_new_joker_properties(country)
			new_character_median_action_speed = (previous_actions[0] + new_character_properties[0]) / new_character_amount
			CountryData[country]["JOKER_ACTIONS"] = [
				new_character_median_action_speed,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				new_character_amount
			]
		"SCAMMER":
			previous_actions = CountryData[country]["SCAMMER_ACTIONS"]
			new_character_amount = previous_actions[3] + 1
			new_character_properties = Characters.get_new_scammer_properties(country)
			CountryData[country]["SCAMMER_ACTIONS"] = [
				new_character_median_action_speed,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				new_character_amount
			]
		"CONSPIRATOR":
			previous_actions = CountryData[country]["CONSPIRATOR_ACTIONS"]
			new_character_amount = previous_actions[3] + 1
			new_character_properties = Characters.get_new_conspirator_properties(country)
			CountryData[country]["CONSPIRATOR_ACTIONS"] = [
				new_character_median_action_speed,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				new_character_amount
			]
		"POLITICIAN":
			previous_actions = CountryData[country]["POLITICIAN_ACTIONS"]
			new_character_amount = previous_actions[3] + 1
			new_character_properties = Characters.get_new_politician_properties(
				country,
				CountryData.get_next_bribe_cost_per_day(
					CountryData.get_character_amount_per_country(country, "POLITICIAN"),
					country
				)
			)
			CountryData[country]["POLITICIAN_ACTIONS"] = [
				new_character_median_action_speed,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				(previous_actions[0] + new_character_properties[0]) / new_character_amount,
				new_character_amount
			]
		_:
			printerr("INVALID CHARACTER CLASS")
			breakpoint

	CountryData.check_progression_started(country)
	CountryData.increment_character_per_country(country, character_type)

	# MONEY
	add_incoming_money(new_character_properties[2] / new_character_properties[0])

	# UPDATE COUNTRY DETAILS PROGRESS BAR SPEED
	emit_signal(CHARACTER_SIGNALS.get(character_type), CountryData.get_median_character_action_speed(country, character_type))

	# Re-Calculate Influence Function
	recalculate_specimen_per_second_single_country(country)

	# Emits signal with the updated countries name and values
	emit_signal("country_data_updated", country, CountryData.character_data_per_country[country])
	print("NEW CHAR: ", character_type, country)

	# Emit Signal with new median action speed of updated character class

	emit_signal(CHARACTER_SIGNALS.get(character_type), new_character_median_action_speed)


func recalculate_specimen_per_second_single_country(country: String) -> void:
	if CountryData.is_country_completed(country):
		return
	# update the lost specimen per country for a single country
	# -> by adding the difference of the previous value and the next value to the global counter
	var previous_lost_specimen_ps: float = CountryData.get_lost_specimen_ps(country)
	var new_lost_specimen_ps: float = 0.0
	# calculate damage per country
	var country_chars: Dictionary = CountryData.character_data_per_country.get(country)
	for character_class_idx in country_chars:
		for n in country_chars.values()[character_class_idx].size():
			var tmp_character: Character = country_chars[character_class_idx][n]
			new_lost_specimen_ps += tmp_character.get_converted_people_per_second()
	lost_specimen_per_second += (-previous_lost_specimen_ps + new_lost_specimen_ps)
	update_lost_specimen_per_second(lost_specimen_per_second)


func update_lost_specimen_per_second(new_value: float) -> void:
	lost_specimen_per_second = new_value
	emit_signal("lost_specimen_speed_updated", lost_specimen_per_second)


func update_calculations() -> void:
	recalculate_specimen_per_second_single_country(Global.CURRENT_COUNTRY)


func add_static_money(added_money: float = randf_range(0.0, 2.0)) -> void:
	# if no money specified -> lost individual random amount
	static_money += added_money


func add_outgoing_money(amount) -> void:
	outgoing_money_ps += amount


func add_incoming_money(amount) -> void:
	incoming_money_ps += amount


func _on_politicians_button_pressed() -> void:
	var bribe_money_ps := CountryData.get_next_bribe_cost_per_day() / 24
	GlobalSoundPlayer.bribed_politician()
	# Player can go into debt
	add_outgoing_money(bribe_money_ps)
	new_character_created("POLITICIAN", Global.CURRENT_COUNTRY)
