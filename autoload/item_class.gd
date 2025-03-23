extends Resource
class_name BasicItem

@export var quantity : int
@export var item_id : String = "blank"

#var name_default : String
#var name_custom : String
#var name_description : String

#var supertype : String
#var type : String
#var subtype : String

@export var item_scene_path : String

#var materials : Array[String] = [""]
#var textures : Array[Texture2D]

func _init(p_quantity = 0, p_item_id = "blank", p_item_scene_path = ""):
	quantity = p_quantity
	item_id = p_item_id
	#name_default = ""
	#name_custom = ""
	#name_description = ""
	#supertype = ""
	#type = ""
	#subtype = ""
	item_scene_path = item_scene_path
	#materials : Array[String] = [""]
	#textures : Array[Texture2D]

#### SUPERTYPES: "Component", "Equipment", "Structure", "Tool"

## COMPONENT TYPES: "Botanical", "Crystalline", "Generic", "Geological", "Metallic", "Synthetic", "Water", "Zoological"
# BOTANICAL SUBTYPES: "Plant Fiber", "Wood"
# CRYSTALLINE SUBTYPES: 
# GENERIC SUBTYPES: 
# GEOLOGICAL SUBTYPES: "Igneous", Sedimentary, "Metamorphic", "Soil", "Synthetic", "Other"
# METALLIC SUBTYPES: "Alloy"
# SYNTHETIC SUBTYPES: "Otherworldly"
# WATER SUBTYPES: 
# ZOOLOGICAL SUBTYPES: "Blood", "Bone", "Fur_Hair", "Keratin", "Muscle", "Organ", "Skin_Hide", "Suet", "Coral", "Gel", "Silk", "Wax", "Wool" 

## EQUIPMENT TYPES: ( "Armor", "Clothing", "Gear", "Charm" ) , ( "Melee", "Ranged" )
# ARMOR SUBTYPES: 
# CLOTHING SUBTYPES: 
# GEAR SUBTYPES: 
# CHARM SUBTYPES: 
# MELEE_WEAPON SUBTYPES: 
# RANGED_WEAPON SUBTYPES: 

## STRUCTURE TYPES: "Artifice", "Furniture", "Tableware", "Vehicle"
# ARTIFICE SUBTYPES: 
# FURNITURE SUBTYPES: 
# TABLEWARE SUBTYPES: 
# VEHICLE SUBTYPES: 

## TOOL TYPES: "Key_Item", "Other", "Toolset"
# KEY_ITEM SUBTYPES: 
# OTHER SUBTYPES: 
# TOOLSET SUBTYPES: 

