extends Control

@onready var wheel_node = $CenterContainer/the_wheel
@onready var texture_node = $CenterContainer/textures
@onready var action_node = $actions

var player : CharacterBody3D
var statistics : StatisticsComponent

var time_since_press = 0

const wheel_size = 400
const outer_rim_size = 475
const inner_rim_size = 300
const wheel_draw_precision = 22.5
const section_offset = 10

var wheel_contents = []
var wheel_vector_dict = {}
var selection_vector = Vector2.ZERO
var selection : int = -1
var mouse_location = Vector2.ZERO
var cursor_location : Vector2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.menu_open = true
	
	var attempt_to_get_player = get_parent()
	for i in range(10):
		if attempt_to_get_player is CharacterBody3D:
			player = attempt_to_get_player
			break
		else:
			attempt_to_get_player = attempt_to_get_player.get_parent()
	statistics = player.statistics
	
	## THE FOLLOWING IS FOR DEMO PURPOSES ONLY
	#generate_wheel([],4)

func _exit_tree():
	Global.menu_open = false

func _input(event):
	if event is InputEventMouseMotion:
		mouse_location.x += event.relative.x * statistics.menu_mouse_speed
		mouse_location.y += event.relative.y * statistics.menu_mouse_speed
		if mouse_location.length() > inner_rim_size: 
			mouse_location = mouse_location.normalized() * inner_rim_size

func _process(_delta):
	var joystick_selection_input = Input.get_vector("ui_cursor_left","ui_cursor_right","ui_cursor_up","ui_cursor_down")
	if joystick_selection_input == Vector2.ZERO:
		cursor_location = mouse_location
	else:
		mouse_location = Vector2.ZERO
		cursor_location = joystick_selection_input * inner_rim_size
	
	selection_vector = Vector2(cursor_location.x, -cursor_location.y).normalized()
	if selection_vector != Vector2.ZERO:
		var selection_array = []
		for i in wheel_vector_dict.keys():
			var test_dist = abs(selection_vector.angle_to(wheel_vector_dict[i]))
			selection_array.append(test_dist)
		selection = selection_array.find(selection_array.min())
	
	for i in wheel_contents.size():
		if i == selection:
			wheel_contents[i].color = Color.RED
		else:
			wheel_contents[i].color = Color.WHITE
	
	queue_redraw()

func _draw():
	draw_circle(cursor_location,10,Color.WHITE)
	draw_line(Vector2.ZERO, cursor_location, Color.WHITE)

func generate_wheel(contents : Array, count : int = -1):
	var num = contents.size() if count == -1 else count
	
	## DETERMINE SLICE LINES
	var right_slice_in_deg = 360.0 / (num * 2)
	var left_slice_in_deg = 360.0 - right_slice_in_deg
	var rim_points = (right_slice_in_deg * 2) / wheel_draw_precision
	var left_slice_in_rad = deg_to_rad(left_slice_in_deg)
	var right_slice_in_rad = deg_to_rad(right_slice_in_deg)
	
	## CREATE POINT ARRAY FOR A SINGLE SLICE
	var points = PackedVector2Array()
	points.push_back(Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * outer_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(left_slice_in_deg + (i * wheel_draw_precision))
		points.push_back(Vector2(cos(point), sin(point)) * outer_rim_size)
	points.push_back(Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * outer_rim_size)
	points.push_back(Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * inner_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(right_slice_in_deg - (i * wheel_draw_precision))
		points.push_back(Vector2(cos(point), sin(point)) * inner_rim_size)
	points.push_back(Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * inner_rim_size)
	
	for i in range(num):
		## CREATE A NEW SLICE AND POSITION IT
		var new_item = Polygon2D.new()
		wheel_node.add_child(new_item)
		var new_pos = Vector2.UP.rotated(deg_to_rad(i * 360 / num))
		new_item.position = new_pos * section_offset
		new_item.rotation = (3 * PI / 2) + (i * PI * 2 / num)
		new_item.polygon = points
		new_item.name = str(i)
		wheel_contents.append(new_item)
		
		## ADD REFERENCE TO WHEEL DICTIONARY
		var new_angle = deg_to_rad(90 - (( 360 / num ) * i))
		var new_vector = Vector2.RIGHT.rotated(new_angle)
		var new_wheel_dict_entry = {i:new_vector}
		wheel_vector_dict.merge(new_wheel_dict_entry)
		
		## ADD TEXTURE SPRITE
		# skip if a blank array way generated
		if count != -1: continue
		var new_sprite = Sprite2D.new()
		texture_node.add_child(new_sprite)
		new_sprite.position = new_pos * ( inner_rim_size + outer_rim_size ) / 2
		new_sprite.texture = load(contents[i]) if contents[i] != "blank" else null
