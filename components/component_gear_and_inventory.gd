extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_start : int = 0
var active_hotbar_item : int = 0

var inv_slots = [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]

var inv_armaments = [null,null,null,null,null,null,null,null]

#var inv_armament_L0 = null
#var inv_armament_L1 = null
#var inv_armament_L2 = null
#var inv_armament_L3 = null
#var inv_armament_R0 = null
#var inv_armament_R1 = null
#var inv_armament_R2 = null
#var inv_armament_R3 = null

enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND}
#enum {helmet,breastplate,cuirass,fauld,grieves,boots,pauldron,bracer,gauntlet,pauldron,bracer,gauntlet}
#enum {hat,shirt,coat,loincloth,trousers/skirt,shoes,vest,sleeve,glove,dress,sleeve,glove}
#enum {eyewear,harness,backpack,___,holster,footgear,bandolier,sheath,diaformeter,satchel,sheath,diaformeter}
#enum {circlet,necklace,cape,waistband,garter,anklet,sash,bracelet,ring,broach,bracelet,ring}

var inv_accessory_armor = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_cloth = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_gears = [null,null,null,null,null,null,null,null,null,null,null,null]
var inv_accessory_charm = [null,null,null,null,null,null,null,null,null,null,null,null]

func set_default_inventory():
	var new_item_1 = BasicItem.new()
	new_item_1.quantity = 1
	new_item_1.item_id = "gold_sword"
	inv_slots[2] = new_item_1
	
	var new_item_2 = BasicItem.new()
	new_item_2.quantity = 1
	new_item_2.item_id = "sulfur_slab"
	inv_slots[7] = new_item_2
