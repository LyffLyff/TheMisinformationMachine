extends  PanelContainer
class_name UpgradeMenuBase

signal upgrade_started

const SKILL_BUTTON = preload("res://scenes/main/upgrades/skill_button.tscn")

@onready var skill_container: HBoxContainer = %SkillContainer
