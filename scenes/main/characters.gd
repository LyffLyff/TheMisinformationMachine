extends Node

## JOKER ##
const JOKER_MAX_ACTION_DURATION: int = 3000

## CONSPIRACY THEORIST ##
const CONSPIRATOR_MAX_MONEY_PS: float = 0.0


func get_new_joker_properties(country: String) -> Array:
	# random float strictly between 0 and 1
	var effectiveness = _get_normalized_population_log(country) * 0.005

	# random integer strictly between 180s and 86400s
	var action_duration: float = _calc_action_duration(JOKER_MAX_ACTION_DURATION, effectiveness)
	var money_per_action: float = (CountryData.get_gdp(country) / CountryData.get_population(country)) * effectiveness
	var converted_per_action: float = (CountryData.get_population(country) * 0.001) * effectiveness
	return [
		action_duration,
		money_per_action,
		converted_per_action
	]


## SCAMMER ## 
func get_new_scammer_properties(country: String) -> Array:
	var effectiveness = _calc_effectiveness_by_wealth_log(country)

	var action_duration: float = _calc_action_duration(60 * 24 * 60, effectiveness, 60 * 60)
	var converted_per_action: float = _calc_converted_per_action(country, effectiveness)
	var money_per_action: float = (CountryData.get_gdp(country) / CountryData.get_population(country)) * effectiveness
	return [
		action_duration,
		converted_per_action,
		money_per_action
	]

## CONSPIRATOR
func get_new_conspirator_properties(country: String) -> Array:
	# MORE EFFECTIVE IN YOUNGER AND POORER NATIONS
	var max_converted: int = int(CountryData.get_population(country) * 0.01) # 1%

	var effectiveness := _calc_conspirator_effectiveness(country) * 0.1

	var action_duration: float = _calc_action_duration(60 * 60, effectiveness, 60)
	var money_per_action: float = CONSPIRATOR_MAX_MONEY_PS * effectiveness
	var converted_per_action: float = max_converted * effectiveness

	return [
		action_duration,
		money_per_action,
		converted_per_action
	]


## POLITICIAN ##
func get_new_politician_properties(country: String, bribe_per_day: float) -> Array:
	var action_duration := 24 * 60 * 60 # 1 day
	var money_per_action := CountryData.get_gdp(country) / CountryData.get_population(country) / 100 * bribe_per_day
	var converted_per_action := 0.01 * CountryData.get_population(country) # 1% of country per day
	return [
		action_duration,
		money_per_action,
		converted_per_action
	]


## GENERAL ##
func _calc_action_duration(max_action_duration: float, effectiveness: float, min_duration := 0.1) -> float:
	var duration = max_action_duration * (1.0 - clamp(effectiveness, 0.0, 1.0))
	return max(duration, min_duration)


func _get_normalized_population_log(country: String, max_pop := 1_400_000_000.0) -> float:
	var pop: float = CountryData.get_population(country)
	return log(pop + 1.0) / log(max_pop + 1.0)


func _calc_effectiveness_by_wealth_log(country: String, max_gdp_per_capita := 100_000.0) -> float:
	var gdp_per_person: float = CountryData.get_gdp(country) / max(1.0, CountryData.get_population(country))
	var effectiveness: float = log(gdp_per_person + 1.0) / log(max_gdp_per_capita + 1.0)
	return clamp(effectiveness, 0.0, 1.0)


func _calc_converted_per_action(country: String, effectiveness: float, max_fraction := 0.0001) -> int:
	# Get the total population
	var population: int = int(CountryData.get_population(country))

	# Calculate the desired conversion (scaled by effectiveness)
	var converted: float = population * effectiveness

	# Cap to maximum fraction of the population
	var max_converted: float = population * max_fraction
	converted = min(converted, max_converted)

	# Return as integer
	return int(converted)


func _calc_conspirator_effectiveness(country: String, max_age := 85.0, max_gdp_per_capita := 100_000.0) -> float:
	var age: float = CountryData.get_median_age(country)
	var gdp_per_capita: float = CountryData.get_gdp(country) / max(1.0, CountryData.get_population(country))

	# Normalize values
	var age_norm: float = clamp(age / max_age, 0.0, 1.0)
	var gdp_norm: float = clamp(gdp_per_capita / max_gdp_per_capita, 0.0, 1.0)

	# Invert (so younger & poorer = higher effectiveness)
	var age_score: float = 1.0 - age_norm
	var gdp_score: float = 1.0 - gdp_norm

	# Combine
	var effectiveness: float = (age_score + gdp_score) / 2.0

	return clamp(effectiveness, 0.0, 1.0)
