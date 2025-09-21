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
		"Time Modifier",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.2_98.png"),
		"In the corners of your OS you have detected a little [color=#9a7dce]Slider[/color] to modify your perception of [color=#b37f7f]time[/color].\nSpent a few minutes to program a script to allow you to edit it on demand.\n[color=#d1b77f][b][WARNING]: THIS DOES AFFECT YOUR LIFESPAN[/b][/color]",
		0,
		1,
		1.0,
	),
	"BACKGROUND_SCRIPT" : Skill.new(
		"BACKGROUND_SCRIPT",
		"Automatic Poisoning",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.1_39.png"),
		"Python is a [color=#9a7dce][b]powerful[/b][/color] language for [color=#7fa3a3]scripting[/color].\nUse your knowledge to craft a convoluted algorithm that will automatically [color=#b37f7f]poison the minds[/color] of unsuspecting individuals.",
		0,
		1,
		20,
		false
	),
	"GROUP_PROPAGANDA" : Skill.new(
		"GROUP_PROPAGANDA",
		"Group Therapy",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.3_14.png"),
		"Speak to [color=#9a7dce]groups[/color] instead of one-to-one, adding a [color=#7fa3a3]group dynamic[/color] and letting you [color=#b37f7f]poison multiple minds[/color] with a [color=#d1b77f]single press[/color].",
		10,
		1,
		10,
		true
	),
	"IDLE_CORE_MINER" : Skill.new(
		"IDLE_CORE_MINER",
		"Idle Core\nBitcoin Miner",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.2_25.png"),
		"In this age and time, people have created the illusion of a [color=#7fa3a3]free and independent money system[/color] called [b][color=#c28c8c]BITCOIN[/color][/b].\nMine them yourself by making use of your free idling cores[/color].",
		20,
		1,
		10,
	),
	"INCREASE_CPU_CORES" : Skill.new(
		"INCREASE_CPU_CORES",
		"E-Waste CPUs",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.3_14.png"),
		"While scrolling through the Web you found an [color=#9a7dce]Ad[/color] for [b][color=#7fa3a3]unused CPUs[/color][/b].\nYou could buy them and expand your amount of [color=#b37f7f]cores[/color].\n[color=#d1b77f][b]Watch out[/b][/color] though — prices are always fluctuating.",
		randi_range(2, 200),
		0,
		10,
		true
	),
	"OVERCLOCK" : Skill.new(
		"OVERCLOCK",
		"Overclock",
		load("res://assets/icons/789_Lorc_RPG_icons/Icons8_76.png"),
		"These dumb inhabitants of this planet have limited [color=#7fa3a3]power supplies[/color] to your CPUs, restricting you to only a few volts. Why not increase that a bit?\n[color=#d1b77f][b](WARNING: TOO MUCH CAN FRY YOUR CORES AND KILL YOU)[/b][/color]",
		0,
		0,
		0,
		true
	),
	"BANK_HEISTS" : Skill.new(
		"BANK_HEISTS",
		"Bank Heists",
		load("res://assets/icons/789_Lorc_RPG_icons/Icons8_32.png"),
		"Since the inhabitants discovered [color=#7fa3a3]electricity[/color], it led to the digitization of once-physical goods — including [color=#b37f7f]money[/color].\nUse this obviously flawed system and [b]move some money[/b] into your digital pockets.\n With a bit of luck you can bribe all the politicians you want and get this over with in no time.",
		0,
		3,
		60,
		true
	),
}
