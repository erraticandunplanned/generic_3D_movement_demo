extends Node2D

@onready var gear_icons = $slotmap_64/gear_icons

## INDEX ENUM
#enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND, A_L0, A_L1, A_L2, A_L3, A_R0, A_R1, A_R2, A_R3}
enum {ARMOR, CLOTHING, GEAR, CHARM}
var slot_array = []
var current_set = ARMOR

func _ready():
	slot_array = [
		$textures/HEAD,
		$textures/CHEST,
		$textures/BACK,
		$textures/HIPS,
		$textures/LEGS,
		$textures/FEET,
		$textures/L_SHOULDER,
		$textures/L_ARM,
		$textures/L_HAND,
		$textures/R_SHOULDER,
		$textures/R_ARM,
		$textures/R_HAND,
		$textures/A_L0,
		$textures/A_L1,
		$textures/A_L2,
		$textures/A_L3,
		$textures/A_R0,
		$textures/A_R1,
		$textures/A_R2,
		$textures/A_R3
	]

func swap_equipment_layout(index : int):
	## UPDATE GEAR ICONS
	current_set = index
	gear_icons.set_pattern(Vector2i(0,0),gear_icons.tile_set.get_pattern(index))

func set_texture(index : int, tex : ItemTexture):
	slot_array[index].set_item_texture(tex)
