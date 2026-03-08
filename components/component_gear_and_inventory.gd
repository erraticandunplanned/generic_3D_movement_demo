extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_index   : int = 0
var active_hotbar_item    : int = 0
var active_armament_left  : int = 0
var active_armament_right : int = 0

const hotbar_width = 11 # width = 12 if you count index 0
enum {ARMOR, CLOTH, GEARS, CHARM, ARMAMENTS}
enum {L0, L1, L2, L3, R0, R1, R2, R3}
enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND}
#specifics
#enum {helmet,breastplate,cuirass,fauld,grieves,boots,pauldron,bracer,gauntlet,pauldron,bracer,gauntlet}
#enum {hat,shirt,coat,loincloth,trousers/skirt,shoes,vest,sleeve,glove,dress,sleeve,glove}
#enum {eyewear,harness,backpack,___,holster,footgear,bandolier,sheath,diaformeter,satchel,sheath,diaformeter}
#enum {circlet,necklace,cape,waistband,garter,anklet,sash,bracelet,ring,broach,bracelet,ring}

var equipment : Dictionary[int,Array] = {
	ARMOR     : [null, null, null, null, null, null, null, null, null, null, null, null], 
	CLOTH     : [null, null, null, null, null, null, null, null, null, null, null, null], 
	GEARS     : [null, null, null, null, null, null, null, null, null, null, null, null], 
	CHARM     : [null, null, null, null, null, null, null, null, null, null, null, null],
	ARMAMENTS : [null, null, null, null, null, null, null, null]
}

var inv_slots = [] ##remove

var container_matrix = [[]]


						#############################
						## DEFAULT INVENTORY SETUP ##
						#############################

func set_default_inventory():
	equipment[ARMAMENTS][0] = DataManager.create_item("ore")
	equipment[ARMAMENTS][2] = DataManager.create_item("slab")
	equipment[ARMAMENTS][3] = DataManager.create_item("shell")
	equipment[ARMAMENTS][4] = DataManager.create_item("shard")
	
	equipment[ARMAMENTS][3]._insert_item(DataManager.create_item("shard"), 1)
	
	_add_container_to_matrix(Vector2i(4,3), equipment.get(ARMAMENTS)[3].container.size())

func _add_container_to_matrix(new_container_location: Vector2i, new_container_size : int):
	var new_dict_entry : Dictionary = {"size":new_container_size,"slot":new_container_location}
	## FIND THE FIRST ROW IN THE CONTAINER_MATRIX THAT CAN ACCOMIDATE THE NEW CONTAINER WITHOUT OVERFLOW
	var row_to_append : int = -1
	for i in container_matrix.size():
		var length_of_this_row = 0
		for j : Dictionary in container_matrix[i]:
			length_of_this_row += j.get("size")
		if length_of_this_row + new_container_size <= (hotbar_width+1): 
			row_to_append = i
			break
	## IF THERE IS NO VALID ROW, ADD A NEW ONE
	if row_to_append == -1:
		var new_row : Array = [new_dict_entry]
		container_matrix.append(new_row)
	## ELSE, ADD TO THE VALID ROW
	else:
		container_matrix[row_to_append].append(new_dict_entry)

func _relocate_container_in_slot(from_slot : Vector2i, to_slot : Vector2i):
	for i in container_matrix:
		for j : Dictionary in i:
			if j.get("slot") == from_slot: 
				j.set("slot",to_slot)
				return
	push_warning("container ", from_slot, "not found in container_matrix.")

func _relocate_container_in_matrix(from_index : Vector2i, to_index : Vector2i):
	var entry = container_matrix[from_index.x].pop_at(from_index.y)
	container_matrix[to_index.x].insert(to_index.y, entry)
