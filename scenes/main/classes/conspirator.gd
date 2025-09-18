extends Character
class_name Conspirator

var coolness : float
var effectiveness : float
var outreach : float

func _init(country : String) -> void:
	coolness  = randf_range(0.0, 1.0)
	effectiveness = CountryData.get_median_age(country) * (CountryData.get_gdp(country) / CountryData.get_population(country))
	outreach = randf_range(100.0, CountryData.get_population(country) * 0.7)
	
	calculate_societal_dmg()

func calculate_societal_dmg() -> void:
	median_societal_damage_per_second = effectiveness * outreach * coolness
	
