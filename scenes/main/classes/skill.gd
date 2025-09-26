extends RefCounted
class_name Skill

var name : String = "SkillName"
var identifier : String = ""

var description : String = "Description"

var icon : Texture2D

var money_cost : int = 0

var skill_point_cost : int = 0

var time_cost : float = 1.0

var repeatable_unlock : bool = false


func _init(
	unique_id : String,
	i_name : String,  
	skill_icon : Texture2D,
	i_decription : String, 
	m_cost : int, 
	s_cost : int, 
	t_cost : float, 
	repeatable : bool = false
) -> void:
	identifier = unique_id
	name = i_name
	icon = skill_icon
	description = i_decription
	money_cost = m_cost
	skill_point_cost = s_cost
	time_cost = t_cost
	repeatable_unlock = repeatable
