extends PanelContainer

@onready var skill_info: RichTextLabel = %SkillInfo

func init_skill(skill_data : Skill) -> void:
	skill_info.text = skill_data.description
