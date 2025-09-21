extends PanelContainer

const SINGLE_COUNTRY_PROGRESSION = preload("uid://l2ai2yvi7lq0")

@onready var progress_container: VBoxContainer = %ProgressContainer

func _ready() -> void:
	for n in CountryData.COUNTRY_DETAILS.keys():
		var menu := SINGLE_COUNTRY_PROGRESSION.instantiate()
		menu.get_child(0).text = Global.get_normalized_country_name(n)
		menu.name = n
		progress_container.add_child(menu)


func _on_timer_timeout() -> void:
	for n in progress_container.get_children():
		n.get_node("Progression").value = CountryData.get_total_progression_per_country(n.name)
