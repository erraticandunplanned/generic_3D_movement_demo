extends Node2D

## INDEX ENUM
enum {ARMOR, CLOTHING, GEAR, CHARM}
#enum {HEAD, CHEST, BACK, HIPS, LEGS, FEET, L_SHOULDER, L_ARM, L_HAND, R_SHOULDER, R_ARM, R_HAND, A_L0, A_L1, A_L2, A_L3, A_R0, A_R1, A_R2, A_R3}

var current_set = ARMOR

func _swap_equipment_layout(index : int):
	## UPDATE GEAR ICONS
	current_set = index
	$slotmap_64/gear_icons.set_pattern(Vector2i(0,0),index)
	
	## UPDATE INVENTORY SLOTS

func _set_texture(index : int):
	pass
