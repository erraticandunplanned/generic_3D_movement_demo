#extends Node
class_name BasicItem

var quantity : int = 1
var item_id : String = "blank"

var name_default : String
var name_custom : String
var name_description : String

var supertype : String
var type : String
var subtype : String

var item_scene_path : String

var materials : Array[String] = [""]
var textures : Array[Texture2D]


#### SUPERTYPES: "Equipment", "Material", "Object"

## EQUIPMENT TYPES: ( "Armor", "Clothing", "Gear", "Charm" ) , ( "Melee", "Ranged" )
# ARMOR SUBTYPES: 
# CLOTHING SUBTYPES: 
# GEAR SUBTYPES: 
# CHARM SUBTYPES: 
# MELEE_WEAPON SUBTYPES: 
# RANGED_WEAPON SUBTYPES: 

## MATERIAL TYPES: "Botanical", "Crystalline", "Generic", "Geological", "Metallic", "Synthetic", "Water", "Zoological"
# BOTANICAL SUBTYPES: "Plant Fiber", "Wood"
# CRYSTALLINE SUBTYPES: 
# GENERIC SUBTYPES: 
# GEOLOGICAL SUBTYPES: "Igneous", Sedimentary, "Metamorphic", "Soil", "Synthetic", "Other"
# METALLIC SUBTYPES: "Alloy"
# SYNTHETIC SUBTYPES: "Otherworldly"
# WATER SUBTYPES: 
# ZOOLOGICAL SUBTYPES: "Blood", "Bone", "Fur_Hair", "Keratin", "Muscle", "Organ", "Skin_Hide", "Suet", "Coral", "Gel", "Silk", "Wax", "Wool" 

## OBJECT TYPES: "Artifice", "Component", "Furniture", "Key_Item", "Other", "Tableware", "Toolset", "Vehicle"
# ARTIFICE SUBTYPES: 
# COMPONENT SUBTYPES: 
# FURNITURE SUBTYPES: 
# KEY_ITEM SUBTYPES: 
# OTHER SUBTYPES: 
# TABLEWARE SUBTYPES: 
# TOOLSET SUBTYPES: 
# VEHICLE SUBTYPES: 
