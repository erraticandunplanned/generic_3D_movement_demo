extends Control

@onready var hotbar_tilemap = $slot_map/TileMap
@onready var item_node = $slot_map/items
@onready var armament_left_slot = $slot_map/armament_left
@onready var armament_right_slot = $slot_map/armament_right
@onready var generic_item = preload("res://items_and_materials/generic_item.tscn")
@onready var item_texture_path = "res://textures/item_images/"

var player : CharacterBody3D
#var statistics : StatisticsComponent
var inventory : InventoryComponent

enum {SELECTION, BORDER, ITEMS, ICONS, BACKGROUND}

var hotbar_index_map = [Vector2i(11,15),Vector2i(12,15),Vector2i(13,15),Vector2i(14,15),Vector2i(15,15),Vector2i(16,15),Vector2i(17,15),Vector2i(18,15)]
var hotbar_index_loc = [Vector2(1472,1984),Vector2(1600,1984),Vector2(1728,1984),Vector2(1856,1984),Vector2(1984,1984),Vector2(2112,1984),Vector2(2240,1984),Vector2(2368,1984)]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent().get_parent()
	#statistics = player.statistics
	inventory = player.find_child("ComponentGearAndInventory", false)
	
	## SET HOTBAR
	for i in hotbar_index_loc.size():
		var check_item = inventory.inv_slots[inventory.active_hotbar_start + i]
		var new_item = generic_item.instantiate()
		if check_item is Dictionary and check_item.has("item_id"):
			item_node.add_child(new_item)
			new_item.position = hotbar_index_loc[i]
			new_item.get_child(0).texture = load(item_texture_path + "sm_" + check_item.get("item_id") + ".png")
	## SET ACTIVE SLOT
	hotbar_tilemap.clear_layer(SELECTION)
	hotbar_tilemap.set_cell(SELECTION,hotbar_index_map[inventory.active_hotbar_item],0,Vector2i(0,1))
	
	## SET ARMAMENTS
	var left_armament = inventory.inv_armaments.get("left").get(0)
	if left_armament.has("item_id"):
		armament_left_slot.texture = load(item_texture_path + "lg_" + left_armament.get("item_id") + ".png")
	var right_armament = inventory.inv_armaments.get("right").get(0)
	if right_armament.has("item_id"):
		armament_right_slot.texture = load(item_texture_path + "lg_" + right_armament.get("item_id") + ".png")

func _process(delta):
	## CYCLE HOTBAR
	if Input.is_action_just_pressed("cycle_hotbar"):
		inventory.active_hotbar_start += 8
		if (inventory.active_hotbar_start + 7) > inventory.inv_slots.size(): inventory.active_hotbar_start = 0
		
		for i in item_node.get_children(): i.queue_free()
		for i in hotbar_index_loc.size():
			var check_item = inventory.inv_slots[inventory.active_hotbar_start + i]
			var new_item = generic_item.instantiate()
			if check_item is Dictionary and check_item.has("item_id"):
				item_node.add_child(new_item)
				new_item.position = hotbar_index_loc[i]
				new_item.get_child(0).texture = load(item_texture_path + "sm_" + check_item.get("item_id") + ".png")
	
	## CYCLE ACTIVE HOTBAR SLOT
	if Input.is_action_just_released("hotbar_select_L"): update_selection(-1)
	if Input.is_action_just_released("hotbar_select_R"): update_selection(1)
	if Input.is_action_just_pressed("hotbar_1"): update_selection(0, false)
	if Input.is_action_just_pressed("hotbar_2"): update_selection(1, false)
	if Input.is_action_just_pressed("hotbar_3"): update_selection(2, false)
	if Input.is_action_just_pressed("hotbar_4"): update_selection(3, false)
	if Input.is_action_just_pressed("hotbar_5"): update_selection(4, false)
	if Input.is_action_just_pressed("hotbar_6"): update_selection(5, false)
	if Input.is_action_just_pressed("hotbar_7"): update_selection(6, false)
	if Input.is_action_just_pressed("hotbar_8"): update_selection(7, false)
	if Input.is_action_just_pressed("hotbar_0"): update_selection(1)
	if Input.is_action_just_pressed("hotbar_9"): update_selection(-1)

func update_selection(amt : int, add : bool = true):
	if add:
		inventory.active_hotbar_item += amt
		inventory.active_hotbar_item = 0 if inventory.active_hotbar_item > 7 else 7 if inventory.active_hotbar_item < 0 else inventory.active_hotbar_item
	else:
		inventory.active_hotbar_item = amt
	hotbar_tilemap.clear_layer(SELECTION)
	hotbar_tilemap.set_cell(SELECTION,hotbar_index_map[inventory.active_hotbar_item],0,Vector2i(0,1))
