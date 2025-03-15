extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_start : int = 0
var active_hotbar_item : int = 0
var active_armament_left : int = 0
var active_armament_right : int = 0

var inv_slots = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
var inv_armaments = [null,null,null,null,null,null,null,null]
var inv_accessory_armor = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_cloth = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_gears = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_charm = [null,null,null,null,null,null,null,null,null,null,null,null]

enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND}
#enum {helmet,breastplate,cuirass,fauld,grieves,boots,pauldron,bracer,gauntlet,pauldron,bracer,gauntlet}
#enum {hat,shirt,coat,loincloth,trousers/skirt,shoes,vest,sleeve,glove,dress,sleeve,glove}
#enum {eyewear,harness,backpack,___,holster,footgear,bandolier,sheath,diaformeter,satchel,sheath,diaformeter}
#enum {circlet,necklace,cape,waistband,garter,anklet,sash,bracelet,ring,broach,bracelet,ring}

						#############################
						## DEFAULT INVENTORY SETUP ##
						#############################

func set_default_inventory():
	var new_item_1 = BasicItem.new()
	new_item_1.quantity = 1
	new_item_1.item_id = "gold_sword"
	new_item_1.item_scene_path = "res://player/create_cube/create_cube.tscn"
	inv_armaments[0] = new_item_1
	
	var new_item_2 = BasicItem.new()
	new_item_2.quantity = 1
	new_item_2.item_id = "sulfur_slab"
	new_item_2.item_scene_path = "res://player/leap/leap.tscn"
	inv_slots[7] = new_item_2
	
	var new_item_3 = BasicItem.new()
	new_item_3.quantity = 1
	new_item_3.item_id = "gold_helmet"
	inv_accessory_armor[0] = new_item_3
	
	var new_item_4 = BasicItem.new()
	new_item_4.quantity = 1
	new_item_4.item_id = "amethyst_shard"
	inv_slots[2] = new_item_4
	
	var new_item_5 = BasicItem.new()
	new_item_5.quantity = 1
	new_item_5.item_id = "amethyst_staff"
	inv_armaments[1] = new_item_5
