extends Control

@onready var hotbar_tilemap = $slot_map/TileMap
@onready var item_node = $slot_map/items
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
	if Input.is_action_just_released("hotbar_select_L"): 
		inventory.active_hotbar_item -= 1 
		if inventory.active_hotbar_item < 0: inventory.active_hotbar_item = 7
		hotbar_tilemap.clear_layer(SELECTION)
		hotbar_tilemap.set_cell(SELECTION,hotbar_index_map[inventory.active_hotbar_item],0,Vector2i(0,1))
	if Input.is_action_just_released("hotbar_select_R"): 
		inventory.active_hotbar_item += 1
		if inventory.active_hotbar_item > 7: inventory.active_hotbar_item = 0
		hotbar_tilemap.clear_layer(SELECTION)
		hotbar_tilemap.set_cell(SELECTION,hotbar_index_map[inventory.active_hotbar_item],0,Vector2i(0,1))

