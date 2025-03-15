extends Control

@onready var accessory_tilemap = $slot_map/TileMap
@onready var hotbar_outline = $slot_map/hotbar_outline
@onready var inventory_node = $inventory
@onready var cursor_node = $cursor
@onready var cursor_item_texture = $cursor/GenericItem/Sprite2D
@onready var generic_item = preload("res://items_and_materials/generic_item.tscn")
@onready var item_texture_path = "res://textures/item_images/"

var player : CharacterBody3D
var statistics : StatisticsComponent
var inventory : InventoryComponent

enum {SELECTION, BORDER, ITEMS, ICONS, BACKGROUND}
#enum {ARMOR, CLOTHING, GEAR, CHARM}
const inventory_begin_location = Vector2i(11,4)
const equipment_location_array = [Vector2i(5,4),Vector2i(5,5),Vector2i(5,6),Vector2i(5,7),Vector2i(5,8),Vector2i(5,9),Vector2i(4,5),Vector2i(3,5),Vector2i(2,5),Vector2i(6,5),Vector2i(7,5),Vector2i(8,5),Vector2i(2,7),Vector2i(3,7),Vector2i(2,8),Vector2i(3,8),Vector2i(7,7),Vector2i(8,7),Vector2i(7,8),Vector2i(8,8)]
#enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND, A_L0, A_L1, A_L2, A_L3, A_R0, A_R1, A_R2, A_R3}

var node_array_inventory = []
var node_array_equipment = []

var current_accessory_set = 0
var screen_size : Vector2
var cursor_mode = true
var tile_location : Vector2i
var current_cursor_item : BasicItem = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent().get_parent()
	statistics = player.statistics
	inventory = player.find_child("ComponentGearAndInventory", false)
	
	screen_size = get_viewport_rect().size
	cursor_node.position = accessory_tilemap.map_to_local(inventory_begin_location)
	
	node_array_inventory.resize(inventory.inv_slots.size())
	node_array_equipment.resize(equipment_location_array.size())
	
	## CREATE THE SLOT SQUARE
	for i in inventory.inv_slots.size():
		var row = floor(i / 8)
		var column = i % 8
		var new_cell_location = inventory_begin_location + Vector2i(column, row)
		accessory_tilemap.set_cell(BORDER,new_cell_location,0,Vector2i(0,0))
		accessory_tilemap.set_cell(BACKGROUND,new_cell_location,1,Vector2i(0,0))
		
		## SET INVENTORY ITEMS INTO THE PROPER SLOTS
		var new_item = generic_item.instantiate()
		inventory_node.add_child(new_item)
		new_item.position = accessory_tilemap.map_to_local(new_cell_location)
		new_item.name = "INV_" + str(i)
		node_array_inventory[i] = new_item
	
	## SET ACCESSORY ITEMS INTO ACCESSORY SLOTS
	for i in range(20):
		var new_item = generic_item.instantiate()
		inventory_node.add_child(new_item)
		new_item.position = accessory_tilemap.map_to_local(equipment_location_array[i])
		new_item.name = "EQUIP_" + str(i)
		node_array_equipment[i] = new_item
	
	## SET HOTBAR OUTLINE CORRECTLY
	hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)
	
	update_inventory_and_equipment()

func _input(event):
	## MOVE CURSOR ACCORDING TO CONTINUOUS MOUSE MOVEMENT
	if event is InputEventMouseMotion:
		cursor_mode = true
		cursor_node.position.x += event.relative.x * statistics.menu_mouse_speed
		cursor_node.position.y += event.relative.y * statistics.menu_mouse_speed
		cursor_node.position.x = clamp(cursor_node.position.x, 0, screen_size.x)
		cursor_node.position.y = clamp(cursor_node.position.y, 0, screen_size.y)

func _process(_delta):
	## TAB THROUGH ACCESSORY SETS
	if Input.is_action_just_pressed("ui_tab_left"): change_accessory_set(-1)
	if Input.is_action_just_pressed("ui_tab_right"): change_accessory_set(1)
	
	## MOVE ACTIVE HOTBAR
	if Input.is_action_just_pressed("cycle_hotbar"):
		inventory.active_hotbar_start += 8
		if (inventory.active_hotbar_start + 7) > inventory.inv_slots.size(): inventory.active_hotbar_start = 0
		hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)
	
						#################
						## MOVE CURSOR ##
						#################
	
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
	
						################################################################
						## PICKING UP, PLACING DOWN, AND SWAPPING ITEMS ON THE CURSOR ##
						################################################################
	
	if Input.is_action_just_pressed("ui_select") and tile_location != Vector2i(-1,-1) and accessory_tilemap.get_cell_tile_data(BORDER,tile_location) != null:
		## PLACE CURSOR ITEM IN A BOX FOR LATER
		var liminal_cursor_item = current_cursor_item
		current_cursor_item = null
		## FIND INVENTORY AND EQUIPMENT INDEX
		var index = ( tile_location.x - inventory_begin_location.x ) + ( ( tile_location.y - inventory_begin_location.y ) * 8) if tile_location.x > 9 else equipment_location_array.find(tile_location)
		if index == -1: print("ERROR! invalid slot index.")
		
		## PICK UP ITEM
		if tile_location.x > 9: ## INVENTORY
			current_cursor_item = inventory.inv_slots[index]
			inventory.inv_slots[index] = null
		elif index < 12: ## ACCESSORIES
			match current_accessory_set:
				0: current_cursor_item = inventory.inv_accessory_armor[index]
				1: current_cursor_item = inventory.inv_accessory_cloth[index]
				2: current_cursor_item = inventory.inv_accessory_gears[index]
				3: current_cursor_item = inventory.inv_accessory_charm[index]
		else: ## ARMAMENTS
			current_cursor_item = inventory.inv_armaments[index-12]
		
		## PLACE ITEM
		if tile_location.x > 9: ## INVENTORY
			inventory.inv_slots[index] = liminal_cursor_item
			liminal_cursor_item = null
		elif index < 12: ## ACCESSORIES
			match current_accessory_set:
				0: inventory.inv_accessory_armor[index] = liminal_cursor_item
				1: inventory.inv_accessory_cloth[index] = liminal_cursor_item
				2: inventory.inv_accessory_gears[index] = liminal_cursor_item
				3: inventory.inv_accessory_charm[index] = liminal_cursor_item 
			liminal_cursor_item = null
		else: ## ARMAMENTS
			inventory.inv_armaments[index-12] = liminal_cursor_item
			liminal_cursor_item = null
		
		## PUT BOXED ITEM BACK ON CURSOR IF IT WASN'T USED
		if liminal_cursor_item != null: 
			current_cursor_item = liminal_cursor_item
			liminal_cursor_item = null
		
		## UPDATE CURSOR TEXTURE AND SLOT TEXTURES FROM INVENTORY DATA
		update_inventory_and_equipment()

func update_inventory_and_equipment(accessories_only = false):
	## UPDATE ACCESSORIES
	var temp_accessory_set = []
	match current_accessory_set:
		0: temp_accessory_set = inventory.inv_accessory_armor
		1: temp_accessory_set = inventory.inv_accessory_cloth
		2: temp_accessory_set = inventory.inv_accessory_gears
		3: temp_accessory_set = inventory.inv_accessory_charm
	for i in range(12):
		if temp_accessory_set[i] is BasicItem and temp_accessory_set[i].item_id != "blank":
			node_array_equipment[i].get_child(0).texture = load(item_texture_path + "sm_" + temp_accessory_set[i].item_id + ".png")
		else:
			node_array_equipment[i].get_child(0).texture = null
	
	if accessories_only: return
	
	## UPDATE INVENTORY
	for i in inventory.inv_slots.size():
		if inventory.inv_slots[i] is BasicItem and inventory.inv_slots[i].item_id != "blank":
			node_array_inventory[i].get_child(0).texture = load(item_texture_path + "sm_" + inventory.inv_slots[i].item_id + ".png")
		else:
			node_array_inventory[i].get_child(0).texture = null
	
	## UPDATE ARMAMENTS
	for i in range(8):
		if inventory.inv_armaments[i] is BasicItem and inventory.inv_armaments[i].item_id != "blank":
			node_array_equipment[i+12].get_child(0).texture = load(item_texture_path + "sm_" + inventory.inv_armaments[i].item_id + ".png")
		else:
			node_array_equipment[i+12].get_child(0).texture = null
	
	## UPDATE CURSOR
	if current_cursor_item is BasicItem and current_cursor_item.item_id != "blank":
		cursor_item_texture.texture = load(item_texture_path + "sm_" + current_cursor_item.item_id + ".png")
	else:
		cursor_item_texture.texture = null

func change_accessory_set(dir : int):
	current_accessory_set += dir
	if current_accessory_set > 3: current_accessory_set = 0
	if current_accessory_set < 0: current_accessory_set = 3
	
	## UPDATE ICON PATTERN
	var pattern = accessory_tilemap.tile_set.get_pattern(current_accessory_set)
	accessory_tilemap.set_pattern(ICONS, Vector2i(2,4),pattern)
	
	## SET TEXTURES FROM INVENTORY DATA
	update_inventory_and_equipment(true)
