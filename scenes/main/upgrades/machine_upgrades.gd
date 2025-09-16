extends UpgradeMenuBase

func _ready() -> void:
	# INIT SKILLS
	for n in MACHINE_UPGRADES.size():
		var skill := SKILL_BUTTON.instantiate()
		skill_container.add_child(skill)
		skill.init_skill(MACHINE_UPGRADES.values()[n])

var MACHINE_UPGRADES : Dictionary = {
	"IDLE CORE BITCOIN MINER" : Skill.new(
		"Idle Core Bitcoin Miner",
		"In this  age and time, people have created this illusion  of a free and independent money system called BITCOIN. Mine them yourself by making use of your free idling cores",
		20,
		1,
		10,
		Callable(),
	),
	"INCREASE CPU-Cores" : Skill.new(
		"E-Waste CPUs",
		"While scrolling through the Web you found an Add for unused CPUs. You could buy them and expand your amount of cores.\nWatch out though prices are always fluctuating",
		randi_range(2, 200),
		0,
		10,
		Callable(),
		true
	),
	"OVERCLOCK" : Skill.new(
		"Overclock your cores",
		"These dumb inhabitants of this planet have limited power supplies to your CPUs to a few volts limiting your effectiveness. Why not increase that a bit?\n(WARNING: TOO MUCH INCREASE CAN FRY YOUR CORES AND KILL YOU)",
		0,
		0,
		0,
		Callable(),
		true
	),
	"DIGITAL BANK HEISTS" : Skill.new(
		"Do a bank Heist",
		"Since the inhabitants have discovered electricity, it lead to the increased digitization of once phyisical goods including money. Use this obviously flawed system and move some money into your digital pockets",
		0,
		100,
		4,
		Callable(),
		false
	),
}
