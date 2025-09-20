extends UpgradeMenuBase

func _ready() -> void:
	# INIT SKILLS
	for n in MACHINE_UPGRADES.size():
		var skill := SKILL_BUTTON.instantiate()
		skill_container.add_child(skill)
		skill.init_skill(MACHINE_UPGRADES.values()[n])

var MACHINE_UPGRADES : Dictionary = {
	"BACKGROUND_SCRIPT" : Skill.new(
		"BACKGROUND_SCRIPT",
		"Automatic Poisoning",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.1_39.png"),
		"Python is a [color=#9a7dce][b]powerful[/b][/color] language for [color=#7fa3a3]scripting[/color].\nUse your knowledge to [wave amp=15 freq=2]craft a convoluted algorithm[/wave] that will automatically [pulse freq=1.5][color=#b37f7f]poison the minds[/color][/pulse] of unsuspecting individuals.",
		0,
		1,
		20,
		false
	),
	"GROUP_PROPAGANDA" : Skill.new(
		"Two are better than One",
		"GROUP_PROPAGANDA",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.3_14.png"),
		"Speak to [color=#9a7dce]groups[/color] instead of one-to-one, adding a [pulse freq=1.5][color=#7fa3a3]group dynamic[/color][/pulse] and letting you [color=#b37f7f]poison multiple minds[/color] with a [color=#d1b77f]single press[/color].",
		randi_range(2, 200),
		1,
		10,
		true
	),
	"TIME_MULTIPLIER" : Skill.new(
		"TIME_MULTIPLIER",
		"Time Perception\nModifier",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.2_98.png"),
		"In the corners of your OS you have detected a little [color=#9a7dce][pulse freq=1.5]Slider[/pulse][/color] to modify your perception of [color=#b37f7f]time[/color].\nSpent a few minutes to [wave amp=15 freq=2]program a script[/wave] to allow you to edit it on demand.\n[color=#d1b77f][b][pulse freq=1.5][WARNING][/pulse]: THIS DOES AFFECT YOUR LIFESPAN[/b][/color]",
		0,
		1,
		1.0,
	),
	"IDLE_CORE_MINER" : Skill.new(
		"IDLE_CORE_MINER",
		"Idle Core\nBitcoin Miner",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.2_25.png"),
		"In this age and time, people have created the illusion of a [color=#7fa3a3][pulse freq=1.5]free and independent money system[/pulse][/color] called [b][color=#c28c8c]BITCOIN[/color][/b].\n[wave amp=12 freq=2]Mine them yourself[/wave] by making use of your free [color=#b37f7f]idling cores[/color].",
		20,
		1,
		10,
	),
	"INCREASE_CPU_CORES" : Skill.new(
		"INCREASE_CPU_CORES",
		"E-Waste CPUs",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.3_14.png"),
		"While scrolling through the Web you found an [color=#9a7dce][pulse freq=1.5]Ad[/pulse][/color] for [b][color=#7fa3a3]unused CPUs[/color][/b].\nYou could [wave amp=14 freq=2]buy them[/wave] and expand your amount of [color=#b37f7f]cores[/color].\n[color=#d1b77f][b]Watch out[/b][/color] though — [pulse freq=1.2]prices are always fluctuating[/pulse].",
		randi_range(2, 200),
		0,
		10,
		true
	),
	"AUTO_RESTART_CORE_TASKS" : Skill.new(
		"AUTO_RESTART_CORE_TASKS",
		"Auto Restart Core Tasks",
		load("res://assets/icons/789_Lorc_RPG_icons/Icon.3_14.png"),
		"Tired of pressing that weird button to spawn an [color=#9a7dce]agent[/color]? This upgrade restarts [color=#7fa3a3]core scouting tasks[/color] [wave amp=12 freq=2]automatically[/wave] — [color=#c28c8c][b]you can still end them manually[/b][/color].",
		randi_range(2, 200),
		0,
		10,
		false
	),
	"OVERCLOCK" : Skill.new(
		"OVERCLOCK",
		"Overclock\nyour cores",
		load("res://assets/icons/789_Lorc_RPG_icons/Icons8_76.png"),
		"These dumb inhabitants of this planet have limited [color=#7fa3a3]power supplies[/color] to your CPUs, restricting you to only a few volts.\n[wave amp=14 freq=2]Why not increase that a bit?[/wave]\n[color=#d1b77f][b][pulse freq=1.5](WARNING: TOO MUCH CAN FRY YOUR CORES AND KILL YOU)[/pulse][/b][/color]",
		0,
		0,
		0,
		true
	),
	"BANK_HEISTS" : Skill.new(
		"BANK_HEISTS",
		"Do a\nbank Heist",
		load("res://assets/icons/789_Lorc_RPG_icons/Icons8_32.png"),
		"Since the inhabitants discovered [color=#7fa3a3]electricity[/color], it led to the digitization of once-physical goods — including [color=#b37f7f]money[/color].\nUse this obviously flawed system and [pulse freq=1.5][b]move some money[/b][/pulse] into your [wave amp=12 freq=2]digital pockets[/wave].",
		0,
		3,
		30,
		false
	),
}
