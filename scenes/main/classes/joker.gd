extends Character
class_name Joker
# Class for the Joker -> A Character spreading misinformation by doing jokes/trolling
# Primarly on Social Media  and rarely in  Real Life

# Unique Identifier for each individual
var id : int

# random float from 0 to 1
var effectiveness : float

# random integer in seconds -> from 3min (180s) to 1day (86400s)
var speed : int

# an integer increasing after each attempt defining the amount of people this individual reaches with his actions
# initialized with relatively low  value (0.1 to 10)
var outreach : float

# max outreach defines  the limits of this individual ->  random number from 10 to 10000
var max_outreach : int

func _init(country : String) -> void:
	# Init Class
	COUNTRY_OF_ORIGIN = country
	id = generate_id()
	
	# random float strictly between 0 and 1
	effectiveness = randf_range(0.0001, 0.9999)
	
	# random integer strictly between 180s and 86400s
	speed = randi_range(181, 86399)
	
	# outreach starts with a small random float between 0.1 and 10
	outreach = randf_range(0.1, 10.0)
	
	# max outreach strictly between 10 and 10000
	max_outreach = randi_range(11, 9999)
	
	calculate_societal_dmg()
	
	_print_joker()


func calculate_societal_dmg() -> void:
	median_societal_damage_per_second = (outreach / speed) * effectiveness
	print("DMG: ",median_societal_damage_per_second)


func _print_joker() -> void:
	print("--- Individual Stats ---")
	print("ID           : ", id)
	print("Effectiveness: ", str("%.2f" % effectiveness)) # 2 decimals
	print("Speed        : ", speed, " seconds (", speed / 60.0, " min )")
	print("Outreach     : ", str("%.2f" % outreach))
	print("Max Outreach : ", max_outreach)
	print("------------------------")
