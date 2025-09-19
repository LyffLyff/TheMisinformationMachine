extends PanelContainer

const CORE_TASK = preload("res://scenes/main/MachineTask/core_task.tscn")
const IDLE_CORE = preload("res://scenes/main/MachineTask/idle_core.tscn")

@onready var busy_core_container: VBoxContainer = %BusyCores
@onready var idle_core_container: VBoxContainer = %IdleCores
@onready var cores_amount: Label = %CoresAmount

const STARTING_CORES : int = 3

signal character_created
signal politician_bribe_valid

var total_cores : int = STARTING_CORES
var busy_cores  : int = 0

func _ready() -> void:
	# Init Menu Data
	_update_cores_amount(total_cores)
	_init_idle_cores()
	
	# Connect to Skill Unlock
	Global.connect("start_skill_task", self.start_skill_task)

func _update_cores_amount(new_amount : int) -> void:
	# Called when updating the total amount of Cores -> Upgrade
	cores_amount.text = str(new_amount)

func _init_idle_cores() -> void:
	for n in _get_available_cores():
		idle_core_container.add_child(IDLE_CORE.instantiate())

func _start_idling_core() -> void:
	# called when a core task finishes
	busy_cores -= 1
	var idle_core := IDLE_CORE.instantiate()
	# counts as static since it varies in amount each time
	idle_core.connect("money_mined", Global.get_game_base().add_static_money)
	idle_core_container.add_child(idle_core)

func _remove_idle_core() -> void:
	# removes the last idle core
	idle_core_container.get_children().pop_back().delete_idle_core()

func core_upgrade(extra_cores : int) -> void:
	total_cores += extra_cores

func _get_available_cores() -> int:
	return total_cores - busy_cores

func start_new_task(task_title : String, type : Global.TASK_TYPES, money_cost : int, time_cost : int, extra_values : Array = []) -> void:
	if _get_available_cores() > 0:
		busy_cores += 1
		var new_task := CORE_TASK.instantiate()
		busy_core_container.add_child(new_task)
		##TODO -> ADD PRICE after finishing this taks
		##TODO -> REDUCE MONEY COST FROM THE MONEY AMOUNT AVAILABLE
		new_task._init_task(task_title, time_cost, false)
		new_task.connect("task_finished", Callable(_machine_task_completed).bind(type, Global.CURRENT_COUNTRY, extra_values))
		new_task.connect("task_finished", self._start_idling_core)
		_remove_idle_core()
	else:
		printerr("NO MORE CORES AVAILABLE")


func start_skill_task(new_skill : Skill) -> void:
	if _get_available_cores() > 0:
		busy_cores += 1
		var new_task := CORE_TASK.instantiate()
		busy_core_container.add_child(new_task)
		new_task._init_task(new_skill.name, new_skill.time_cost, true)
		new_task.connect("task_finished", Global.skill_unlocked.bind(new_skill.identifier))
		new_task.connect("task_finished", self._start_idling_core)
		_remove_idle_core()
	else:
		printerr("NO MORE CORES AVAILABLE")


func _machine_task_completed(type : Global.TASK_TYPES, country : String, extra_values : Array = []) -> void:
	#  cannot take the Global country since the Country could be changed during the task completion time
	match type:
		Global.TASK_TYPES.CHARACTER_CREATION:
			emit_signal("character_created", extra_values[0], country)
		_:
			printerr("INVALID TAKS TYPE")


func _on_jokers_button_pressed() -> void:
	const CLASS_TITLE : String = "JOKER"
	start_new_task(
		"Joker Creation",
		Global.TASK_TYPES.CHARACTER_CREATION, 
		0,										# free
		Global.class_costs[CLASS_TITLE],		# time
		[CLASS_TITLE]							# sends class title as extra_values[0]
	)


func _on_scammers_button_pressed() -> void:
	const CLASS_TITLE : String = "SCAMMER"
	start_new_task(
		"Educating New Scammers",
		Global.TASK_TYPES.CHARACTER_CREATION, 
		0,										# free
		Global.class_costs[CLASS_TITLE],		# time
		[CLASS_TITLE]							# sends class title as extra_values[0]
	)


func _on_conspiracy_theorists_button_pressed() -> void:
	const CLASS_TITLE : String = "CONSPIRATOR"
	start_new_task(
		"Generate & Distribute\nConspiracy Theory",
		Global.TASK_TYPES.CHARACTER_CREATION, 
		0,										# free
		Global.class_costs[CLASS_TITLE],		# time
		[CLASS_TITLE]							# sends class title as extra_values[0]
	)
