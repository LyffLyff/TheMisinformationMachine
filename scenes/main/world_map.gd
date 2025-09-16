extends PausingHandler

const GENERAL_COUNTRY_INFO = preload("res://scenes/ui/general_country_info.tscn")

const COUNTRY_DATA_FOLDER := "res://geodata/countries/"
const COUNTRY_FOCUS_CLR := Color.CRIMSON
const COUNTRY_HIGHLIGHT_CLR := Color.DARK_GREEN
const COUNTRY_CLR := Color.FOREST_GREEN

@onready var camera_2d: Camera2D = $Camera2D
@onready var machine_tasks: PanelContainer = %MachineTasks
@onready var country_details: PanelContainer = %CountryDetails

signal country_entered
signal country_exited
signal country_selected
signal country_single_clicked

# Bounding box for coordinate conversion
var min_lat = 90.0
var max_lat = -90.0
var min_long = 180.0
var max_long = -180.0

# Screen dimensions for mapping
var screen_width = 1920
var screen_height = 1080

var country_container : Node2D


func _ready():
	# BaseGameClass Ready
	specimen_timer = Timer.new()
	self.add_child(specimen_timer)
	specimen_timer.connect("timeout", self.on_specimen_timer_timeout)
	
	# Signals
	self.connect("country_selected", camera_2d.zoom_into_position)
	self.connect("country_data_updated", country_details.reload_data)
	self.connect("country_single_clicked", ui.load_general_country_info)
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

func extract_bounds(geojson_data):
	# Reset bounds
	min_lat = 90.0
	max_lat = -90.0
	min_long = 180.0
	max_long = -180.0
	
	for feature in geojson_data.features:
		if feature.geometry.type == "Polygon":
			for ring in feature.geometry.coordinates:
				for coord in ring:
					update_bounds(coord[0], coord[1])

func update_bounds(lon: float, lat: float):
	if lat < min_lat: min_lat = lat
	if lat > max_lat: max_lat = lat
	if lon < min_long: min_long = lon
	if lon > max_long: max_long = lon


func create_polygons_from_geojson(geojson_data, country):
	# Second pass: create polygons
	var new_country : Node = Node2D.new()
	country_container.add_child(new_country)
	for feature in geojson_data.features:
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
	
	# Set the polygon points
	if country_title == "russia":
		points = fix_russia(points, 280)
	else:
		# for now just to fasten the debug times -> loads the map faster
		points = fix_russia(points, 10)
	points = clean_geojson_polygon(points)
	polygon2d.polygon = points
	cache_leftmost(polygon2d)
	cache_rightmost(polygon2d)
	polygon2d.antialiased = true
	collision_shape.polygon = points
	
	# Optional: Set some visual properties
	polygon2d.color = COUNTRY_CLR  # Light blue with transparency
	polygon2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
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
		hole_line.default_color = Color.FOREST_GREEN
		add_child(hole_line)


func clean_geojson_polygon(points: Array) -> PackedVector2Array:
	var cleaned := PackedVector2Array(points)
	if cleaned.size() > 1 and cleaned[0] == cleaned[-1]:
		cleaned.remove_at(cleaned.size() - 1)  # drop duplicate
	return cleaned

func lat_lon_to_screen(longitude: float, latitude: float) -> Vector2:
	# Assuming you have screen dimensions and world bounds
	var screen_width = get_viewport().get_visible_rect().size.x
	var screen_height = get_viewport().get_visible_rect().size.y
	
	# Convert longitude to X (this is usually correct)
	var x = (longitude - min_long) / (max_long - min_long) * screen_width
	
	# Convert latitude to Y - THIS IS THE KEY FIX
	# Flip the Y coordinate by subtracting from screen_height
	var y = screen_height - ((latitude - min_lat) / (max_lat - min_lat) * screen_height)
	
	return -Vector2(x, y) + Vector2(DisplayServer.window_get_size())

func fix_russia(points: PackedVector2Array, step: int) -> PackedVector2Array:
	# removes every nth point -> only cause russia cant be rendered in full size
	var new_points := PackedVector2Array()
	for i in range(0, points.size(), step):
		new_points.append(points[i])
	return new_points


func highlight_polygon(country_name: String) -> void:
	# Get the group of nodes for the country
	var nodes = get_tree().get_nodes_in_group(country_name)
	
	for node in nodes:
		node.get_child(1).color = Color.CRIMSON


func _process(delta: float) -> void:
	var cam_x: float = camera_2d.global_position.x

	for country in country_container.get_children():
		for islands in country.get_children():
			var poly: Polygon2D = islands.get_child(0).get_child(1)

			var left: float = get_cached_leftmost_x(poly)
			var right: float = get_cached_rightmost_x(poly)

			# If polygon is too far left, push it right
			if right < cam_x - screen_width / 2.0:
				poly.position.x += screen_width

			# If polygon is too far right, push it left
			elif left > cam_x + screen_width / 2.0:
				poly.position.x -= screen_width



func cache_leftmost(poly: Polygon2D):
	var left_x = INF
	for p in poly.polygon:
		left_x = min(left_x, p.x)
	poly.set_meta("leftmost_local_x", left_x)

func get_cached_leftmost_x(poly: Polygon2D) -> float:
	var local_x: float = poly.get_meta("leftmost_local_x")
	return poly.to_global(Vector2(local_x, 0)).x


func cache_rightmost(poly: Polygon2D):
	var right_x = -INF
	for p in poly.polygon:
		right_x = max(right_x, p.x)
	poly.set_meta("rightmost_x_local", right_x)


func get_cached_rightmost_x(poly: Polygon2D) -> float:
	var local_x: float = poly.get_meta("rightmost_x_local")
	return poly.to_global(Vector2(local_x, 0)).x


#### INPUT ####
func _on_input_event(viewport, event, shape_idx, polygon_name : String):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.double_click:
				print("Double clicked at:", event.position, polygon_name)
				#ZOOM INTO THAT POSITION
				emit_signal("country_selected")
				
				# HIGHLIGHT POLYGON OF COUNTRY
				highlight_polygon(polygon_name)
				
				ui.show_country_menu(polygon_name, country_data.get(polygon_name, null))
			else:
				print("Polygon clicked at:", event.position, polygon_name)
				emit_signal("country_single_clicked", polygon_name)

func _on_mouse_entered(country_name : String):
	for n in get_tree().get_nodes_in_group(country_name):
		n.get_child(1).color = COUNTRY_FOCUS_CLR
	emit_signal("country_entered", country_name)

func _on_mouse_exited(country_name : String):
	for n in get_tree().get_nodes_in_group(country_name):
		n.get_child(1).color = COUNTRY_CLR
	emit_signal("country_exited")
