extends Node

# Defines the  Costs of each Character Class
const class_costs : Dictionary = {
	"JOKER" : 1	# time in seconds -> initial value -> upgrades can speed up this time
}

# VARIABLES THAT MUST BE UPDATED REGULARLY
var CURRENT_COUNTRY : String 	# holds the country name which currently is in focus
