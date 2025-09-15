extends PanelContainer

@onready var title_label: Label = %Title
@onready var jokers: Label = %JokersAmount
@onready var joker_progress: ProgressBar = %JokerProgress
#@onready var scammers: Label = %Scammers
#@onready var politicians: Label = %Politicians
#@onready var conspirators: Label = %Conspirators
#@onready var insiders: Label = %Insiders
@onready var popup_top_bar: BoxContainer = $MarginContainer/VBoxContainer/PopupTopBar


func _ready() -> void:
	popup_top_bar.connect("close_menu", self.close_menu)
	close_menu()

# called when the country is selected -> animation, loading data from the conspirators
func show_details(title : String, country_data) -> void:
	title_label.text = title.capitalize()
	if country_data != null:
		# Country Details can be null -> no characters addded to that region
		jokers.text = str(country_data["JOKER"].size())
	else:
		jokers.text = "/"
	self.show()

func reload_data(updated_country : String, country_data : Dictionary) -> void:
	if updated_country == Global.CURRENT_COUNTRY:
		# when the country data gets updated -> signal calls this function
		# if the menu shows data of updated country -> RELOAD VALUES
		show_details(updated_country, country_data)

func close_menu() -> void:
	Global.CURRENT_COUNTRY = ""
	self.hide()
