extends PanelContainer

@onready var top_bar: VBoxContainer = %TopBar
@onready var population_label: Label = %PopulationLabel
@onready var median_age_label: Label = %MedianAgeLabel
@onready var size_label: Label = %SizeLabel
@onready var corruption_index_label: Label = %CorruptionIndexLabel
@onready var gdp_label: Label = %GDPLabel


func init_country_info(country_title : String, country_data : Dictionary) -> void:
	top_bar.bar_title.text = Global.get_normalized_country_name(country_title)
	
	# Population → Cyan shades
	population_label.text = Global.format_big_number(country_data["population"])[0] + " " + Global.format_big_number(country_data["population"])[1]

	# Median age → Purple shades
	median_age_label.text = Global.format_big_number(country_data["median_age"])[0] + " " +  Global.format_big_number(country_data["median_age"])[1]

	# Size → Blue shades
	size_label.text = Global.format_big_number(country_data["size"])[0] + " " + Global.format_big_number(country_data["size"])[1] + "m2"

	# Corruption → Red (bad) to Green (good)
	corruption_index_label.text = "%0.2f" % country_data["corruption"]
	
	# GDP in Billion USD
	gdp_label.text = "%0.2f Billion USD" % country_data["gdp_billions_usd"]


func _on_top_bar_close_menu() -> void:
	self.queue_free()

# Utility: pick color from gradient based on min/max
func get_value_color(value: float, range: Array, colors: Array) -> String:
	var min_val: float = range[0]
	var max_val: float = range[1]
	var t: float = clamp((value - min_val) / (max_val - min_val), 0.0, 1.0)

	# Lerp between two hex colors
	return lerp_color(colors[0], colors[1], t)

func lerp_color(hex1: String, hex2: String, t: float) -> String:
	var c1: Color = Color(hex1)
	var c2: Color = Color(hex2)
	var c: Color = c1.lerp(c2, t)
	return "#" + c.to_html(false)  # return hex
