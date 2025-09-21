extends Node2D

# Bounding box for coordinate conversion
var min_lat = 90.1
var max_lat = -90.1
var min_long = 180.1
var max_long = -180.1

# Screen dimensions for mapping
var screen_width = 1024
var screen_height = 768

func _ready():
	var geojson_data = load_geojson("res://world-geojson-develop/countries/" +  "russia_alt.json")
	if geojson_data:
		create_polygons_from_geojson(geojson_data)


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
		printerr("JSON Parse Error: ", json.get_error_message())
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
		elif feature.geometry.type == "MultiPolygon":
			for polygon in feature.geometry.coordinates:
				for ring in polygon:
					for coord in ring:
						update_bounds(coord[0], coord[1])

func update_bounds(lon: float, lat: float):
	if lat < min_lat: min_lat = lat
	if lat > max_lat: max_lat = lat
	if lon < min_long: min_long = lon
	if lon > max_long: max_long = lon

func lat_lon_to_screen(longitude: float, latitude: float) -> Vector2:
	# Assuming you have screen dimensions and world bounds
	var screen_width = get_viewport().get_visible_rect().size.x
	var screen_height = get_viewport().get_visible_rect().size.y
	
	# Convert longitude to X (this is usually correct)
	var x = (longitude - min_long) / (max_long - min_long) * screen_width
	
	# Convert latitude to Y - THIS IS THE KEY FIX
	# Flip the Y coordinate by subtracting from screen_height
	var y = screen_height - ((latitude - min_lat) / (max_lat - min_lat) * screen_height)
	
	return -Vector2(x, y)

func create_polygons_from_geojson(geojson_data):
	# Second pass: create polygons
	for feature in geojson_data.features:
		if feature.geometry.type == "Polygon":
			self.add_child(create_single_polygon(feature.geometry.coordinates))
		elif feature.geometry.type == "MultiPolygon":
			for polygon_coords in feature.geometry.coordinates:
				self.add_child(create_single_polygon(polygon_coords))
		else:
			print("DIFF", feature.geometry.type)
			breakpoint

func create_single_polygon(polygon_coords) -> Node2D:
	# Create a container for this polygon and its outline
	var polygon_container = Node2D.new()
	
	# Create the main Polygon2D
	var area = Area2D.new()
	var collision_shape = CollisionPolygon2D.new()
	var polygon2d = Polygon2D.new()
	area.add_child(polygon2d)
	
	# Get the exterior ring (first ring in the array)
	var exterior_ring = polygon_coords[0]
	var points = PackedVector2Array()
	
	# Convert coordinates to screen space
	for coord in exterior_ring:
		var screen_pos = lat_lon_to_screen(coord[0], coord[1])
		points.append(screen_pos)
	
	# Set the polygon points
	polygon2d.polygon = points
	collision_shape.polygon = points
	
	# Optional: Set some visual properties
	polygon2d.color = Color.BROWN  # Light blue with transparency
	polygon2d.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	# Add to container
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
		hole_line.default_color = Color.RED
		add_child(hole_line)

# Alternative function for creating a single merged polygon if you want all features combined
func create_merged_polygon(geojson_data) -> Polygon2D:
	extract_bounds(geojson_data)
	
	var all_points = PackedVector2Array()
	
	for feature in geojson_data.features:
		if feature.geometry.type == "Polygon":
			var exterior_ring = feature.geometry.coordinates[0]
			for coord in exterior_ring:
				var screen_pos = lat_lon_to_screen(coord[0], coord[1])
				all_points.append(screen_pos)
		elif feature.geometry.type == "MultiPolygon":
			for polygon_coords in feature.geometry.coordinates:
				var exterior_ring = polygon_coords[0]
				for coord in exterior_ring:
					var screen_pos = lat_lon_to_screen(coord[0], coord[1])
					all_points.append(screen_pos)
	
	var polygon2d = Polygon2D.new()
	polygon2d.polygon = all_points
	polygon2d.color = Color(0.2, 0.6, 0.8, 0.7)
	
	add_child(polygon2d)
	return polygon2d
