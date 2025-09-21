extends Character
class_name Politician

func _init(bribe_per_day : float, country : String) -> void:
		action_duration = 24 * 60 * 60 # 1 day
		money_per_action = CountryData.get_gdp(country) / CountryData.get_population(country) / 100 * bribe_per_day
		converted_per_action = 0.01 * CountryData.get_population(country) # 1% of country per day
