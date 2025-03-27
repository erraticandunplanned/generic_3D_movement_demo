extends Resource
class_name AttackClass

@export var amount : int
@export var type : String

func _init(p_amount = 0, p_type = ""):
	amount = p_amount
	type = p_type
