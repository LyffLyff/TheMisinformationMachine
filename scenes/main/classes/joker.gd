class_name Joker
extends Character

# Class for the Joker -> A Character spreading misinformation by doing jokes/trolling
# Primarly on Social Media  and rarely in  Real Life

const MAX_ACTION_DURATION: int = 3000


func _init(country: String) -> void:
	# random float strictly between 0 and 1
	var effectiveness = get_normalized_population_log(country) * 0.005

	# random integer strictly between 180s and 86400s
	action_duration = calc_action_duration(MAX_ACTION_DURATION, effectiveness)
	money_per_action = (CountryData.get_gdp(country) / CountryData.get_population(country)) * effectiveness
	converted_per_action = (CountryData.get_population(country) * 0.001) * effectiveness


func get_normalized_population_log(country: String, max_pop := 1_400_000_000.0) -> float:
	var pop: float = CountryData.get_population(country)
	return log(pop + 1.0) / log(max_pop + 1.0)
