extends PanelContainer

@onready var country_data_label: RichTextLabel = %CountryData
@onready var top_bar: VBoxContainer = %TopBar

func init_country_info(country_title : String, country_data : Dictionary) -> void:
	top_bar.bar_title.text = country_title.to_upper()
	country_data_label.text = str(country_data)

func _on_top_bar_close_menu() -> void:
	self.queue_free()
