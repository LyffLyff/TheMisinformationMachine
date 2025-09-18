extends PanelContainer


@onready var skill_info: RichTextLabel = %SkillInfo
@onready var unlock: Button = %Unlock
@onready var skill_title_label: Label = %SkillTitleLabel
@onready var texture_button: TextureRect = %TextureButton

func init_skill(skill_data : Skill) -> void:
	unlock.connect("pressed", Global.unlock_skill.bind(skill_data))
	skill_title_label.text = skill_data.name
	skill_info.text = skill_data.description
	texture_button.texture = skill_data.icon
