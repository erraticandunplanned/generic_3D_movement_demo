extends ActiveAbility

var player : CharacterBody3D
var statistics : StatisticsComponent
#var world : Node
#var sight_ray : RayCast3D

func _ready():
	## LOCATE ALL THE RELEVANT NODES RELATIVE TO SELF
	var find_the_character : Node = get_parent()
	for i in range(0,10):
		if find_the_character is CharacterBody3D: 
			player = find_the_character
		else:
			find_the_character = find_the_character.get_parent()
	
	statistics = player.find_child("ComponentDefaultStatistics", false)

func _enter_tree():
	pass

func _exit_tree():
	pass

func _on_action_press():
	player.velocity += Vector3.UP * statistics.jump_velocity * 3

func _on_action_hold():
	pass

func _on_action_release():
	pass
