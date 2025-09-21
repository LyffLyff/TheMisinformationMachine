extends PanelContainer

@onready var country_data_label: RichTextLabel = %CountryData
@onready var top_bar: VBoxContainer = %TopBar

func init_country_info(country_title : String, country_data : Dictionary) -> void:
	top_bar.bar_title.text = country_title.to_upper()
	
	# Display Country Data
	country_data_label.clear()
	
	# Population → Cyan shades
	var pop: int = country_data["population"]
	var pop_color: String = get_value_color(pop, [1_000_000, 10_000_000], ["#66ffff", "#009999"])
	country_data_label.append_text("[b]Population:[/b] [color=%s]%d[/color]\n" % [pop_color, pop])

	# Median age → Purple shades
	var age: float = country_data["median_age"]
	var age_color: String = get_value_color(age, [20, 60], ["#cc99ff", "#6600cc"])
	country_data_label.append_text("[b]Median Age:[/b] [color=%s]%.1f[/color]\n" % [age_color, age])

	# Size → Blue shades
	var size: float = country_data["size"]
	var size_color: String = get_value_color(size, [10_000, 1_000_000], ["#99ccff", "#003366"])
	country_data_label.append_text("[b]Size:[/b] [color=%s]%.1f km²[/color]\n" % [size_color, size])

	# Corruption → Red (bad) to Green (good)
	var corruption: float = country_data["corruption"]
	var corruption_color: String = get_value_color(corruption, [0.0, 1.0], ["#ff6666", "#66ff66"])
	country_data_label.append_text("[b]Corruption:[/b] [color=%s]%.2f[/color]\n" % [corruption_color, corruption])


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
