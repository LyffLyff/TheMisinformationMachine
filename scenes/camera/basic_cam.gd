extends Camera2D

# Camera movement settings
@export var pan_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 1.0
@export var max_zoom: float = 15.0

# Map bounds (adjust these to your actual map size)
@export var map_bounds: Rect2 = Rect2(-400, -300, 2800, 1500)

# Internal variables
var is_dragging: bool = false
var last_mouse_pos: Vector2
var viewport_size: Vector2
var pos_tw : Tween

func _ready():
	# Enable camera
	enabled = true
	viewport_size = get_viewport().get_visible_rect().size

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in(event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out(event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag(event.position)
			else:
				stop_drag()
	
	# Handle mouse motion for panning
	elif event is InputEventMouseMotion and is_dragging:
		pan_camera(event.position)

func start_drag(mouse_pos: Vector2):
	is_dragging = true
	last_mouse_pos = mouse_pos

func stop_drag():
	is_dragging = false

func pan_camera(mouse_pos: Vector2):
	# Convert screen space delta to world space
	var screen_delta = last_mouse_pos - mouse_pos
	var world_delta = screen_delta / zoom
	
	var new_pos = global_position + world_delta
	
	# Apply zoom-aware limits
	new_pos = clamp_camera_position(new_pos)
	
	#pos_tw = create_tween().set_ignore_time_scale(true)
	#pos_tw.tween_property(
	#	self,
	#	"global_position",
	#	new_pos,
	#	0.1
	#).set_ease(Tween.EASE_OUT)
	global_position = new_pos
	last_mouse_pos = mouse_pos  # Simply update to current mouse position

func zoom_in(mouse_position: Vector2 = Vector2.ZERO):
	zoom_at_point(1.0 + zoom_speed, mouse_position)

func zoom_out(mouse_position: Vector2 = Vector2.ZERO):
	zoom_at_point(1.0 - zoom_speed, mouse_position)

func zoom_at_point(zoom_factor: float, screen_point: Vector2 = Vector2.ZERO):
	# If no point specified, zoom at screen center
	if screen_point == Vector2.ZERO:
		screen_point = viewport_size * 0.5
	
	# Convert screen point to world coordinates before zoom
	var world_point = to_global(to_local(screen_point))
	
	# Calculate new zoom
	var new_zoom = zoom * zoom_factor
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	# Calculate how much the world point moves due to zoom change
	var zoom_center = global_position
	var offset_before = world_point - zoom_center
	
	# Apply zoom
	zoom = new_zoom
	
	# Calculate new position to keep the world point under the cursor
	var offset_after = offset_before
	var new_position = world_point - offset_after
	
	# Apply limits
	global_position = clamp_camera_position(new_position)

func clamp_camera_position(pos: Vector2) -> Vector2:
	# Calculate how much of the world we can see at current zoom
	var view_size = viewport_size / zoom
	var half_view = view_size * 0.5
	
	# Calculate the limits based on map bounds and current view size
	var min_x = map_bounds.position.x + half_view.x
	var max_x = map_bounds.position.x + map_bounds.size.x - half_view.x
	var min_y = map_bounds.position.y + half_view.y
	var max_y = map_bounds.position.y + map_bounds.size.y - half_view.y
	
	# If the view is larger than the map, center on the map
	if view_size.x >= map_bounds.size.x:
		pos.x = map_bounds.position.x + map_bounds.size.x * 0.5
	else:
		pos.x = clamp(pos.x, min_x, max_x)
	
	if view_size.y >= map_bounds.size.y:
		pos.y = map_bounds.position.y + map_bounds.size.y * 0.5
	else:
		pos.y = clamp(pos.y, min_y, max_y)
	
	return pos

func zoom_into_position(dst_pos: Vector2 = get_global_mouse_position()) -> void:
	# Stop any current dragging to prevent conflicts
	is_dragging = false
	
	var target_zoom = Vector2(3, 3)
	var duration = calculate_zoom_duration(dst_pos, target_zoom)
	
	# Clamp the destination position with the target zoom in mind
	var temp_zoom = zoom
	zoom = target_zoom
	dst_pos = clamp_camera_position(dst_pos)
	zoom = temp_zoom
	
	var tween := create_tween().set_ignore_time_scale()
	
	tween.tween_property(
		self,
		"zoom",
		target_zoom,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(
		self,
		"global_position",
		dst_pos,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Ensure dragging state is reset after tween
	tween.tween_callback(func(): is_dragging = false)


func calculate_zoom_duration(target_pos: Vector2, target_zoom: Vector2) -> float:
	# Base duration settings
	var base_duration = 0.3
	var max_duration = 1.0
	var min_duration = 0.2
	
	# Calculate distance factor (0.0 to 1.0)
	var distance = global_position.distance_to(target_pos)
	var max_expected_distance = 2000.0  # Adjust based on your map size
	var distance_factor = clamp(distance / max_expected_distance, 0.0, 1.0)
	
	# Calculate zoom factor (0.0 to 1.0)
	var zoom_change = abs(zoom.x - target_zoom.x)
	var max_zoom_change = max_zoom - min_zoom
	var zoom_factor = clamp(zoom_change / max_zoom_change, 0.0, 1.0)
	
	# Combine factors - use the larger of distance or zoom change
	var combined_factor = max(distance_factor, zoom_factor)
	
	# Calculate final duration
	var duration = base_duration + (combined_factor * (max_duration - base_duration))
	return clamp(duration, min_duration, max_duration)


func set_map_bounds(bounds: Rect2):
	map_bounds = bounds

# Optional: Smooth zoom with mouse wheel
func _input(event):
	if event is InputEventMouseButton:
		# Update viewport size if window was resized
		viewport_size = get_viewport().get_visible_rect().size
	if Input.is_action_just_pressed("reset_camera"):
		#self.global_position = Vector2(1000, 450)
		pan_camera(Vector2(1000, 450))
