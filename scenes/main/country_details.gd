extends PanelContainer

@onready var title_label: Label = %CountryTopBar.bar_title
@onready var jokers: VBoxContainer = %Jokers
@onready var scammers: VBoxContainer = %Scammers
@onready var politicians: VBoxContainer = %Politicians
@onready var conspirators: VBoxContainer = %Conspirators
@onready var popup_top_bar: BoxContainer = %CountryTopBar
@onready var country_progress: VBoxContainer = %CountryProgress
@onready var poison_individual: Button = %PoisonIndividual

@onready var char_menus := [
	jokers,
	scammers,
	conspirators,
	politicians,
]

func _ready() -> void:
	popup_top_bar.connect("close_menu", self.close_menu)
	close_menu()

# called when the country is selected -> animation, loading data from the conspirators
func show_details(title : String) -> void:
	title_label.text = title.to_upper()
	country_progress.init_progress()
	
	# Poisoned Individuals
	poison_individual.text = "POISON SPECIMEN"
	
	
	# Hide/Show Characters deepending on unlock state/progreession
	for n in char_menus.size():
		char_menus[n].init_character_box(Global.class_costs.keys()[n])
		var active : bool = true
		#var active : bool = CountryData.get_character_unlock() >= n
		char_menus[n].visible = active
		if active:
			# Update Character Data if unlocked
			if n == 3:
				# POLITICIAN
				char_menus[n].set_to_politican_mode()
	
	self.show()


func reload_data(updated_country : String, country_data : Dictionary) -> void:
	if updated_country == Global.CURRENT_COUNTRY:
		# when the country data gets updated -> signal calls this function
		# if the menu shows data of updated country -> RELOAD VALUES
		show_details(updated_country)

func close_menu() -> void:
	self.hide()
	Global.unselect_country()


func _on_machine_tasks_politician_bribe_valid() -> void:
	politicians.get_next_bribe()


func _on_poison_individual_pressed() -> void:
	CountryData.increment_static_lost_specimen()
