extends ActiveAbility

@onready var the_cube = preload("res://items_and_materials/create_cube/the_cube_in_question.tscn")

var player : CharacterBody3D
var world : Node
var sight_ray : RayCast3D

func _ready():
	## LOCATE ALL THE RELEVANT NODES RELATIVE TO SELF
	var find_the_character : Node = get_parent()
	for i in range(0,10):
		if find_the_character is CharacterBody3D: 
			player = find_the_character
		else:
			find_the_character = find_the_character.get_parent()
	
	world = player.get_parent().get_parent().find_child("world", false)
	sight_ray = player.find_child("head", false).find_child("sight_ray", false)

func _enter_tree():
	pass

func _exit_tree():
	pass

func _on_action_press():
	## FIND GENERATION POINT AND NORMAL
	var location = sight_ray.get_collision_point()
	var normal = sight_ray.get_collision_normal()
	
	## GENERATE CUBE
	# and offset its location along normal by half its diameter
	var the_cube_in_question = the_cube.instantiate()
	world.add_child(the_cube_in_question)
	the_cube_in_question.global_position = location + (normal / 2)

func _on_action_hold():
	pass

func _on_action_release():
	pass
