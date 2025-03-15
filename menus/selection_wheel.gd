extends Control

@onready var screenspace = $screenspace
@onready var wheel_node = $screenspace/CenterContainer/the_wheel
@onready var action_node = $actions

@onready var create_cube = preload("res://player/create_cube/create_cube.tscn")
@onready var leap = preload("res://player/leap/leap.tscn")

var player : CharacterBody3D
var statistics : StatisticsComponent

var time_since_press = 0

const wheel_size = 400
const outer_rim_size = 475
const inner_rim_size = 300
const wheel_draw_precision = 22.5
const section_offset = 10

var wheel_contents = []
var wheel_dict = {}
var action_dict = {}
var selection_vector = Vector2.ZERO
var selection : int = -1
var screen_size : Vector2
var screen_center : Vector2
var mouse_location_raw : Vector2
var mouse_location_clamp : Vector2
var cursor_location : Vector2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent()
	statistics = player.statistics
	screen_size = get_viewport_rect().size
	screen_center = get_viewport_rect().size / 2
	mouse_location_raw = screen_center
	mouse_location_clamp = screen_center
	selection = statistics.wanderer_ability_last_used
	screenspace.visible = false
	
	## THE FOLLOWING IS FOR DEMO PURPOSES ONLY
	generate_wheel([],8)
	var cube_action = create_cube.instantiate()
	action_node.add_child(cube_action)
	cube_action.name = "1"
	var new_dict_entry_1 = {1:cube_action}
	action_dict.merge(new_dict_entry_1)
	var leap_action = leap.instantiate()
	action_node.add_child(leap_action)
	leap_action.name = "0"
	var new_dict_entry_0 = {0:leap_action}
	action_dict.merge(new_dict_entry_0)

func _exit_tree():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		mouse_location_raw.x += event.relative.x * statistics.menu_mouse_speed
		mouse_location_raw.y += event.relative.y * statistics.menu_mouse_speed
		mouse_location_raw.x = clamp(mouse_location_raw.x, screen_center.x - outer_rim_size, screen_center.x + outer_rim_size)
		mouse_location_raw.y = clamp(mouse_location_raw.y, screen_center.y - outer_rim_size, screen_center.y + outer_rim_size)
		
		var cursor_vector = mouse_location_raw - screen_center
		if cursor_vector.length() > outer_rim_size: 
			mouse_location_clamp = screen_center + ( cursor_vector.normalized() * inner_rim_size)
		else:
			mouse_location_clamp = mouse_location_raw

func _process(delta):
	if Input.is_action_just_released("wanderer_ability"): 
		statistics.wanderer_ability_last_used = selection
		
		print("perform action ", selection)
		if action_dict.keys().has(selection):
			action_dict[selection]._on_action_press()
		
		player.swap_to_menu("HUD")
	
	time_since_press += delta
	if screenspace.visible == false:
		if time_since_press >= 0.1: 
			screenspace.visible = true
		else: return
	
	
	var joystick_selection_input = Input.get_vector("ui_cursor_left","ui_cursor_right","ui_cursor_up","ui_cursor_down")
	if joystick_selection_input == Vector2.ZERO:
		cursor_location = mouse_location_clamp
	else:
		mouse_location_raw = screen_center
		cursor_location = screen_center + ( joystick_selection_input * inner_rim_size )
	
	selection_vector = Vector2(cursor_location.x - screen_center.x, -(cursor_location.y - screen_center.y)).normalized()
	if selection_vector != Vector2.ZERO:
		var selection_array = []
		for i in wheel_dict.keys():
			var test_dist = abs(selection_vector.angle_to(wheel_dict[i]))
			selection_array.append(test_dist)
		selection = selection_array.find(selection_array.min())
	
	for i in wheel_contents.size():
		if i == selection:
			wheel_contents[i].color = Color.RED
		else:
			wheel_contents[i].color = Color.WHITE
	
	queue_redraw()

func generate_wheel(contents : Array, count : int = 0): #Array[PackedScene]
	## DETERMINE SLICE LINES
	var right_slice_in_deg = 360.0 / (count * 2)
	var left_slice_in_deg = 360.0 - right_slice_in_deg
	var rim_points = (right_slice_in_deg * 2) / wheel_draw_precision
	var left_slice_in_rad = deg_to_rad(left_slice_in_deg)
	var right_slice_in_rad = deg_to_rad(right_slice_in_deg)
	
	## CREATE POINT ARRAY
	var points = PackedVector2Array()
	points.push_back(Vector2.ZERO + Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * outer_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(left_slice_in_deg + (i * wheel_draw_precision))
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * outer_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * outer_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * inner_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(right_slice_in_deg - (i * wheel_draw_precision))
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * inner_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * inner_rim_size)

	## CREATE <NUMBER> SLICES
	var num = contents.size() if count == 0 else count
	for i in range(0,num):
		var new_item = Polygon2D.new()
		wheel_node.add_child(new_item)
		var new_pos = Vector2.UP.rotated(deg_to_rad(i * 360 / num))
		new_item.position = Vector2.ZERO + new_pos * section_offset
		new_item.rotation = (3 * PI / 2) + (i * PI * 2 / num)
		new_item.polygon = points
		new_item.name = str(i)
		wheel_contents.append(new_item)
		
		var new_angle = deg_to_rad(90 - (( 360 / num ) * i))
		var new_vector = Vector2.RIGHT.rotated(new_angle)
		var new_wheel_dict_entry = {i:new_vector}
		wheel_dict.merge(new_wheel_dict_entry)

func _draw():
	if screenspace.visible == true:
		draw_circle(cursor_location,10,Color.WHITE)
		draw_line(screen_center, cursor_location, Color.WHITE)
