class_name DataIngredients

const DEFAULT_SUPERTYPE             := ""
const DEFAULT_TYPE                  := ""
const DEFAULT_SUBTYPE               := ""
const DEFAULT_CONTAINER             := []
const DEFAULT_HOTBAR_SCRIPT_PATH    := ""
const DEFAULT_ARMAMENT_SCRIPT_PATH  := ""
const DEFAULT_ACCESSORY_SCRIPT_PATH := ""

const Ingredients = {
	"slab" :{
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "item_texture_lines.png",
			"atlas_id_fillA"   : "item_texture_fillA.png",
			"atlas_id_fillB"   : "item_texture_fillB.png",
			"atlas_coordinate" : Vector2i(0,0),
			"fill_color_A"     : Color.GOLDENROD,
			"fill_color_B"     : Color.WHITE
		},
		"supertype"            : "ingredient",
		"type"                 : "geological",
		"subtype"              : "",
		"container"            : [],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	},
	"shard" :{
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "item_texture_lines.png",
			"atlas_id_fillA"   : "item_texture_fillA.png",
			"atlas_id_fillB"   : "item_texture_fillB.png",
			"atlas_coordinate" : Vector2i(2,0),
			"fill_color_A"     : Color.MEDIUM_PURPLE,
			"fill_color_B"     : Color.WHITE
		},
		"supertype"            : "ingredient",
		"type"                 : "crystalline",
		"subtype"              : "",
		"container"            : [],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	},
	"ore" :{
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "item_texture_lines.png",
			"atlas_id_fillA"   : "item_texture_fillA.png",
			"atlas_id_fillB"   : "item_texture_fillB.png",
			"atlas_coordinate" : Vector2i(3,0),
			"fill_color_A"     : Color.CORAL,
			"fill_color_B"     : Color.WEB_GRAY
		},
		"supertype"            : "ingredient",
		"type"                 : "metallic",
		"subtype"              : "",
		"container"            : [],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	},
	"shell" :{
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "item_texture_lines.png",
			"atlas_id_fillA"   : "item_texture_fillA.png",
			"atlas_id_fillB"   : "item_texture_fillB.png",
			"atlas_coordinate" : Vector2i(1,5),
			"fill_color_A"     : Color.SEA_GREEN,
			"fill_color_B"     : Color.WHITE
		},
		"supertype"            : "ingredient",
		"type"                 : "biological",
		"subtype"              : "",
		"container"            : [null,null,null],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	},
	
	
	"backpack" : {
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "item_texture_lines.png",
			"atlas_id_fillA"   : "item_texture_fillA.png",
			"atlas_id_fillB"   : "item_texture_fillB.png",
			"atlas_coordinate" : Vector2i(2,4),
			"fill_color_A"     : Color.SALMON,
			"fill_color_B"     : Color.PALE_GREEN
		},
		"supertype"            : "",
		"type"                 : "",
		"subtype"              : "",
		"container"            : [null,null,null,null,null,null,null,null,null,null,null,null],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	},
	
	
	"_ITEM" : {
		"item_id"              : "",
		"texture":{
			"atlas_id_lines"   : "",
			"atlas_id_fillA"   : "",
			"atlas_id_fillB"   : "",
			"atlas_coordinate" : Vector2i.ZERO,
			"fill_color_A"     : Color.WHITE,
			"fill_color_B"     : Color.WHITE
		},
		"supertype"            : "",
		"type"                 : "",
		"subtype"              : "",
		"container"            : [],
		"hotbar_script_path"   : "",
		"armament_script_path" : "",
		"accessory_script_path": ""
	}
}
