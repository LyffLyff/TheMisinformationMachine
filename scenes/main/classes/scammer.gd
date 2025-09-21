extends Character
class_name Scammer

func _init(country : String) -> void:
	var effectiveness = calc_effectiveness_by_wealth_log(country)
	
	action_duration = calc_action_duration(60 * 24 * 60, effectiveness, 60 * 60)
	converted_per_action = calc_converted_population(country, effectiveness)
	money_per_action = (CountryData.get_gdp(country) / CountryData.get_population(country))  * effectiveness


func calc_effectiveness_by_wealth_log(country: String, max_gdp_per_capita := 100_000.0) -> float:
	var gdp_per_person: float = CountryData.get_gdp(country) / max(1.0, CountryData.get_population(country))
	var effectiveness: float = log(gdp_per_person + 1.0) / log(max_gdp_per_capita + 1.0)
	return clamp(effectiveness, 0.0, 1.0)


func calc_converted_population(country: String, effectiveness: float, max_fraction := 0.0001) -> int:
	# Get the total population
	var population: int = int(CountryData.get_population(country))
	
	# Calculate the desired conversion (scaled by effectiveness)
	var converted: float = population * effectiveness
	
	# Cap to maximum fraction of the population
	var max_converted: float = population * max_fraction
	converted = min(converted, max_converted)
	
	# Return as integer
	return int(converted)
