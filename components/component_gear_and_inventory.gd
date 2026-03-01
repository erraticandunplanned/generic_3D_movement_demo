extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_start : int = 0
var active_hotbar_item : int = 0
var active_armament_left : int = 0
var active_armament_right : int = 0

var inv_slots           : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_armaments       : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_armor : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_cloth : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_gears : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
var inv_accessory_charm : Array[BasicItem] = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]


const hotbar_width = 11 # width = 12 if you count index 0
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
	inv_slots[0].supertype = "equipment"
	inv_slots[0].type = "armament"
	inv_slots[0].subtype = "melee_standard"
	inv_slots[0].armament_script_path = "res://items_and_materials/active_ability_scripts/create_cube.gd"
	
	inv_slots[7].quantity = 1
	inv_slots[7].item_id = "sulfur_slab"
	inv_slots[7].supertype = "component"
	inv_slots[7].type = "geological"
	inv_slots[7].hotbar_script_path = "res://items_and_materials/active_ability_scripts/leap.gd"
	
	inv_slots[2].quantity = 1
	inv_slots[2].item_id = "amethyst_shard"
	inv_slots[2].supertype = "component"
	inv_slots[2].type = "crystalline"
	inv_slots[3].quantity = 4
	inv_slots[3].item_id = "amethyst_shard"
	inv_slots[3].supertype = "component"
	inv_slots[3].type = "crystalline"
	inv_slots[4].quantity = 8
	inv_slots[4].item_id = "amethyst_shard"
	inv_slots[4].supertype = "component"
	inv_slots[4].type = "crystalline"
	
	inv_accessory_armor[0].quantity = 1
	inv_accessory_armor[0].item_id = "gold_helmet"
	inv_accessory_armor[0].supertype = "equipment"
	inv_accessory_armor[0].type = "armor"
	inv_accessory_armor[0].subtype = "head"
	
	inv_accessory_gears[2].quantity = 1
	inv_accessory_gears[2].item_id = "basket"
	inv_accessory_gears[2].supertype = "equipment"
	inv_accessory_gears[2].type = "gear"
	inv_accessory_gears[2].subtype = "container"
	inv_accessory_gears[2].container = [BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new(),BasicItem.new()]
	
	inv_accessory_gears[2].container[1].quantity = 1
	inv_accessory_gears[2].container[1].item_id = "amethyst_shard"
	inv_accessory_gears[2].container[1].supertype = "component"
	inv_accessory_gears[2].container[1].type = "crystalline"
	
	#inv_accessory_gears[3].quantity = 1
	#inv_accessory_gears[3].item_id = "basket"
	#inv_accessory_gears[3].supertype = "equipment"
	#inv_accessory_gears[3].type = "gear"
	#inv_accessory_gears[3].subtype = "container"
	#inv_accessory_gears[3].container = []
	
	inv_armaments[0].quantity = 1
	inv_armaments[0].item_id = "amethyst_staff"
	inv_armaments[0].supertype = "equipment"
	inv_armaments[0].type = "armament"
	inv_armaments[0].subtype = "spellcasting"
	
	#inv_slots[0].quantity = 1
	#inv_slots[0].item_id = ""
	#inv_slots[0].supertype = ""
	#inv_slots[0].type = ""
	#inv_slots[0].subtype = ""
	#inv_slots[0].hotbar_script_path = ""
	#inv_slots[0].armament_script_path = ""
	#inv_slots[0].accessory_script_path = ""
