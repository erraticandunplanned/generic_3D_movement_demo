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
	null,null,null,null,null,null,
	{"quantity":1,"item_id":"sulfur_slab","item_name":"","item_description":""},
	null,null,null,null,
	{"quantity":1,"item_id":"amethyst_staff","item_name":"","item_description":""},
	null]
var inv_armaments = {
	"left":{
		0: {},
		2: {},
		1: {},
		3: {}
	},
	"right":{
		0: {},
		1: {},
		2: {},
		3: {}
	}
}
var inv_accessories = {
	0:{ # ARMOR SET
		"head" : {}, 		# helmet
		"chest" : {}, 		# breastplate
		"back" : {}, 		# cuirass
		"hips" : {}, 		# fauld
		"legs" : {}, 		# grieves
		"feet" : {}, 		# boots
		"l_shoulder" : {}, 	# pauldron
		"l_arm" : {}, 		# bracer
		"l_hand" : {}, 		# gauntlet
		"r_shoulder" : {}, 	# pauldron
		"r_arm" : {}, 		# bracer
		"r_hand" : {} 		# gauntlet
	},
	1:{ # CLOTHING SET
		"head" : {}, 	   # hat
		"chest" : {}, 	   # shirt
		"back" : {}, 	   # coat
		"hips" : {}, 	   # loincloth
		"legs" : {}, 	   # trousers / skirt
		"feet" : {}, 	   # shoes
		"l_shoulder" : {}, # vest
		"l_arm" : {}, 	   # sleeve
		"l_hand" : {}, 	   # glove
		"r_shoulder" : {}, # dress
		"r_arm" : {}, 	   # sleeve
		"r_hand" : {} 	   # glove
	},
	2:{ # GEAR SET
		"head" : {},       # eyewear
		"chest" : {},      # harness
		"back" : {},       # backpack
		"hips" : {},       # ___
		"legs" : {},       # holster
		"feet" : {},       # footgear
		"l_shoulder" : {}, # bandolier
		"l_arm" : {},      # sheath
		"l_hand" : {},     # diaformeter
		"r_shoulder" : {}, # satchel
		"r_arm" : {},      # sheath
		"r_hand" : {}      # diaformeter
	},
	3:{ # CHARM SET
		"head" : {},       # circlet
		"chest" : {},      # necklace
		"back" : {},       # cape
		"hips" : {},       # waistband
		"legs" : {},       # garter
		"feet" : {},       # anklet
		"l_shoulder" : {}, # sash
		"l_arm" : {},      # bracelet
		"l_hand" : {},     # ring
		"r_shoulder" : {}, # broach
		"r_arm" : {},      # bracelet
		"r_hand" : {}      # ring
	}
}
