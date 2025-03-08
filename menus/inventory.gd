extends Control

@onready var accessory_tilemap = $slot_map/TileMap
@onready var hotbar_outline = $slot_map/hotbar_outline
@onready var inventory_node = $inventory
@onready var cursor_node = $cursor
@onready var cursor_object_holder = $cursor/object
@onready var generic_item = preload("res://items_and_materials/generic_item.tscn")
@onready var item_texture_path = "res://textures/item_images/"

var player : CharacterBody3D
var statistics : StatisticsComponent
var inventory : InventoryComponent

enum {SELECTION, BORDER, ITEMS, ICONS, BACKGROUND}
#enum {ARMOR, CLOTHING, GEAR, CHARM}

const inventory_begin_location = Vector2i(11,4)

var current_accessory_set = 0
var screen_size : Vector2
var cursor_mode = true
#var cursor_location : Vector2
var tile_location : Vector2i
var item_on_cursor : Dictionary = {}

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent()
	statistics = player.statistics
	inventory = player.find_child("ComponentGearAndInventory", false)
	
	screen_size = get_viewport_rect().size
	cursor_node.position = accessory_tilemap.map_to_local(inventory_begin_location)
	
	## CREATE THE SLOT SQUARE
	for i in inventory.inv_slots.size():
		var row = floor(i / 8)
		var column = i % 8
		var new_cell_location = inventory_begin_location + Vector2i(column, row)
		accessory_tilemap.set_cell(BORDER,new_cell_location,0,Vector2i(0,0))
		accessory_tilemap.set_cell(BACKGROUND,new_cell_location,1,Vector2i(0,0))
		
		var check_item = inventory.inv_slots[i]
		if check_item is Dictionary and check_item.has("item_id"):
			var new_item_node = generic_item.instantiate()
			inventory_node.add_child(new_item_node)
			new_item_node.position = accessory_tilemap.map_to_local(new_cell_location)
			new_item_node.set_item(check_item)
			new_item_node.get_child(0).texture = load(item_texture_path + "sm_" + check_item.get("item_id") + ".png")
	
	## SET HOTBAR OUTLINE CORRECTLY
	hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)

func _input(event):
	## MOVE CURSOR ACCORDING TO CONTINUOUS MOUSE MOVEMENT
	if event is InputEventMouseMotion:
		cursor_mode = true
		cursor_node.position.x += event.relative.x * statistics.menu_mouse_speed
		cursor_node.position.y += event.relative.y * statistics.menu_mouse_speed
		cursor_node.position.x = clamp(cursor_node.position.x, 0, screen_size.x)
		cursor_node.position.y = clamp(cursor_node.position.y, 0, screen_size.y)
	

func _process(delta):
	## TAB THROUGH ACCESSORY SETS
	if Input.is_action_just_pressed("ui_tab_left"): change_accessory_set(-1)
	if Input.is_action_just_pressed("ui_tab_right"): change_accessory_set(1)
	
	## MOVE ACTIVE HOTBAR
	if Input.is_action_just_pressed("cycle_hotbar"):
		inventory.active_hotbar_start += 8
		if (inventory.active_hotbar_start + 7) > inventory.inv_slots.size(): inventory.active_hotbar_start = 0
		hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)
	
	## MOVE CURSOR ACCORDING TO CONTINUOUS JOYSTICK INPUT
	var joystick_input = Input.get_vector("ui_cursor_left","ui_cursor_right","ui_cursor_up","ui_cursor_down")
	if joystick_input != Vector2.ZERO:
		cursor_mode = true
		cursor_node.position += joystick_input * statistics.menu_joystick_speed
		cursor_node.position.x = clamp(cursor_node.position.x, 0, screen_size.x)
		cursor_node.position.y = clamp(cursor_node.position.y, 0, screen_size.y)
	
	## SET SELECTION TO TILE SET MAP SPACE
	accessory_tilemap.clear_layer(SELECTION)
	tile_location = accessory_tilemap.local_to_map(cursor_node.position)
	
	## MOVE CURSOR ACCORDING TO DISCRETE BUTTON INPUT (DPAD OR ARROW KEYS)
	## TODO: CONSTANT DISCRETE MOVEMENT IF BUTTON IS HELD DOWN (WITH INCREASING SPEED)
	var discrete_input : Vector2i = Vector2i.LEFT if Input.is_action_just_pressed("ui_left") else Vector2i.RIGHT if Input.is_action_just_pressed("ui_right") else Vector2i.UP if Input.is_action_just_pressed("ui_up") else Vector2i.DOWN if Input.is_action_just_pressed("ui_down") else Vector2i.ZERO
	if discrete_input != Vector2i.ZERO:
		cursor_mode = false
		tile_location += discrete_input
		cursor_node.position = accessory_tilemap.map_to_local(tile_location)
	
	## IF DISCRETE MOVEMENT ATTEMPTS TO MOVE THE SELECTION OFF THE INVENTORY AREA, 
	## FIND THE NEXT MOST REASONABLE SELECTION AND MOVE THE CURSOR THERE
	if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) == null:
		if cursor_mode:
			## IF NOT VALID AND CURSOR_MODE IS TRUE, SELECTION IS NULL
			tile_location = Vector2i(-1,-1)
		else:
			## IF NOT VALID AND CURSOR_MODE IS FALSE, MOVE TO CLOSEST VALID TILE
			var new_tile_location = tile_location
			var attempts = 0
			var new_lines = 0
			while accessory_tilemap.get_cell_tile_data(BORDER,new_tile_location) == null:
				attempts += 1
				## SCAN THE COLUMN/ROW OF INPUT DIRECTION FOR A VALID TILE
				new_tile_location += discrete_input
				## IF NOTHING IS FOUND, CHECK ROW/COLUMN ABOVE AND BELOW
				var request_new_line = true if new_tile_location.x < 0 or new_tile_location.y < 0 or new_tile_location.x > 20 or new_tile_location.y > 20 else false
				if request_new_line:
					new_lines += 1
					var dir = Vector2i(discrete_input.y,discrete_input.x) if new_lines % 2 == 1 else Vector2i(-discrete_input.y,-discrete_input.x)
					var amt = ceil(new_lines/2)
					new_tile_location = tile_location + (dir * amt)
				## IF NOTHING IS FOUND, BREAK LOOP AND RETURN FALSE
				var request_break = true if attempts > 100 else false
				if request_break:
					new_tile_location = tile_location - discrete_input
					break
			## SET SELECTION TO NEW TILE
			tile_location = new_tile_location
			cursor_node.position = accessory_tilemap.map_to_local(tile_location)
			## IF VALID, SET SELECTION. IF NOT, SEND THE SELECTION TO THE VOID (TM)
			if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) == null: 
				tile_location = Vector2i(-1,-1)
			else:
				accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	else:
		accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	
	## CURSOR IS INVISIBLE IF CURSOR MODE IS FALSE
	cursor_node.get_child(0).visible = cursor_mode
	
	## PICKING UP, PLACING DOWN, AND SWAPPING ITEMS ON THE CURSOR
	if Input.is_action_just_pressed("ui_select") and tile_location != Vector2i(-1,-1) and accessory_tilemap.get_cell_tile_data(BORDER,tile_location) != null:
		## CHECK FOR ITEM ON SELECTED TILE
		var worldspace_location = accessory_tilemap.map_to_local(tile_location)
		var item_under_cursor : Node = null
		for i in inventory_node.get_children():
			if i.position == worldspace_location:
				item_under_cursor = i
		## PLACE ITEM ON CURSOR INTO SLOT
		for i in cursor_object_holder.get_children():
			cursor_object_holder.remove_child(i)
			inventory_node.add_child(i)
			i.position = accessory_tilemap.map_to_local(tile_location)
			i.scale = Vector2(1,1)
			i.set_item(item_on_cursor)
			## ADD ITEM TO PLAYER INVENTORY
			var slot_to_add : Dictionary = map_to_inventory(tile_location)
			if slot_to_add.has("dict") and slot_to_add.get("dict") == 0: 
				var index = slot_to_add.get("cont")
				inventory.inv_slots[index] = item_on_cursor.duplicate()
		## REMOVE ITEM DATA
		item_on_cursor.clear()
		## PICK UP AN ITEM FROM SLOT, IF ANY
		if item_under_cursor != null:
			inventory_node.remove_child(item_under_cursor)
			cursor_object_holder.add_child(item_under_cursor)
			item_under_cursor.position = Vector2.ZERO
			item_under_cursor.scale = Vector2(1.2,1.2)
			## GET ITEM DATA
			item_on_cursor.merge(item_under_cursor.get_item(),true)
			## REMOVE ITEM FROM PLAYER INVENTORY
			var slot_to_remove : Dictionary = map_to_inventory(tile_location)
			if slot_to_remove.has("dict") and slot_to_remove.get("dict") == 0: 
				var index = slot_to_remove.get("cont")
				inventory.inv_slots[index] = null

func change_accessory_set(dir : int):
	current_accessory_set += dir
	if current_accessory_set > 3: current_accessory_set = 0
	if current_accessory_set < 0: current_accessory_set = 3
	
	var pattern = accessory_tilemap.tile_set.get_pattern(current_accessory_set)
	accessory_tilemap.set_pattern(ICONS, Vector2i(2,4),pattern)

						#####################################
						## SLOT <-> DICTIONARY CONVERSIONS ##
						#####################################

## "map" slots are given as a Vector2i location in the inventory tilemap
## "inventory" slots are given as a Dictionary hierarchy as follows:
## {
##     "dict" : 0,
##     "cont" : CONTENT
## }
## where "dict" is an int, either 0 for inv_slots, 1 for inv_armaments, or 2 for inv_accessories
## where "cont" is either an array index for inv_slots or a nexted Dictionary for inv_armaments or inv_accessories

func map_to_inventory(map_loc : Vector2i) -> Dictionary:
	var output_dict = {}
	
	## BASIC INVENTORY SLOTS
	if map_loc.x > 9:
		output_dict.merge({"dict":0})
		var int_index = (map_loc.x - 11) + ((map_loc.y - 4) * 8)
		output_dict.merge({"cont": int_index})
	
	## LEFT-HAND ARMAMENTS
	elif map_loc.x < 4 and map_loc.y > 6:
		output_dict.merge({"dict":1})
		var left_slot = {"left":{0:null}} if map_loc == Vector2i(2,7) else {"left":{1:null}} if map_loc == Vector2i(3,7) else {"left":{2:null}} if map_loc == Vector2i(2,8) else {"left":{3:null}} if map_loc == Vector2i(3,8) else {}
		output_dict.merge({"cont":left_slot})
	
	## RIGHT-HAND ARMAMENTS
	elif map_loc.x > 6 and map_loc.y > 6:
		output_dict.merge({"dict":1})
		var right_slot = {"right":{0:null}} if map_loc == Vector2i(7,7) else {"right":{1:null}} if map_loc == Vector2i(8,7) else {"right":{2:null}} if map_loc == Vector2i(7,8) else {"right":{3:null}} if map_loc == Vector2i(8,8) else {}
		output_dict.merge({"cont":right_slot})
	
	## ACCESSORIES
	else:
		output_dict.merge({"dict":2})
	
	return output_dict

func inventory_to_map():
	pass
