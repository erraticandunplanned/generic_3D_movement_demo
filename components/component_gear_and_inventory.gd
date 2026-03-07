extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_index : int = 0
var active_hotbar_item : int = 0
var active_armament_left : int = 0
var active_armament_right : int = 0

var inv_slots           : Array[BasicItem] = [null, null, null, null, null, null, null, null, null, null, null, null]
var inv_armaments       : Array[BasicItem] = [null, null, null, null, null, null, null, null]
var inv_accessory_armor : Array[BasicItem] = [null, null, null, null, null, null, null, null, null, null, null, null]
var inv_accessory_cloth : Array[BasicItem] = [null, null, null, null, null, null, null, null, null, null, null, null]
var inv_accessory_gears : Array[BasicItem] = [null, null, null, null, null, null, null, null, null, null, null, null]
var inv_accessory_charm : Array[BasicItem] = [null, null, null, null, null, null, null, null, null, null, null, null]

var container_matrix = [
		[{"size":2,"id":123}]
	]

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
	inv_armaments[0] = DataManager.create_item("ore")
	inv_armaments[2] = DataManager.create_item("slab")
	inv_armaments[3] = DataManager.create_item("shell")
	_add_container_to_matrix(inv_armaments[3].unique_id)
	inv_armaments[4] = DataManager.create_item("shard")

func _add_container_to_matrix(new_container_unique_id : int):
	for row : Array in container_matrix:
		for container : Dictionary in row:
			pass
	pass

func _relocate_container_in_slot(from_slot : Vector2i, to_slot : Vector2i):
	pass

func _relocate_container_in_matrix(from_index : Vector2i, to_index : Vector2i):
	pass
