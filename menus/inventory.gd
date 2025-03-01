extends Control

@onready var accessory_tilemap = $slot_map/TileMap
@onready var demo_items : TileSet = preload("res://textures/Shikashi's Fantasy Icons Pack v2/inventory_items.tres")

var player : CharacterBody3D
var statistics : StatisticsComponent

enum {SELECTION, BORDER, ITEMS, ICONS, BACKGROUND}
#enum {ARMOR, CLOTHING, GEAR, CHARM}

var inventory_begin_location = Vector2i(11,4)

var current_accessory_set = 0
var screen_size : Vector2
var cursor_mode = true
var cursor_location : Vector2
var tile_location : Vector2i

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent()
	statistics = player.statistics
	
	screen_size = get_viewport_rect().size
	cursor_location = screen_size / 2
	
	## CREATE THE SLOT SQUARE
	for i in statistics.inv_slots.size():
		var row = floor(i / 8)
		var column = i % 8
		var new_cell_location = inventory_begin_location + Vector2i(column, row)
		accessory_tilemap.set_cell(BORDER,new_cell_location,0,Vector2i(0,0))
		accessory_tilemap.set_cell(BACKGROUND,new_cell_location,3,Vector2i(0,0))
		
		if statistics.inv_slots[i] != null:
			print("item exists at ", new_cell_location, ". item is ", statistics.inv_slots.get(i))
	

func _input(event):
	## MOVE CURSOR ACCORDING TO CONTINUOUS MOUSE MOVEMENT
	if event is InputEventMouseMotion:
		cursor_mode = true
		cursor_location.x += event.relative.x * statistics.menu_mouse_speed
		cursor_location.y += event.relative.y * statistics.menu_mouse_speed
		cursor_location.x = clamp(cursor_location.x, 0, screen_size.x)
		cursor_location.y = clamp(cursor_location.y, 0, screen_size.y)
	

func _process(delta):
	## TAB THROUGH ACCESSORY SETS
	if Input.is_action_just_pressed("ui_tab_left"): change_accessory_set(-1)
	if Input.is_action_just_pressed("ui_tab_right"): change_accessory_set(1)
	
	## MOVE CURSOR ACCORDING TO CONTINUOUS JOYSTICK INPUT
	var joystick_input = Input.get_vector("ui_cursor_left","ui_cursor_right","ui_cursor_up","ui_cursor_down")
	if joystick_input != Vector2.ZERO:
		cursor_mode = true
		cursor_location += joystick_input * statistics.menu_joystick_speed
		cursor_location.x = clamp(cursor_location.x, 0, screen_size.x)
		cursor_location.y = clamp(cursor_location.y, 0, screen_size.y)
	
	## MOVE CURSOR ACCORDING TO DISCRETE BUTTON INPUT (DPAD OR ARROW KEYS)
	if Input.is_action_just_pressed("ui_left"):
		cursor_mode = false
		cursor_location += Vector2.LEFT * accessory_tilemap.tile_set.tile_size.x
		cursor_location.x = clamp(cursor_location.x, 0, screen_size.x)
	if Input.is_action_just_pressed("ui_right"):
		cursor_mode = false
		cursor_location += Vector2.RIGHT * accessory_tilemap.tile_set.tile_size.x
		cursor_location.x = clamp(cursor_location.x, 0, screen_size.x)
	if Input.is_action_just_pressed("ui_up"):
		cursor_mode = false
		cursor_location += Vector2.UP * accessory_tilemap.tile_set.tile_size.y
		cursor_location.y = clamp(cursor_location.y, 0, screen_size.y)
	if Input.is_action_just_pressed("ui_down"):
		cursor_mode = false
		cursor_location += Vector2.DOWN * accessory_tilemap.tile_set.tile_size.y
		cursor_location.y = clamp(cursor_location.y, 0, screen_size.y)
	
	## SET SELECTION TO TILE SET MAP SPACE
	tile_location = accessory_tilemap.local_to_map(cursor_location)
	accessory_tilemap.clear_layer(SELECTION)
	accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	
	## THE REDRAW FUNCTION (TM)
	queue_redraw()

func change_accessory_set(dir : int):
	current_accessory_set += dir
	if current_accessory_set > 3: current_accessory_set = 0
	if current_accessory_set < 0: current_accessory_set = 3
	
	var pattern = accessory_tilemap.tile_set.get_pattern(current_accessory_set)
	accessory_tilemap.set_pattern(ICONS, Vector2i(2,4),pattern)

func _draw():
	if cursor_mode: draw_circle(cursor_location,10,Color.WHITE)
