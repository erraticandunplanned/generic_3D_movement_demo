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

var current_accessory_set = 1
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
		
		## SET INVENTORY ITEMS INTO THE PROPER SLOTS
		var check_item = inventory.inv_slots[i]
		if check_item is Dictionary and check_item.has("item_id"):
			var new_item_node = generic_item.instantiate()
			inventory_node.add_child(new_item_node)
			new_item_node.position = accessory_tilemap.map_to_local(new_cell_location)
			new_item_node.set_item(check_item)
			new_item_node.get_child(0).texture = load(item_texture_path + "sm_" + check_item.get("item_id") + ".png")
	
	## SET ARMAMENT ITEMS INTO ARMAMENT SLOTS
	set_inventory_item(Vector2i(2,7), inventory.inv_armaments.get("left").get(0))
	set_inventory_item(Vector2i(3,7), inventory.inv_armaments.get("left").get(1))
	set_inventory_item(Vector2i(2,8), inventory.inv_armaments.get("left").get(2))
	set_inventory_item(Vector2i(3,8), inventory.inv_armaments.get("left").get(3))
	set_inventory_item(Vector2i(7,7), inventory.inv_armaments.get("right").get(0))
	set_inventory_item(Vector2i(8,7), inventory.inv_armaments.get("right").get(1))
	set_inventory_item(Vector2i(7,8), inventory.inv_armaments.get("right").get(2))
	set_inventory_item(Vector2i(8,8), inventory.inv_armaments.get("right").get(3))
	
	## SET ACCESSORY ITEMS INTO ACCESSORY SLOTS
	change_accessory_set(-1)
	
	## SET HOTBAR OUTLINE CORRECTLY
	hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)

func set_inventory_item(screen_loc : Vector2, item : Dictionary):
	if item == {}: return
	var new_item_node = generic_item.instantiate()
	inventory_node.add_child(new_item_node)
	new_item_node.position = accessory_tilemap.map_to_local(screen_loc)
	new_item_node.set_item(item)
	new_item_node.get_child(0).texture = load(item_texture_path + "sm_" + item.get("item_id") + ".png")

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
		## REMOVE ITEM DATA
		item_on_cursor = {}
		## PICK UP AN ITEM FROM SLOT, IF ANY
		if item_under_cursor != null:
			inventory_node.remove_child(item_under_cursor)
			cursor_object_holder.add_child(item_under_cursor)
			item_under_cursor.position = Vector2.ZERO
			item_under_cursor.scale = Vector2(1.2,1.2)
			## GET ITEM DATA
			item_on_cursor.merge(item_under_cursor.get_item(),true)
		
		send_to_inventory()

func change_accessory_set(dir : int):
	current_accessory_set += dir
	if current_accessory_set > 3: current_accessory_set = 0
	if current_accessory_set < 0: current_accessory_set = 3
	
	var pattern = accessory_tilemap.tile_set.get_pattern(current_accessory_set)
	accessory_tilemap.set_pattern(ICONS, Vector2i(2,4),pattern)
	
	for i in inventory_node.get_children():
		var map_pos = accessory_tilemap.local_to_map(i.position)
		if map_pos == Vector2i(5,4) or map_pos == Vector2i(5,5) or map_pos == Vector2i(5,6) or map_pos == Vector2i(5,7) or map_pos == Vector2i(5,8) or map_pos == Vector2i(5,9) or map_pos == Vector2i(4,5) or map_pos == Vector2i(3,5) or map_pos == Vector2i(2,5) or map_pos == Vector2i(6,5) or map_pos == Vector2i(7,5) or map_pos == Vector2i(8,5): i.queue_free()
	
	set_inventory_item(Vector2i(5,4), inventory.inv_accessories.get(current_accessory_set).get("head"))
	set_inventory_item(Vector2i(5,5), inventory.inv_accessories.get(current_accessory_set).get("chest"))
	set_inventory_item(Vector2i(5,6), inventory.inv_accessories.get(current_accessory_set).get("back"))
	set_inventory_item(Vector2i(5,7), inventory.inv_accessories.get(current_accessory_set).get("hips"))
	set_inventory_item(Vector2i(5,8), inventory.inv_accessories.get(current_accessory_set).get("legs"))
	set_inventory_item(Vector2i(5,9), inventory.inv_accessories.get(current_accessory_set).get("feet"))
	set_inventory_item(Vector2i(4,5), inventory.inv_accessories.get(current_accessory_set).get("l_shoulder"))
	set_inventory_item(Vector2i(3,5), inventory.inv_accessories.get(current_accessory_set).get("l_arm"))
	set_inventory_item(Vector2i(2,5), inventory.inv_accessories.get(current_accessory_set).get("l_hand"))
	set_inventory_item(Vector2i(6,5), inventory.inv_accessories.get(current_accessory_set).get("r_shoulder"))
	set_inventory_item(Vector2i(7,5), inventory.inv_accessories.get(current_accessory_set).get("r_arm"))
	set_inventory_item(Vector2i(8,5), inventory.inv_accessories.get(current_accessory_set).get("r_hand"))

func send_to_inventory():
	## CLEAR INVENTORY
	for i in inventory.inv_slots.size():
		inventory.inv_slots[i] = {}
	
	## SET A BUNCH OF VARs FOR ARMAMENT AND ACCESSORY SLOTS
	var arm_R_0 = {}
	var arm_R_1 = {}
	var arm_R_2 = {}
	var arm_R_3 = {}
	var arm_L_0 = {}
	var arm_L_1 = {}
	var arm_L_2 = {}
	var arm_L_3 = {}
	var acc_he = {}
	var acc_ch = {}
	var acc_ba = {}
	var acc_hi = {}
	var acc_le = {}
	var acc_fe = {}
	var acc_ls = {}
	var acc_la = {}
	var acc_lh = {}
	var acc_rs = {}
	var acc_ra = {}
	var acc_rh = {}
	
	for item in inventory_node.get_children():
		## SORT ITEM BY LOCATION
		var map_loc = accessory_tilemap.local_to_map(item.position)
		## BASIC INVENTORY SLOTS
		if map_loc.x > 9:
			var int_index = (map_loc.x - 11) + ((map_loc.y - 4) * 8)
			inventory.inv_slots[int_index] = item.get_item()
		else:
			match map_loc:
				## ARMAMENTS
				Vector2i(2,7): arm_L_0 = item.get_item()
				Vector2i(2,8): arm_L_2 = item.get_item()
				Vector2i(3,7): arm_L_1 = item.get_item()
				Vector2i(3,8): arm_L_3 = item.get_item()
				Vector2i(7,7): arm_R_0 = item.get_item()
				Vector2i(8,7): arm_R_1 = item.get_item()
				Vector2i(7,8): arm_R_2 = item.get_item()
				Vector2i(8,8): arm_R_3 = item.get_item()
				## ACCESSORIES
				Vector2i(5,4): acc_he = item.get_item()
				Vector2i(5,5): acc_ch = item.get_item()
				Vector2i(5,6): acc_ba = item.get_item()
				Vector2i(5,7): acc_hi = item.get_item()
				Vector2i(5,8): acc_le = item.get_item()
				Vector2i(5,9): acc_fe = item.get_item()
				Vector2i(4,5): acc_ls = item.get_item()
				Vector2i(3,5): acc_la = item.get_item()
				Vector2i(2,5): acc_lh = item.get_item()
				Vector2i(6,5): acc_rs = item.get_item()
				Vector2i(7,5): acc_ra = item.get_item()
				Vector2i(8,5): acc_rh = item.get_item()
	
	## RECONSTRUCT ARMAMENT DICTIONARY
	var reconstructed_armaments = {"left":{0:arm_L_0,1:arm_L_1,2:arm_L_2,3:arm_L_3},"right":{0:arm_R_0,1:arm_R_1,2:arm_R_2,3:arm_R_3}}
	inventory.inv_armaments = reconstructed_armaments.duplicate()
	var single_accessory_index = {current_accessory_set:{
			"head" : acc_he,
			"chest" : acc_ch,
			"back" : acc_ba,
			"hips" : acc_hi,
			"legs" : acc_le,
			"feet" : acc_fe,
			"l_shoulder" : acc_ls,
			"l_arm" : acc_la,
			"l_hand" : acc_lh,
			"r_shoulder" : acc_rs,
			"r_arm" : acc_ra,
			"r_hand" : acc_rh
			}
		}
	var reconstructed_accessories = inventory.inv_accessories
	reconstructed_accessories.merge(single_accessory_index, true)
	inventory.inv_accessories = reconstructed_accessories.duplicate()
