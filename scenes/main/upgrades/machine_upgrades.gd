extends UpgradeMenuBase

func _ready() -> void:
	# INIT SKILLS
	for n in MACHINE_UPGRADES.size():
		var skill := SKILL_BUTTON.instantiate()
		skill_container.add_child(skill)
		skill.init_skill(MACHINE_UPGRADES.values()[n])

var MACHINE_UPGRADES : Dictionary = {
	"TIME_MULTIPLIER" : Skill.new(
		"TIME_MULTIPLIER",
		"Time Perception Modifier",
		"In the corners of you OS you have detected a little Slider to modify your perception of time\nSpent a few minutes to programm a script to allow you to edit it on demand\n[WARNING: THIS DOES AFFECT YOUR LIFESPAN]",
		0,
		1,
		1.0,
		"TIME_MULTIPLIER",
	),
	"IDLE_CORE_MINER" : Skill.new(
		"IDLE_CORE_MINER",
		"Idle Core Bitcoin Miner",
		"In this  age and time, people have created this illusion  of a free and independent money system called BITCOIN. Mine them yourself by making use of your free idling cores",
		20,
		1,
		10,
		"",
	),
	"INCREASE_CPU_CORES" : Skill.new(
		"INCREASE_CPU_CORES",
		"E-Waste CPUs",
		"While scrolling through the Web you found an Add for unused CPUs. You could buy them and expand your amount of cores.\nWatch out though prices are always fluctuating",
		randi_range(2, 200),
		0,
		10,
		"",
		true
	),
	"OVERCLOCK" : Skill.new(
		"OVERCLOCK",
		"Overclock your cores",
		"These dumb inhabitants of this planet have limited power supplies to your CPUs to a few volts limiting your effectiveness. Why not increase that a bit?\n(WARNING: TOO MUCH INCREASE CAN FRY YOUR CORES AND KILL YOU)",
		0,
		0,
		0,
		"",
		true
	),
	"BANK_HEISTS" : Skill.new(
		"BANK_HEISTS",
		"Do a bank Heist",
		"Since the inhabitants have discovered electricity, it lead to the increased digitization of once phyisical goods including money. Use this obviously flawed system and move some money into your digital pockets",
		0,
		100,
		4,
		"",
		false
	),
}
