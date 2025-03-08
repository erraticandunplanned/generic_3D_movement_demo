extends Node
class_name InventoryComponent

						############################
						## INVENTORY DICTIONARIES ##
						############################

var active_hotbar_start : int = 0
var active_hotbar_item : int = 0

var inv_slots = [
	null,
	{"quantity":1,"item_id":"gold_sword","item_name":"","item_description":""},
	{"quantity":1,"item_id":"amethyst_shard","item_name":"","item_description":""},
	null,null,null,null,null,null,null,null,null,null,null,null,null]
var inv_armaments = {
	"left":{
		0: null,
		1: null,
		2: null,
		3: null
	},
	"right":{
		0: null,
		1: null,
		2: null,
		3: null
	}
}
var inv_accessories = {
	0:{ # ARMOR SET
		Vector2i( 0, 0): null, # head   "helmet"
		Vector2i( 0,-1): null, # chest  "breastplate"
		Vector2i( 0,-2): null, # back   "cuirass"
		Vector2i( 0,-3): null, # hips   "fauld"
		Vector2i( 0,-4): null, # legs   "grieves"
		Vector2i( 0,-5): null, # feet   "boots"
		Vector2i(-1,-1): null, # l_shoulder "pauldron"
		Vector2i(-2,-1): null, # l_arm  "bracer"
		Vector2i(-3,-1): null, # l_hand "gauntlet"
		Vector2i( 1,-1): null, # r_shoulder "pauldron"
		Vector2i( 2,-1): null, # r_arm  "bracer"
		Vector2i( 3,-1): null # r_hand  "gauntlet"
	},
	1:{ # CLOTHING SET
		Vector2i( 0, 0): null, # head   "hat"
		Vector2i( 0,-1): null, # chest  "shirt"
		Vector2i( 0,-2): null, # back   "coat"
		Vector2i( 0,-3): null, # hips   "loincloth"
		Vector2i( 0,-4): null, # legs   "trousers / skirt"
		Vector2i( 0,-5): null, # feet   "shoes"
		Vector2i(-1,-1): null, # l_shoulder "vest"
		Vector2i(-2,-1): null, # l_arm  "sleeve"
		Vector2i(-3,-1): null, # l_hand "glove"
		Vector2i( 1,-1): null, # r_shoulder "dress"
		Vector2i( 2,-1): null, # r_arm  "sleeve"
		Vector2i( 3,-1): null # r_hand  "glove:
	},
	2:{ # GEAR SET
		Vector2i( 0, 0): null, # head   "eyewear"
		Vector2i( 0,-1): null, # chest  "harness"
		Vector2i( 0,-2): null, # back   "backpack"
		Vector2i( 0,-3): null, # hips   "
		Vector2i( 0,-4): null, # legs   "holster"
		Vector2i( 0,-5): null, # feet   "footgear"
		Vector2i(-1,-1): null, # l_shoulder "bandolier"
		Vector2i(-2,-1): null, # l_arm  "sheath"
		Vector2i(-3,-1): null, # l_hand "diaformeter"
		Vector2i( 1,-1): null, # r_shoulder "satchel"
		Vector2i( 2,-1): null, # r_arm  "sheath"
		Vector2i( 3,-1): null # r_hand  "diaformeter"
	},
	3:{ # CHARM SET
		Vector2i( 0, 0): null, # head   "circlet"
		Vector2i( 0,-1): null, # chest  "necklace"
		Vector2i( 0,-2): null, # back   "cape"
		Vector2i( 0,-3): null, # hips   "waistband"
		Vector2i( 0,-4): null, # legs   "garter"
		Vector2i( 0,-5): null, # feet   "anklet"
		Vector2i(-1,-1): null, # l_shoulder "sash"
		Vector2i(-2,-1): null, # l_arm  "bracelet"
		Vector2i(-3,-1): null, # l_hand "ring"
		Vector2i( 1,-1): null, # r_shoulder "broach"
		Vector2i( 2,-1): null, # r_arm  "bracelet"
		Vector2i( 3,-1): null # r_hand  "ring"
	}
}
