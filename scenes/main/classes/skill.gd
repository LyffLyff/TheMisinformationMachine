extends RefCounted
class_name Skill

var name : String = "SkillName"

var description : String = "Description"

var money_cost : int = 10000

var skill_point_cost : int = 1

var time_cost : int = 10

# function that will be called to do the actual effect mentioned in the description
var on_skill_function : Callable

var repeatable_unlock : bool = false


func _init(
	i_name : String,  
	i_decription : String, 
	m_cost : int, 
	s_cost : int, 
	t_cost : int, 
	call_func : Callable,
	repeatable : bool = false
) -> void:
	name = i_name
	description = i_decription
	money_cost = m_cost
	skill_point_cost = s_cost
	time_cost = t_cost
	on_skill_function = call_func
	repeatable_unlock = repeatable
