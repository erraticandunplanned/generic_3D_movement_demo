extends Control

@onready var accessory_tilemap = $slot_map/TileMap
@onready var inventory_node = $inventory
#@onready var demo_items : TileSet = preload("res://textures/Shikashi's Fantasy Icons Pack v2/inventory_items.tres")
@onready var generic_item = preload("res://items_and_materials/generic_item.tscn")

var player : CharacterBody3D
var statistics : StatisticsComponent

enum {SELECTION, BORDER, ITEMS, ICONS, BACKGROUND}
#enum {ARMOR, CLOTHING, GEAR, CHARM}

const inventory_begin_location = Vector2i(11,4)

var current_accessory_set = 0
var screen_size : Vector2
var cursor_mode = true
var cursor_location : Vector2
var tile_location : Vector2i
var item_on_cursor : Dictionary = {}

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
		
		if statistics.inv_slots[i] is Dictionary:
			var item : Dictionary = statistics.inv_slots[i]
			var new_item_node = generic_item.instantiate()
			inventory_node.add_child(new_item_node)
			new_item_node.position = accessory_tilemap.map_to_local(new_cell_location)
	

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
	var discrete_input = Vector2.LEFT if Input.is_action_just_pressed("ui_left") else Vector2.RIGHT if Input.is_action_just_pressed("ui_right") else Vector2.UP if Input.is_action_just_pressed("ui_up") else Vector2.DOWN if Input.is_action_just_pressed("ui_down") else Vector2.ZERO
	if discrete_input != Vector2.ZERO:
		cursor_mode = false
		cursor_location += discrete_input * accessory_tilemap.tile_set.tile_size.x
		cursor_location.x = clamp(cursor_location.x, 0, screen_size.x)
		cursor_location.y = clamp(cursor_location.y, 0, screen_size.y)
	
	## SET SELECTION TO TILE SET MAP SPACE
	accessory_tilemap.clear_layer(SELECTION)
	tile_location = accessory_tilemap.local_to_map(cursor_location)
	
	## CHECK IF SELECTED TILE IS VALID
	if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) == null:
		if cursor_mode:
			## IF NOT VALID AND CURSOR_MODE IS TRUE, SELECTION IS NULL
			tile_location = Vector2i(-1,-1)
		else:
			## IF NOT VALID AND CURSOR_MODE IS FALSE, MOVE TO CLOSEST VALID TILE
			var new_tile_location = tile_location
			var discrete_input_but_as_a_Vector2i = Vector2i(discrete_input)
			var attempts = 0
			var new_lines = 0
			while accessory_tilemap.get_cell_tile_data(BORDER,new_tile_location) == null:
				attempts += 1
				## SCAN THE COLUMN/ROW OF INPUT DIRECTION FOR A VALID TILE
				new_tile_location += discrete_input_but_as_a_Vector2i
				## IF NOTHING IS FOUND, CHECK ROW/COLUMN ABOVE AND BELOW
				var request_new_line = true if new_tile_location.x < 0 or new_tile_location.y < 0 or new_tile_location.x > 20 or new_tile_location.y > 20 else false
				if request_new_line:
					new_lines += 1
					var dir = Vector2i(discrete_input_but_as_a_Vector2i.y,discrete_input_but_as_a_Vector2i.x) if new_lines % 2 == 1 else Vector2i(-discrete_input_but_as_a_Vector2i.y,-discrete_input_but_as_a_Vector2i.x)
					var amt = ceil(new_lines/2)
					new_tile_location = tile_location + (dir * amt)
				## IF NOTHING IS FOUND, BREAK LOOP AND RETURN FALSE
				var request_break = true if attempts > 100 else false
				if request_break:
					new_tile_location = tile_location - discrete_input_but_as_a_Vector2i
					break
			## SET SELECTION TO NEW, VALID TILE
			tile_location = new_tile_location
			cursor_location = accessory_tilemap.map_to_local(tile_location)
			if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) != null: accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	else:
		accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	
	
	## ITEM SELECTION
	if Input.is_action_just_pressed("ui_select"):
		if item_on_cursor.is_empty():
			## PICK UP ITEM
			pass
		else:
			## PLACE ITEM
			pass
	
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
