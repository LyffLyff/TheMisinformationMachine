extends RefCounted
class_name Skill

var name : String = "SkillName"
var identifier : String = ""

var description : String = "Description"

var icon : Texture2D

var money_cost : int = 10000

var skill_point_cost : int = 1

var time_cost : float = 10.0

# function that will be called to do the actual effect mentioned in the description
var on_skill_function : String

var repeatable_unlock : bool = false


func _init(
	unique_id : String,
	i_name : String,  
	skill_icon : Texture2D,
	i_decription : String, 
	m_cost : int, 
	s_cost : int, 
	t_cost : float, 
	call_func : String,
	repeatable : bool = false
) -> void:
	identifier = unique_id
	name = i_name
	icon = skill_icon
	description = i_decription
	money_cost = m_cost
	skill_point_cost = s_cost
	time_cost = t_cost
	on_skill_function = call_func
	repeatable_unlock = repeatable
