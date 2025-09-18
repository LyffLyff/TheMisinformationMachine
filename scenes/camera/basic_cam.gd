extends Camera2D

# Camera movement settings
@export var pan_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 1.0
@export var max_zoom: float = 3.0

# Limits deifned myself since dragging kinda did funky things on the edges
var lim_bottom := DisplayServer.window_get_size().y * 0.7
var lim_top := DisplayServer.window_get_size().y * 0.2
var lim_right := DisplayServer.window_get_size().x * 0.7
var lim_left := DisplayServer.window_get_size().x * 0.3

# Internal variables
var is_dragging: bool = false
var last_mouse_pos: Vector2

func _ready():
	# Enable camera
	enabled = true


func _unhandled_input(event):	# unhandled input -> so when UI takes the input the camera doesn't do shit
	
	# Handle mouse wheel for zooming
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
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
	var delta = (last_mouse_pos - mouse_pos) * pan_speed / zoom
	var new_pos = global_position + delta

	# Clamp position
	new_pos.x = clamp(new_pos.x, lim_left, lim_right)
	new_pos.y = clamp(new_pos.y, lim_top, lim_bottom)

	# Apply only the movement that actually happened
	var applied_delta = new_pos - global_position
	global_position = new_pos

	# Update last_mouse_pos *relative to applied movement*
	last_mouse_pos -= applied_delta * zoom / pan_speed


func zoom_in():
	var new_zoom = zoom * (1.0 + zoom_speed)
	zoom = Vector2(
		clamp(new_zoom.x, min_zoom, max_zoom),
		clamp(new_zoom.y, min_zoom, max_zoom)
	)

func zoom_out():
	var new_zoom = zoom * (1.0 - zoom_speed)
	zoom = Vector2(
		clamp(new_zoom.x, min_zoom, max_zoom),
		clamp(new_zoom.y, min_zoom, max_zoom)
	)


func zoom_into_position(dst_pos : Vector2= get_global_mouse_position()) -> void:
	last_mouse_pos = Vector2.ZERO
	
	var target_zoom = Vector2(3, 3)
	
	#  dividing by Engine.time_sclae,  makes the camera zoom in independent of time_scale
	var duration = 0.5
	
	var tween := create_tween().set_ignore_time_scale()
	
	tween.tween_property(
		self,
		"zoom",
		Vector2(3,3),
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		self,
		"global_position",
		dst_pos,
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
