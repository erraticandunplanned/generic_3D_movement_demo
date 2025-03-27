extends Resource
class_name BasicItem

@export var quantity : int
@export var item_id : String

@export var supertype : String
@export var type : String
@export var subtype : String

@export var hotbar_script_path : String
@export var armament_script_path : String
@export var accessory_script_path : String

#var name_default : String
#var name_custom : String
#var name_description : String
#var materials : Array[String] = [""]
#var textures : Array[Texture2D]

func _init(p_quantity = 0, p_item_id = "", p_supertype = "", p_type = "", p_subtype = "", p_hotbar_script_path = "", p_armament_script_path = "", p_accessory_script_path = ""):
	quantity = p_quantity
	item_id = p_item_id
	supertype = p_supertype
	type = p_type
	subtype = p_subtype
	hotbar_script_path = p_hotbar_script_path
	armament_script_path = p_armament_script_path
	accessory_script_path = p_accessory_script_path
	#name_default = ""
	#name_custom = ""
	#name_description = ""
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

