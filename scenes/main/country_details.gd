extends PanelContainer

@onready var title_label: Label = %CountryTopBar.bar_title
@onready var jokers: VBoxContainer = %Jokers
@onready var scammers: VBoxContainer = %Scammers
@onready var politicians: VBoxContainer = %Politicians
@onready var conspiracy_theorists: VBoxContainer = %ConspiracyTheorists
@onready var popup_top_bar: BoxContainer = %CountryTopBar
@onready var country_progress: VBoxContainer = %CountryProgress
@onready var poison_individual: Button = %PoisonIndividual

@onready var char_menus := [
	scammers,
	conspiracy_theorists,
	politicians,
]

func _ready() -> void:
	popup_top_bar.connect("close_menu", self.close_menu)
	close_menu()

# called when the country is selected -> animation, loading data from the conspirators
func show_details(title : String, country_data) -> void:
	title_label.text = title.to_upper()
	country_progress.init_progress()
	
	# Poisoned Individuals
	poison_individual.text = str(CountryData.get_poisoned_indivduals())
	
	# Country Details can be null -> no characters addded to that region
	jokers.update_count(
		country_data["JOKER"].size() if country_data else 0
	)
	
	# Hide/Show Characters deepending on unlock state/progreession
	for n in char_menus.size():
		var active : bool = CountryData.get_character_unlock() >= n
		char_menus[n].visible = active
		if active:
			# Update Character Data if unlocked
			if n == 2:
				# POLITICIAN
				char_menus[n].set_to_politican_mode()
	
	self.show()


func reload_data(updated_country : String, country_data : Dictionary) -> void:
	if updated_country == Global.CURRENT_COUNTRY:
		# when the country data gets updated -> signal calls this function
		# if the menu shows data of updated country -> RELOAD VALUES
		show_details(updated_country, country_data)

func close_menu() -> void:
	self.hide()
	Global.unselect_country()


func _on_machine_tasks_politician_bribe_valid() -> void:
	politicians.get_next_bribe()


func _on_poison_individual_pressed() -> void:
	CountryData.increment_poisoned_individuals()
	poison_individual.text  = str(CountryData.get_poisoned_indivduals())
