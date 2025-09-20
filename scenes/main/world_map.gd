extends PausingHandler

const GENERAL_COUNTRY_INFO = preload("res://scenes/ui/general_country_info.tscn")

const COUNTRY_DATA_FOLDER := "res://geodata/countries_simplified/"
const COUNTRY_FOCUS_CLR := Color.CRIMSON
const COUNTRY_HIGHLIGHT_CLR := Color.DARK_SLATE_GRAY
const COUNTRY_PROGRESSION_STARTED :=  Color.DARK_GREEN
const COUNTRY_PROGRESSION_COLORS : PackedColorArray = [
	Color.FOREST_GREEN,
	Color(0.89, 0.691, 0.352, 1.0),
	Color.CORAL,
	Color.REBECCA_PURPLE,
	Color.FIREBRICK
]

@onready var camera_2d: Camera2D = $Camera2D
@onready var machine_tasks: PanelContainer = %MachineTasks
@onready var country_details: PanelContainer = %CountryDetails
@onready var money_display: VBoxContainer = %MoneyDisplay

signal map_loaded
signal country_entered
signal country_exited
signal country_selected
signal country_single_clicked

# Bounding box for coordinate conversion
var min_lat = 90.0
var max_lat = -90.0
var min_long = 200.0
var max_long = -200.0

# Screen dimensions for mapping
var screen_width = 1920
var screen_height = 1080

var country_container : Node2D
@onready var outline_container: Node2D = %OutlineContainer
var hover_polygon: Polygon2D = null
var hover_polygon_name :  String = ""
var premade_outlines : Dictionary[String, Array] = {
	# Country : Array of Line2D
}		# to fix stutter on  selection each time

func _ready():
	self.connect("map_loaded", Transition.fade_in, CONNECT_ONE_SHOT)
	
	# Signals
	self.connect("country_selected", camera_2d.zoom_into_position)
	self.connect("country_data_updated", country_details.reload_data)
	self.connect("country_single_clicked", ui.load_general_country_info)
	self.connect("finances_changed", money_display.update_values)
	CountryData.connect("update_calculations", self.update_calculations)
	CountryData.connect("character_unlocked", self.change_country_visuals)
	CountryData.connect("country_converted", self.change_country_visuals.bind(4))
	
	machine_tasks.connect("character_created", self.new_character_created)
	
	var start_time := Time.get_unix_time_from_system()
	# Country Container
	country_container = Node2D.new()
	self.add_child(country_container)
	country_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# Load the Areas of all countries on earth (sept. 2025)
	for country_file in get_all_files_from_folder(COUNTRY_DATA_FOLDER):
		var geojson_data = load_geojson(COUNTRY_DATA_FOLDER + country_file)
		if geojson_data:
			create_polygons_from_geojson(geojson_data, country_file.get_file().get_basename())
	
	var load_time := Time.get_unix_time_from_system() - start_time
	print("World Loaded In: %s seconds" % load_time)
	emit_signal("map_loaded")


func get_all_files_from_folder(folder_path: String = COUNTRY_DATA_FOLDER) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		print("Error: Could not open directory: ", folder_path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		# Skip directories and hidden files
		if not dir.current_is_dir() and not file_name.begins_with("."):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return files


func load_all_countries_from_folder(folder_path: String):
	var dir = DirAccess.open(folder_path)
	if dir == null:
		print("Cannot open directory: ", folder_path)
		return
	
	print("Loading GeoJSON files from: ", folder_path)
	
	# Get all files in directory
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".geojson") or file_name.ends_with(".json"):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	print("Found ", files.size(), " GeoJSON files")


func load_geojson(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Cannot open file: ", file_path)
		return null
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(json_string)
	
	if result != OK:
		print("JSON Parse Error: ", json.get_error_message())
		return null
	
	return json.data

func create_polygons_from_geojson(geojson_data, country):
	# Second pass: create polygons
	var new_country : Node = Node2D.new()
	country_container.add_child(new_country)
	for feature in geojson_data.features:
		if feature.geometry == null:
			continue
		if feature.geometry.type == "Polygon":
			var part_of_country := create_single_polygon(feature.geometry.coordinates, country)
			new_country.add_child(part_of_country)
		else:
			printerr("Unexpected Geometry Type -> ", feature.geometry.type)


func create_single_polygon(polygon_coords, country_title : String) -> Node2D:
	# Create a container for this polygon and its outline
	var polygon_container = Node2D.new()
	
	# Create the main Polygon2D
	var area :  Area2D = Area2D.new()
	var collision_shape = CollisionPolygon2D.new()
	area.add_child(collision_shape)
	var polygon2d = Polygon2D.new()
	area.add_child(polygon2d)
	area.add_to_group(country_title) # to group islands & mainland
	
	# Get the exterior ring (first ring in the array)
	var exterior_ring = polygon_coords[0]
	var points = PackedVector2Array()
	
	# Convert coordinates to screen space
	for coord in exterior_ring:
		var screen_pos : Vector2 = lat_lon_to_screen(coord[0], coord[1])
		points.append(screen_pos)
	
	polygon2d.polygon = points
	polygon2d.antialiased = true
	collision_shape.polygon = points
	
	# Optional: Set some visual properties
	polygon2d.color = COUNTRY_PROGRESSION_COLORS[0]  # intial color
	polygon2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	
	# PreMake Outlines -> load later
	var line = Line2D.new()
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.antialiased = true
	line.width = 1  # outline thickness
	line.default_color = Color.GHOST_WHITE
	line.points = points
	#line.add_point(polygon2d.polygon[0])  # close polygon
	outline_container.add_child(line)
	if !premade_outlines.has(country_title):
		premade_outlines[country_title] = [line]
	else:
		premade_outlines[country_title].append(line)
	line.hide()
	
	# Add to container
	area.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(country_title))
	area.connect("mouse_exited", Callable(self, "_on_mouse_exited").bind(country_title))
	area.connect("input_event", Callable(self, "_on_input_event").bind(country_title))
	polygon_container.add_child(area)
	
	# Handle holes (interior rings) if they exist
	if polygon_coords.size() > 1:
		create_polygon_holes(polygon_container, polygon_coords)
	
	return polygon_container


func create_polygon_holes(parent_polygon, polygon_coords):
	# Create holes by subtracting interior rings from the main polygon
	# This is more complex and might require using different approaches
	# For now, we'll just outline the holes
	
	for i in range(1, polygon_coords.size()):
		var hole_ring = polygon_coords[i]
		var hole_line = Line2D.new()
		
		for coord in hole_ring:
			var screen_pos = lat_lon_to_screen(coord[0], coord[1])
			hole_line.add_point(screen_pos)
		hole_line.add_point(lat_lon_to_screen(hole_ring[0][0], hole_ring[0][1]))  # Close
		
		hole_line.width = 1.5
		hole_line.default_color = COUNTRY_PROGRESSION_COLORS[0]
		add_child(hole_line)


func lat_lon_to_screen(longitude: float, latitude: float) -> Vector2:
	# Convert longitude to X (this is usually correct)
	var x = (longitude - min_long) / (max_long - min_long) * DisplayServer.window_get_size().x
	
	var y = screen_height - ((latitude - min_lat) / (max_lat - min_lat) * DisplayServer.window_get_size().y)
	
	# -> the minus cause it was flipped + an offset to center it on screen
	return -Vector2(x, y) + Vector2(DisplayServer.window_get_size())

func fix_russia(points: PackedVector2Array, step: int) -> PackedVector2Array:
	# removes every nth point -> only cause russia cant be rendered in full size
	var new_points := PackedVector2Array()
	for i in range(0, points.size(), step):
		new_points.append(points[i])
	return new_points

func highlight_polygon(country_name: String) -> void:
	_unselect_country()
	
	Global.CURRENT_COUNTRY = country_name
	
	for outline in premade_outlines.get(country_name):
		outline.show() #show outline
	for n in get_tree().get_nodes_in_group(country_name):
		n.get_child(1).color = COUNTRY_HIGHLIGHT_CLR


#### INPUT ####
func _on_input_event(viewport, event, shape_idx, polygon_name : String):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.double_click:
					print("Double clicked at:", event.position, polygon_name)
					
					#ZOOM INTO THAT POSITION
					emit_signal("country_selected")
					GlobalSoundPlayer.play_selected_sound()
					
					# COUNTRY DATA INITIALLZE COUNTRY
					CountryData.init_country(polygon_name)
					
					# HIGHLIGHT POLYGON OF COUNTRY
					highlight_polygon(polygon_name)
					
					ui.show_country_menu(polygon_name, CountryData.character_data_per_country.get(polygon_name, null))
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				print("Polygon right-clicked at:", event.position, polygon_name)
				emit_signal("country_single_clicked", polygon_name)

func _on_mouse_entered(country_name : String):
	for n in get_tree().get_nodes_in_group(country_name):
		hover_polygon = n.get_child(1)
		hover_polygon_name = country_name
		if Global.CURRENT_COUNTRY != country_name:
			# only show hover highlight clr if not selected -> other color
			n.get_child(1).color = COUNTRY_FOCUS_CLR
	emit_signal("country_entered", country_name)

func _on_mouse_exited(country_name : String):
	for n in get_tree().get_nodes_in_group(country_name):
		if hover_polygon == n.get_child(1):
			hover_polygon = null
			hover_polygon_name = ""
		if Global.CURRENT_COUNTRY != country_name:
			# only go back to initial color if the country isn't currently selected
			var idx : int = CountryData.get_progression_idx(country_name)
			if idx == 0 and CountryData.has_progression_started(country_name):
				# highlight countries the  user has done sth/has agents
				n.get_child(1).color = COUNTRY_PROGRESSION_STARTED
			else:
				n.get_child(1).color = COUNTRY_PROGRESSION_COLORS[idx]
	emit_signal("country_exited", hover_polygon)

func _on_country_details_hidden() -> void:
	_unselect_country()

func _unselect_country() -> void:
	if Global.CURRENT_COUNTRY != "":
		# OUTLINE
		for n in premade_outlines.get(Global.CURRENT_COUNTRY):
			n.hide()
		
		# COLOR
		var color : Color
		var idx : int = CountryData.get_progression_idx(Global.CURRENT_COUNTRY)
		if idx == 0 and CountryData.has_progression_started(Global.CURRENT_COUNTRY):
			# highlight countries the  user has done sth/has agents
			color = COUNTRY_PROGRESSION_STARTED
		else:
			color = COUNTRY_PROGRESSION_COLORS[idx]
			
		for n in get_tree().get_nodes_in_group(Global.CURRENT_COUNTRY):
			# unhighlight country
			n.get_child(1).color = color

func change_country_visuals(country :  String, char_idx : int) -> void:
	CountryData.set_country_progression_idx(country, char_idx)
	if country != Global.CURRENT_COUNTRY:
		var new_country_clr := COUNTRY_PROGRESSION_COLORS[char_idx]
		for n in get_tree().get_nodes_in_group(Global.CURRENT_COUNTRY):
				# unhighlight country
				n.get_child(1).color = new_country_clr
