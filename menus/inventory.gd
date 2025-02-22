extends Control

@onready var slots_node = $slots
@onready var empty_tile = preload("res://textures/inventory/empty_slot.png")

var player : CharacterBody3D
var statistics : StatisticsComponent

var armorslot_positions = [
													   Vector2(704,455),
	Vector2(341,576),Vector2(462,576),Vector2(583,576),Vector2(704,576),Vector2(825,576),Vector2(946,576),Vector2(1067,576),
													   Vector2(704,697),
	Vector2(341,818),Vector2(462,818),				   Vector2(704,818),				 Vector2(946,818),Vector2(1067,818),
	Vector2(341,939),Vector2(462,939),				   Vector2(704,939),				 Vector2(946,939),Vector2(1067,939),
													   Vector2(704,1060)
	]
var base_inventory_position = Vector2(1672,334)
var base_inventory_size = Vector2(8,10)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player = get_parent().get_parent()
	statistics = player.statistics
	
	for i in range(0,19):
		var newslot = Sprite2D.new()
		slots_node.add_child(newslot)
		newslot.texture = empty_tile
		if i <= armorslot_positions.size():
			newslot.position = armorslot_positions[i]
	
	for inv_y in range(0,base_inventory_size.y):
		for inv_x in range(0,base_inventory_size.x):
			var newslot = Sprite2D.new()
			slots_node.add_child(newslot)
			newslot.texture = empty_tile
			newslot.position = Vector2(base_inventory_position.x + (121 * inv_x),base_inventory_position.y + (121 * inv_y))

func _process(delta):
	pass
