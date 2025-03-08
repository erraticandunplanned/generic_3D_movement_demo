extends Node
class_name StatisticsComponent

						#######################
						## PLAYER STATISTICS ##
						#######################

## DEFAULTS

@export_category("Default Statistics")
@export_group("Health")
@export var DEFAULT_MAX_HEALTH = 100
@export var DEFAULT_BONUS_HEALTH = 0
@export var DEFAULT_DEFENSE = 0
@export_subgroup("Damage Multipliers")
@export_range(0,2,0.1) var DEFAULT_DAMAGE_MULTIPLIER_PHYSICAL : float = 1
@export_range(0,2,0.1) var DEFAULT_DAMAGE_MULTIPLIER_ELEMENTAL : float = 1
@export_range(0,2,0.1) var DEFAULT_DAMAGE_MULTIPLIER_PSYCHIC : float = 1
@export_range(0,2,0.1) var DEFAULT_DAMAGE_MULTIPLIER_DIVINE : float = 1
@export_range(0,2,0.1) var DEFAULT_DAMAGE_MULTIPLIER_INFECTION : float = 1
@export_group("Damage")
@export var DEFAULT_MELEE_DAMAGE = 30
@export_group("Camera")
@export var DEFAULT_CAMERA_FOV = 75
@export var DEFAULT_FIRST_PERSON_CAMERA = true
@export var DEFAULT_INVERT_Y_AXIS = false
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
@export var DEFAULT_JUMP_BUFFER_TIME = 0.2
@export var DEFAULT_COYOTE_TIME = 0.2
@export var DEFAULT_WALL_JUMP_MAX = 3
@export var DEFAULT_AIR_JUMP_MAX = 1
@export_subgroup("Wallrun and Dive")
@export var DEFAULT_WALL_GRAVITY_REDUCTION = 0.5
@export var DEFAULT_DIVE_GRAVITY_MULTI = 3
@export_subgroup("Slide")
@export var DEFAULT_SLIDE_STRENGTH = 20
@export var DEFAULT_SLIDE_COOLDOWN = 2
@export var DEFAULT_SLIDE_DURATION = 0.5
@export var DEFAULT_SLIDE_JUMP_MULTI = 1.7
@export var DEFAULT_SLIDE_DECCEL = 25
@export_subgroup("Lunge")
@export var DEFAULT_AIRDASH_MAX = 1
@export var DEFAULT_AIRDASH_STRENGTH = 20
@export var DEFAULT_AIRDASH_DURATION = 0.5
@export var DEFAULT_AIRDASH_DECCEL = 10
@export_category("Menu Statistics")
@export_subgroup("Menu Speeds")
@export var DEFAULT_MENU_MOUSE_SPEED = 1.0
@export var DEFAULT_MENU_JOYSTICK_SPEED = 15

## STATISTICS

var max_health = DEFAULT_MAX_HEALTH
var health = DEFAULT_MAX_HEALTH
var melee_damage = DEFAULT_MELEE_DAMAGE
var camera_fov = DEFAULT_CAMERA_FOV
var first_person_camera = DEFAULT_FIRST_PERSON_CAMERA 
var invert_y_axis = DEFAULT_INVERT_Y_AXIS
var mouse_camera_sensitivity_x = DEFAULT_MOUSE_CAMERA_SENSITIVITY_X
var mouse_camera_sensitivity_y = DEFAULT_MOUSE_CAMERA_SENSITIVITY_Y
var joystick_camera_sensitivity_x = DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_X
var joystick_camera_sensitivity_y = DEFAULT_JOYSTICK_CAMERA_SENSITIVITY_Y
var max_speed = DEFAULT_MAX_SPEED
var sprint_multi = DEFAULT_SPRINT_MULTI
var accel = DEFAULT_ACCEL
var deccel = DEFAULT_DECCEL
var jump_velocity = DEFAULT_JUMP_VELOCITY
var jump_buffer_time = DEFAULT_JUMP_BUFFER_TIME
var coyote_time = DEFAULT_COYOTE_TIME
var wall_jump_max = DEFAULT_WALL_JUMP_MAX
var air_jump_max = DEFAULT_AIR_JUMP_MAX
var wall_gravity_reduction = DEFAULT_WALL_GRAVITY_REDUCTION
var dive_gravity_multi = DEFAULT_DIVE_GRAVITY_MULTI
var slide_strength = DEFAULT_SLIDE_STRENGTH
var slide_cooldown = DEFAULT_SLIDE_COOLDOWN
var slide_duration = DEFAULT_SLIDE_DURATION
var slide_jump_multi = DEFAULT_SLIDE_JUMP_MULTI
var slide_deccel = DEFAULT_SLIDE_DECCEL
var airdash_max = DEFAULT_AIRDASH_MAX
var airdash_strength = DEFAULT_AIRDASH_STRENGTH
var airdash_duration = DEFAULT_AIRDASH_DURATION
var airdash_deccel = DEFAULT_AIRDASH_DECCEL

var menu_mouse_speed = DEFAULT_MENU_MOUSE_SPEED
var menu_joystick_speed = DEFAULT_MENU_JOYSTICK_SPEED

						#####################
						## <category name> ##
						#####################

var wanderer_ability_last_used = -1

						################################
						## IMPORTANT UNCHANGING STUFF ##
						################################

const VAULT_DURATION = 0.2
const dynamic_FOV_scale = 1.25
const dynamic_FOV_speed = 5
const WALLJUMP_MAX_RANGE = 200
const WALLRUN_MAX_RANGE = 200
const VAULT_TRIGGER_RANGE = 200
