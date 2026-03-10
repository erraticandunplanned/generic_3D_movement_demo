extends Node2D

## Vector2i(state,0)
## STATE 0 "FULL"
## STATE 1 "LEFT"
## STATE 2 "DOWN"
## STATE 3 "DOWN / LEFT"

var size  : int = 12
var state : int = 0
var color : Color = Color.WHITE

func set_all(target_size : int = 12, target_state : int = 0, target_color : Color = Color.WHITE):
	_set_size(target_size)
	_set_border_state(target_state)
	_set_border_color(target_color)

func _set_size(target_size : int):
	if target_size > 12 or target_size < 1: return false
	size = target_size
	$slotmap_64/slot_background.clear()
	$slotmap_64/slot_chamfer.clear()
	$slotmap_64/container_border.clear()
	for i in range(size):
		$slotmap_64/slot_background.set_cell(Vector2i(i,0),0,Vector2i(0,1))
		$slotmap_64/slot_chamfer.set_cell(Vector2i(i,0),0,Vector2i(1,3))
		$slotmap_64/container_border.set_cell(Vector2i(i,0),0,Vector2i(state,0))

func _set_border_state(target_state : int):
	if target_state > 3 or target_state < 0: return false
	state = target_state
	for i in range(size):
		$slotmap_64/container_border.set_cell(Vector2i(i,0),0,Vector2i(state,0))

func _set_border_color(target_color : Color):
	color = target_color
	$slotmap_64/container_border.modulate = color

func set_texture(index : int, tex : ItemTexture):
	$items.get_child(index).set_item_texture(tex)
