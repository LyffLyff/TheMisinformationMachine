extends PanelContainer

@onready var description_label: RichTextLabel = %DescriptionLabel
@onready var unlock: Button = %Unlock
@onready var skill_title_label: RichTextLabel = %SkillTitleLabel
@onready var texture_button: TextureRect = %TextureButton
@onready var skill_points_label: Label = %SkillPointsLabel
@onready var money_label: Label = %MoneyLabel
@onready var time_label: Label = %TimeLabel


func init_skill(skill_data : Skill) -> void:
	# UNLOCK BUTTON
	unlock.connect("pressed", Global.unlock_skill.bind(skill_data))
	unlock.text = "UNLOCK  FOR:\n%d POINTS" % skill_data.skill_point_cost
	
	# TITLE & DESCRIPTION
	skill_title_label.text = skill_data.name
	description_label.text = skill_data.description
	
	# ICON
	texture_button.texture = skill_data.icon
	
	# UNLCOK REQUIREMENTS
	skill_points_label.text = "SKILL POINTS: %d" % skill_data.skill_point_cost 
	money_label.text = "MONEY: %s" % str(skill_data.money_cost).pad_decimals(0)
	time_label.text = "UNLOCK TIME: %d" % skill_data.time_cost 
	
	if Global.UNLOCKED_SKILLS.has(skill_data.identifier):
		if !skill_data.repeatable_unlock:
			self.modulate.a = 0.5
			unlock.disabled = true
		else:
			pass
