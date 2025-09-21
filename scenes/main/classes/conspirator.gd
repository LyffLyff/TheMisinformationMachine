extends Character
class_name Conspirator

# all ps
const MAX_ACTION_DURATION_PS : int = 100
const MAX_MONEY_PS : int = 5

func _init(country : String) -> void:
	# MORE EFFECTIVE IN YOUNGER AND POORER NATIONS
	var max_converted : int = int(CountryData.get_population(country) * 0.01)	# 1%
	
	var effectiveness := calc_conspirator_effectiveness(country) * 0.1
	
	action_duration = calc_action_duration(60 * 60, effectiveness, 60)
	money_per_action = MAX_MONEY_PS * effectiveness
	converted_per_action = max_converted * effectiveness


func calc_conspirator_effectiveness(country: String, max_age := 85.0, max_gdp_per_capita := 100_000.0) -> float:
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
