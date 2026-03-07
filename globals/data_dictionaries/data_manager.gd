class_name DataManager

static func create_item(i_id : String, i_materials : Array = [], i_quantity : int = 1, i_unique_id : int = 0) -> BasicItem:
	var new_item := BasicItem.new()
	var dict_entry : Dictionary = DataIngredients.Ingredients.get(i_id)
	
	## GENERAL DICTIONARY OBJECTS
	new_item.quantity = i_quantity
	new_item.item_id = i_id
	new_item.supertype = dict_entry.get("supertype")                         if dict_entry.has("supertype")             else DataIngredients.DEFAULT_SUPERTYPE
	new_item.type = dict_entry.get("type")                                   if dict_entry.has("type")                  else DataIngredients.DEFAULT_TYPE
	new_item.subtype = dict_entry.get("subtype")                             if dict_entry.has("subtype")               else DataIngredients.DEFAULT_SUBTYPE
	new_item.container = dict_entry.get("container")                         if dict_entry.has("container")             else DataIngredients.DEFAULT_CONTAINER
	new_item.hotbar_script_path = dict_entry.get("hotbar_script_path")       if dict_entry.has("hotbar_script_path")    else DataIngredients.DEFAULT_HOTBAR_SCRIPT_PATH
	new_item.armament_script_path = dict_entry.get("armament_script_path")   if dict_entry.has("armament_script_path")  else DataIngredients.DEFAULT_ARMAMENT_SCRIPT_PATH
	new_item.accessory_script_path = dict_entry.get("accessory_script_path") if dict_entry.has("accessory_script_path") else DataIngredients.DEFAULT_ACCESSORY_SCRIPT_PATH
	
	new_item.unique_id = randi() if i_unique_id == 0 else i_unique_id
	
	var dict_texture_entry : Dictionary = dict_entry.get("texture")
	var new_texture := ItemTexture.new()
	var atlas_ids : Array[String] = [dict_texture_entry.get("atlas_id_lines"),dict_texture_entry.get("atlas_id_fillA"),dict_texture_entry.get("atlas_id_fillB")]
	new_texture.atlas_id = atlas_ids
	new_texture.atlas_coordinate = dict_texture_entry.get("atlas_coordinate")
	new_texture.fill_color_A = dict_texture_entry.get("fill_color_A")
	new_texture.fill_color_B = dict_texture_entry.get("fill_color_B")
	new_item.texture = new_texture
	
	return new_item
