extends Control

@onready var wheel_node = $Control/CenterContainer/Control

const wheel_size = 400
const outer_rim_size = 475
const inner_rim_size = 300
const precision = 22.5
const section_offset = 10
var wheel_contents = []

func generate_wheel(contents : Array, count : int = 0): #Array[PackedScene]
	## DETERMINE SLICE LINES
	var right_slice_in_deg = 360.0 / (count * 2)
	var left_slice_in_deg = 360.0 - right_slice_in_deg
	var rim_points = (right_slice_in_deg * 2) / precision
	var left_slice_in_rad = deg_to_rad(left_slice_in_deg)
	var right_slice_in_rad = deg_to_rad(right_slice_in_deg)
	
	## CREATE POINT ARRAY
	var points = PackedVector2Array()
	points.push_back(Vector2.ZERO + Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * outer_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(left_slice_in_deg + (i * precision))
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * outer_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * outer_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(right_slice_in_rad), sin(right_slice_in_rad)) * inner_rim_size)
	for i in int(rim_points):
		var point = deg_to_rad(right_slice_in_deg - (i * precision))
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * inner_rim_size)
	points.push_back(Vector2.ZERO + Vector2(cos(left_slice_in_rad), sin(left_slice_in_rad)) * inner_rim_size)

	## CREATE <NUMBER> SLICES
	var num = contents.size() if count == 0 else count
	for i in range(1,num+1):
		var new_item = Polygon2D.new()
		wheel_node.add_child(new_item)
		var new_pos = Vector2.UP.rotated(deg_to_rad(i * 360 / num))
		new_item.position = Vector2.ZERO + new_pos * section_offset
		new_item.rotation = (3 * PI / 2) + (i * PI * 2 / num)
		new_item.polygon = points
		new_item.name = str(i)
		wheel_contents.append(new_item)

func _ready():
	pass

func _process(delta):
	pass
