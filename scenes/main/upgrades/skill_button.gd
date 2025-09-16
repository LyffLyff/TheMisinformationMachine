extends PanelContainer

@onready var skill_info: RichTextLabel = %SkillInfo
@onready var unlock: Button = %Unlock

func init_skill(skill_data : Skill) -> void:
	unlock.connect("pressed", Global.unlock_skill.bind(skill_data))
	skill_info.text = skill_data.description
