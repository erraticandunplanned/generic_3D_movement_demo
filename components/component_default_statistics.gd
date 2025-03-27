extends Node
class_name StatisticsComponent

						#######################
						## PLAYER STATISTICS ##
						#######################

## DEFAULTS

@export_category("Ability Scores")
@export_group("Standard")
@export var DEFAULT_CON = 10
@export var DEFAULT_DEX = 10
@export_category("Default Statistics")
@export_group("Health")
@export var DEFAULT_MAX_HEALTH = 100
#@export var DEFAULT_BONUS_HEALTH = 0
#@export var DEFAULT_DEFENSE = 0
@export_group("Damage")
#@export var DEFAULT_MELEE_DAMAGE = 30
@export_group("Camera")
@export var DEFAULT_CAMERA_FOV = 75
@export var DEFAULT_FIRST_PERSON_CAMERA = true
#@export var DEFAULT_INVERT_Y_AXIS = false
@export var DEFAULT_MOUSE_CAMERA_SENSITIVITY_X = 0.005
@export var DEFAULT_MOUSE_CAMERA_SENSITIVITY_Y = 0.005
@export var DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_X = 4
@export var DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_Y = 4
@export_group("Movement")
@export_subgroup("Speed and Acceleration")
@export var DEFAULT_MAX_SPEED = 24
@export var DEFAULT_SPRINT_MULTI = 1.2
@export var DEFAULT_ACCEL = 10
@export var DEFAULT_DECCEL = 75
@export_subgroup("Jump")
@export var DEFAULT_JUMP_VELOCITY = 10
@export var DEFAULT_WALL_JUMP_MAX = 3
@export var DEFAULT_AIR_JUMP_MAX = 1
@export_subgroup("Wallrun and Dive")
@export var DEFAULT_WALL_GRAVITY_REDUCTION = 0.5
@export var DEFAULT_DIVE_GRAVITY_MULTI = 3
@export_subgroup("Lunge")
@export var DEFAULT_LUNGE_IN_AIR_MAX = 1
@export var DEFAULT_LUNGE_STRENGTH = 20
@export var DEFAULT_LUNGE_DURATION = 0.5
@export_category("Menu Statistics")
@export_subgroup("Menu Speeds")
@export var DEFAULT_MENU_MOUSE_SPEED = 1.0
@export var DEFAULT_MENU_JOYSTICK_SPEED = 15

## STATISTICS

var max_health = DEFAULT_MAX_HEALTH
var health = DEFAULT_MAX_HEALTH
#var melee_damage = DEFAULT_MELEE_DAMAGE
#var camera_fov = DEFAULT_CAMERA_FOV
var first_person_camera = DEFAULT_FIRST_PERSON_CAMERA 
#var invert_y_axis = DEFAULT_INVERT_Y_AXIS
var mouse_camera_sensitivity_x = DEFAULT_MOUSE_CAMERA_SENSITIVITY_X
var mouse_camera_sensitivity_y = DEFAULT_MOUSE_CAMERA_SENSITIVITY_Y
var joystick_camera_sensitivity_x = DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_X
var joystick_camera_sensitivity_y = DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_Y
var max_speed = DEFAULT_MAX_SPEED
var sprint_multi = DEFAULT_SPRINT_MULTI
var accel = DEFAULT_ACCEL
var deccel = DEFAULT_DECCEL
var jump_velocity = DEFAULT_JUMP_VELOCITY
var wall_jump_max = DEFAULT_WALL_JUMP_MAX
var air_jump_max = DEFAULT_AIR_JUMP_MAX
var wall_gravity_reduction = DEFAULT_WALL_GRAVITY_REDUCTION
var dive_gravity_multi = DEFAULT_DIVE_GRAVITY_MULTI
var lunge_in_air_max = DEFAULT_LUNGE_IN_AIR_MAX
var lunge_strength = DEFAULT_LUNGE_STRENGTH
var lunge_duration = DEFAULT_LUNGE_DURATION

var menu_mouse_speed = DEFAULT_MENU_MOUSE_SPEED
var menu_joystick_speed = DEFAULT_MENU_JOYSTICK_SPEED

var fall_height_ignore = float(DEFAULT_DEX) / 2
var fall_damage_multiplier = 10 / float(DEFAULT_CON)

						#####################
						## <category name> ##
						#####################

var wanderer_ability_last_used = -1

						################################
						## IMPORTANT UNCHANGING STUFF ##
						################################

const dynamic_FOV_scale = 1.25
const dynamic_FOV_speed = 5
const NEARBY_MAX_RANGE = 200
const COYOTE_TIME = 0.2
const HOLD_BUTTON_TIME_THRESHOLD = 0.25
