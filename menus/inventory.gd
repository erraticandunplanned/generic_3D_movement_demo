extends Control

@onready var inventory_node          : Node2D = $inventory
@onready var equipment_node          : Node2D = $slotmap/EquipmentLayout
@onready var container_node          : Node2D = $slotmap/containers
@onready var selection_tilemap : TileMapLayer = $slotmap/slot_selection
@onready var cursor_node             : Node2D = $cursor
@onready var cursor_item_texture     : Node2D = $cursor/InventoryItemTexture
@onready var item_texture_path       : String = "res://textures/item_images/"
@onready var item_texture_node  : PackedScene = preload("res://items_and_materials/inventory_item_texture.tscn")
@onready var single_container   : PackedScene = preload("res://menus/single_inventory_container.tscn")

var player : CharacterBody3D
var statistics : StatisticsComponent
var inventory : InventoryComponent

const inventory_begin_location  = Vector2i(0,0)
#const equipment_location_array  = [Vector2i(5,4),Vector2i(5,5),Vector2i(5,6),Vector2i(5,7),Vector2i(5,8),Vector2i(5,9),Vector2i(4,5),Vector2i(3,5),Vector2i(2,5),Vector2i(6,5),Vector2i(7,5),Vector2i(8,5),Vector2i(2,7),Vector2i(3,7),Vector2i(2,8),Vector2i(3,8),Vector2i(7,7),Vector2i(8,7),Vector2i(7,8),Vector2i(8,8)]
const equipment_location_array = [
	Vector2i(-5,0), ## HEAD
	Vector2i(-5,1), ## CHEST
	Vector2i(-5,2), ## BACK
	Vector2i(-5,3), ## HIPS
	Vector2i(-5,4), ## LEGS
	Vector2i(-5,5), ## FEET
	Vector2i(-6,1), ## L_SHOULDER
	Vector2i(-7,1), ## L_ARM
	Vector2i(-8,1), ## L_HAND
	Vector2i(-4,1), ## R_SHOULDER
	Vector2i(-3,1), ## R_ARM
	Vector2i(-2,1), ## R_HAND
	Vector2i(-7,3), ## A_L0
	Vector2i(-6,4), ## A_L1
	Vector2i(-7,5), ## A_L2
	Vector2i(-8,4), ## A_L3
	Vector2i(-3,3), ## A_R0
	Vector2i(-2,4), ## A_R1
	Vector2i(-3,5), ## A_R2
	Vector2i(-4,4), ## A_R3
]

const hotbar_vertical_offset = 64
const hotbar_horizontal_offset = 64

var current_accessory_set = 0
var screen_size : Vector2
var cursor_mode = true
var tile_location : Vector2i
var current_cursor_item : BasicItem = BasicItem.new()

func _ready():
	## STATISTICS SETUP
	player = get_parent().get_parent().get_parent()
	statistics = player.statistics
	inventory = player.find_child("ComponentGearAndInventory", false)
	
	## MOUSE SETUP
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	screen_size = get_viewport_rect().size / 2
	cursor_node.position = selection_tilemap.map_to_local(inventory_begin_location) + $slotmap.global_position
	
	## SLOT SETUP
	update_inventory_containers()
	update_equipment_layout()
	#update_inventory_and_equipment()
	
	## SET HOTBAR OUTLINE CORRECTLY
	pass

func _input(event):
	## MOVE CURSOR ACCORDING TO CONTINUOUS MOUSE MOVEMENT
	if event is InputEventMouseMotion:
		cursor_mode = true
		cursor_node.position.x += event.relative.x * statistics.menu_mouse_speed
		cursor_node.position.y += event.relative.y * statistics.menu_mouse_speed
		cursor_node.position.x = clamp(cursor_node.position.x, -screen_size.x, screen_size.x)
		cursor_node.position.y = clamp(cursor_node.position.y, -screen_size.y, screen_size.y)

func _process(_delta):
	## RETURN TO GAME ON CANCEL PRESS
	if Input.is_action_just_pressed("ui_cancel"): player.swap_to_menu("HUD")
	
	## TAB THROUGH ACCESSORY SETS
	if Input.is_action_just_pressed("ui_tab_left"): change_accessory_set(-1)
	if Input.is_action_just_pressed("ui_tab_right"): change_accessory_set(1)
	
	## MOVE ACTIVE HOTBAR
	if Input.is_action_just_pressed("cycle_hotbar"):
		pass
		#inventory.active_hotbar_start += 8
		#if (inventory.active_hotbar_start + 7) > inventory.inv_slots.size(): inventory.active_hotbar_start = 0
		#hotbar_outline.position.y = 512 + (floor(inventory.active_hotbar_start / 8) * 128)
	
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
	
	## MOVE CURSOR ACCORDING TO DISCRETE BUTTON INPUT (DPAD OR ARROW KEYS)
	## TODO: CONSTANT DISCRETE MOVEMENT IF BUTTON IS HELD DOWN (WITH INCREASING SPEED)
	var discrete_input : Vector2i = Vector2i.LEFT if Input.is_action_just_pressed("ui_left") else Vector2i.RIGHT if Input.is_action_just_pressed("ui_right") else Vector2i.UP if Input.is_action_just_pressed("ui_up") else Vector2i.DOWN if Input.is_action_just_pressed("ui_down") else Vector2i.ZERO
	if discrete_input != Vector2i.ZERO:
		cursor_mode = false
		tile_location += discrete_input
		cursor_node.position = selection_tilemap.map_to_local(tile_location) + (selection_tilemap.global_position - self.global_position)
	
	## SET SELECTION TO TILE SET MAP SPACE
	selection_tilemap.clear()
	tile_location = selection_tilemap.local_to_map(cursor_node.global_position - selection_tilemap.global_position)
	selection_tilemap.set_cell(tile_location,0,Vector2i.ZERO)
	
	
	## IF DISCRETE MOVEMENT ATTEMPTS TO MOVE THE SELECTION OFF THE INVENTORY AREA, 
	## FIND THE NEXT MOST REASONABLE SELECTION AND MOVE THE CURSOR THERE
	#if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) == null:
		#if cursor_mode:
			### IF NOT VALID AND CURSOR_MODE IS TRUE, SELECTION IS NULL
			#tile_location = Vector2i(-1,-1)
		#else:
			### IF NOT VALID AND CURSOR_MODE IS FALSE, MOVE TO CLOSEST VALID TILE
			#var new_tile_location = tile_location
			#var attempts = 0
			#var new_lines = 0
			#while accessory_tilemap.get_cell_tile_data(BORDER,new_tile_location) == null:
				#attempts += 1
				### SCAN THE COLUMN/ROW OF INPUT DIRECTION FOR A VALID TILE
				#new_tile_location += discrete_input
				### IF NOTHING IS FOUND, CHECK ROW/COLUMN ABOVE AND BELOW
				#var request_new_line = true if new_tile_location.x < 0 or new_tile_location.y < 0 or new_tile_location.x > 20 or new_tile_location.y > 20 else false
				#if request_new_line:
					#new_lines += 1
					#var dir = Vector2i(discrete_input.y,discrete_input.x) if new_lines % 2 == 1 else Vector2i(-discrete_input.y,-discrete_input.x)
					#var amt = ceil(new_lines/2)
					#new_tile_location = tile_location + (dir * amt)
				### IF NOTHING IS FOUND, BREAK LOOP AND RETURN FALSE
				#var request_break = true if attempts > 100 else false
				#if request_break:
					#new_tile_location = tile_location - discrete_input
					#break
			### SET SELECTION TO NEW TILE
			#tile_location = new_tile_location
			#cursor_node.position = accessory_tilemap.map_to_local(tile_location)
			### IF VALID, SET SELECTION. IF NOT, SEND THE SELECTION TO THE VOID (TM)
			#if accessory_tilemap.get_cell_tile_data(BORDER,tile_location) == null: 
				#tile_location = Vector2i(-1,-1)
			#else:
				#accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	#else:
		#accessory_tilemap.set_cell(SELECTION,tile_location,0,Vector2i(0,0))
	
	## CURSOR IS INVISIBLE IF CURSOR MODE IS FALSE
	cursor_node.get_child(0).visible = cursor_mode
	
						################################################################
						## PICKING UP, PLACING DOWN, AND SWAPPING ITEMS ON THE CURSOR ##
						################################################################
	
	#### PREPARE FOR SELECTION ####
	
	var index = -1
	var item_under_cursor : BasicItem = BasicItem.new()
	## TODO: find a way for this to work with current containers
	#var tile_is_valid = false if tile_location == Vector2i(-1,-1) else true
	if equipment_location_array.has(tile_location): pass
	
	
	
	#if tile_is_valid:
		### FIND INVENTORY AND EQUIPMENT INDEX
		#index = ( tile_location.x - inventory_begin_location.x ) + ( ( tile_location.y - inventory_begin_location.y ) * 8) if tile_location.x > 9 else equipment_location_array.find(tile_location)
		#if index == -1: push_warning("ERROR! invalid slot index.")
		### IDENTIFY THE ITEM UNDER THE CURSOR
		#if tile_location.x > 9: ## INVENTORY
			#item_under_cursor = inventory.inv_slots[index]
		#elif index < 12: ## ACCESSORIES
			#match current_accessory_set:
				#0: item_under_cursor = inventory.inv_accessory_armor[index]
				#1: item_under_cursor = inventory.inv_accessory_cloth[index]
				#2: item_under_cursor = inventory.inv_accessory_gears[index]
				#3: item_under_cursor = inventory.inv_accessory_charm[index]
		#else: ## ARMAMENTS
			#item_under_cursor = inventory.inv_armaments[index-12]
	
	#### BASIC SELECT (LEFT CLICK, CONTROLLER BUTTON 0 / BOTTOM ACTION) ####
	
	if Input.is_action_just_pressed("ui_select") and index != -1:
		## PLACE CURSOR ITEM IN A BOX FOR LATER
		var liminal_cursor_item = current_cursor_item
		current_cursor_item = BasicItem.new()
		
		## STACK ITEM IF IT IS THE SAME AS CURSOR ITEM
		if item_under_cursor.item_id == liminal_cursor_item.item_id:
			liminal_cursor_item.quantity += item_under_cursor.quantity
		## ELSE, PICK UP ITEM
		else:
			current_cursor_item = item_under_cursor
		
		## PLACE ITEM INTO SLOT
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
		#update_inventory_and_equipment()
	
	#### ALTERNATE SELECT (RIGHT CLICK, CONTROLLER BUTTON 2 / LEFT ACTION) ####
	
	if Input.is_action_just_pressed("ui_select_alternate") and index != -1:
		## PICK UP HALF QUANTITY
		if current_cursor_item.item_id == "":
			current_cursor_item = item_under_cursor.duplicate()
			var half_quantity_floor = item_under_cursor.quantity / 2
			var half_quantity_ceil = item_under_cursor.quantity - half_quantity_floor
			current_cursor_item.quantity = half_quantity_ceil
			item_under_cursor.quantity = half_quantity_floor
			## REMOVE ITEM FROM SLOT IF QUANTITY IS 0 OR LESS
			if item_under_cursor.quantity <= 0:
				if tile_location.x > 9: ## INVENTORY
					inventory.inv_slots[index] = BasicItem.new()
				elif index < 12: ## ACCESSORIES
					match current_accessory_set:
						0: inventory.inv_accessory_armor[index] = BasicItem.new()
						1: inventory.inv_accessory_cloth[index] = BasicItem.new()
						2: inventory.inv_accessory_gears[index] = BasicItem.new()
						3: inventory.inv_accessory_charm[index] = BasicItem.new() 
				else: ## ARMAMENTS
					inventory.inv_armaments[index-12] = BasicItem.new()
		## PLACE 1 ITEM INTO EMPTY SLOT
		elif item_under_cursor.item_id == current_cursor_item.item_id:
			item_under_cursor.quantity += 1
			current_cursor_item.quantity -= 1
		## ADD 1 TO SIMILAR STACK
		elif item_under_cursor.item_id == "":
			current_cursor_item.quantity -= 1
			if tile_location.x > 9: ## INVENTORY
				inventory.inv_slots[index] = current_cursor_item.duplicate()
				inventory.inv_slots[index].quantity = 1
			elif index < 12: ## ACCESSORIES
				match current_accessory_set:
					0: 
						inventory.inv_accessory_armor[index] = current_cursor_item.duplicate()
						inventory.inv_accessory_armor[index].quantity = 1
					1: 
						inventory.inv_accessory_cloth[index] = current_cursor_item.duplicate()
						inventory.inv_accessory_cloth[index].quantity = 1
					2: 
						inventory.inv_accessory_gears[index] = current_cursor_item.duplicate()
						inventory.inv_accessory_gears[index].quantity = 1
					3: 
						inventory.inv_accessory_charm[index] = current_cursor_item.duplicate()
						inventory.inv_accessory_charm[index].quantity = 1
			else: ## ARMAMENTS
				inventory.inv_armaments[index-12] = current_cursor_item.duplicate()
				inventory.inv_armaments[index-12].quantity = 1
		
		## REMOVE ITEM FROM CURSOR IF QUANTITY IS 0 OR LESS
		if current_cursor_item.quantity <= 0: current_cursor_item = BasicItem.new()
		## UPDATE CURSOR TEXTURE AND SLOT TEXTURES FROM INVENTORY DATA
		#update_inventory_and_equipment()----------------------------------------------------------------------------------------------------
	
	#### STACK SELECT (SHIFT + LEFT CLICK, CONTROLLER BUTTON 3 / TOP ACTION) ####
	
	if Input.is_action_just_pressed("ui_select_stack") and index != -1:
		pass

func update_inventory_containers():
	## CLEAR CONTAINERS AND REMAKE FROM CONTAINER_MATRIX
	for i in container_node.get_children(): i.queue_free()
	var current_row := 0
	for row in inventory.container_matrix.size():
		current_row = row
		var current_column := 0
		for column in inventory.container_matrix[row].size():
			var entry = inventory.container_matrix[row][column]
			var new_container = single_container.instantiate()
			container_node.add_child(new_container)
			new_container.position = Vector2( current_column * hotbar_horizontal_offset , current_row * hotbar_vertical_offset )
			## SET CONTAINER VALUES - SIZE, STATE, AND COLOR
			var target_size = entry.get("size")
			var target_state = 0 if ( current_row == 0 and current_column == 0 ) else 1 if current_row == 0 else 2 if current_column == 0 else 3
			var target_color = Color(randf(),randf(),randf())
			new_container.set_all(target_size, target_state, target_color)
			## OFFSET COLUMN FOR THE NEXT CONTAINER
			current_column += target_size
	
	## FILL CONTAINERS WITH RELEVANT ITEMS

func update_equipment_layout():
	var single_equipment_array = inventory.equipment[current_accessory_set] + inventory.equipment[4]
	for i in single_equipment_array.size():
		var texture_in_question = single_equipment_array[i].texture if single_equipment_array[i] is BasicItem else ItemTexture.new()
		equipment_node.set_texture(i,texture_in_question)

func change_accessory_set(dir : int):
	current_accessory_set = 3 if current_accessory_set + dir < 0 else 0 if current_accessory_set + dir > 3 else current_accessory_set + dir
	equipment_node.swap_equipment_layout(current_accessory_set)
	update_equipment_layout()
