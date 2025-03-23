extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_start : int = 0
var active_hotbar_item : int = 0
var active_armament_left : int = 0
var active_armament_right : int = 0

var inv_slots           : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_armaments       : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_armor : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_cloth : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_gears : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_charm : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]

enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND}
#enum {helmet,breastplate,cuirass,fauld,grieves,boots,pauldron,bracer,gauntlet,pauldron,bracer,gauntlet}
#enum {hat,shirt,coat,loincloth,trousers/skirt,shoes,vest,sleeve,glove,dress,sleeve,glove}
#enum {eyewear,harness,backpack,___,holster,footgear,bandolier,sheath,diaformeter,satchel,sheath,diaformeter}
#enum {circlet,necklace,cape,waistband,garter,anklet,sash,bracelet,ring,broach,bracelet,ring}

						#############################
						## DEFAULT INVENTORY SETUP ##
						#############################

func set_default_inventory():
	inv_slots[0].quantity = 1
	inv_slots[0].item_id = "gold_sword"
	inv_slots[0].item_scene_path = "res://items_and_materials/create_cube/create_cube.tscn"
	
	inv_slots[7].quantity = 1
	inv_slots[7].item_id = "sulfur_slab"
	inv_slots[7].item_scene_path = "res://items_and_materials/leap/leap.tscn"
	
	inv_slots[2].quantity = 1
	inv_slots[2].item_id = "amethyst_shard"
	inv_slots[3].quantity = 4
	inv_slots[3].item_id = "amethyst_shard"
	inv_slots[4].quantity = 8
	inv_slots[4].item_id = "amethyst_shard"
	
	inv_accessory_armor[0].quantity = 1
	inv_accessory_armor[0].item_id = "gold_helmet"
	
	inv_armaments[0].quantity = 1
	inv_armaments[0].item_id = "amethyst_staff"
	
	#inv_slots[0].quantity = 1
	#inv_slots[0].item_id = ""
	#inv_slots[0].item_scene_path = ""
