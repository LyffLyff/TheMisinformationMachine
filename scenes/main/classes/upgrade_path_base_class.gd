extends  PanelContainer
class_name UpgradeMenuBase

const SKILL_BUTTON = preload("res://scenes/main/upgrades/skill_button.tscn")

@onready var skill_container: HBoxContainer = %SkillContainer

func _on_popup_top_bar_close_menu() -> void:
	self.queue_free()
