extends Node

@export_category("Components")
@export var player : CharacterBody3D
@export var statistics : StatisticsComponent
@export var hitbox : HitboxCluster
@export var head : Node3D
@export var camera : Camera3D

var since_on_floor = 0
var air_jump_used = 0
var is_vaulting = false
var is_lunging = false
var input_dir = Vector2.ZERO
var direction = Vector3.ZERO
var last_kicked_on
var used_wall_jump = 0
var used_lunge_in_air = 0
var accept_inputs = true
var height_previous = 0.0
var height_highest = 0.0

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if Global.paused: return
	if Global.menu_open: return
	
	## HANDLE CAMERA MOVEMENT FROM MOUSE
	# has to be done in _unhandled_input() for some reason
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * statistics.mouse_camera_sensitivity_x)
		head.rotate_x(-event.relative.y * statistics.mouse_camera_sensitivity_y)
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)

func _process(delta):
	## ADJUSTS DYNAMIC FIELD-OF-VIEW IF ENABLED
	### [1] ###
	if Global.dynamic_fov == true: 
		var max_fov = statistics.DEFAULT_CAMERA_FOV + (statistics.dynamic_FOV_scale * player.velocity.length())
		var fov_change = lerp(camera.fov, max_fov, statistics.dynamic_FOV_speed * delta)
		camera.fov = fov_change
	else: camera.fov = statistics.DEFAULT_CAMERA_FOV

func _physics_process(_delta):
	## HANDLE MULTIPLAYER AND PAUSE
	# prevent inputs from controlling other player characters
	# prevent inputs from registering if the game is paused (but physics still applies)
	if not is_multiplayer_authority(): return
	accept_inputs = false if Global.paused or Global.menu_open else true
	
	## ONE-TIME VARIABLE SETUP
	# these variables are used at multiple points throughout the script,
	# but shouldn't follow over from one frame to the next.
	var closest_valid_object = hitbox.find_closest_object(statistics.NEARBY_MAX_RANGE)
	var effective_gravity = Global.gravity
	var effective_accel = statistics.accel
	var effective_max_speed = statistics.max_speed
	
	## ABILITY RESETS
	if player.is_on_floor():
		since_on_floor = 0
		air_jump_used = 0
		used_wall_jump = 0
		used_lunge_in_air = 0
		last_kicked_on = 0
		is_vaulting = false
	
									###################
									## HANDLE INPUTS ##
									###################
	
	## HANDLE JOYSTICK CAMERA
	var joystick_camera_input = Input.get_vector("camera_joystick_left", "camera_joystick_right", "camera_joystick_up", "camera_joystick_down")
	if accept_inputs and joystick_camera_input != Vector2.ZERO:
		if !Global.joystick_camera_lock or Global.first_person_camera:
			player.rotate_y(-joystick_camera_input.x * statistics.joystick_camera_sensitivity_x * get_physics_process_delta_time())
			head.rotate_x(-joystick_camera_input.y * statistics.joystick_camera_sensitivity_y * get_physics_process_delta_time())
			head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	
	## HANDLE WASD INPUTS
	# sets input_dir to a Vector2 product of WASD or Left Joystick, reults in only 8-directional movement for WASD
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	if not accept_inputs: input_dir = Vector2.ZERO
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## HANDLE JUMP INPUT
	# different action based on if the player is on the floor, next to a wall, or in the air
	if Input.is_action_just_pressed("jump") and accept_inputs: 
		# is on floor
		if since_on_floor < statistics.COYOTE_TIME: 
			since_on_floor = statistics.COYOTE_TIME
			player.velocity.y = statistics.jump_velocity
		
		# is next to wall
		elif closest_valid_object != null and not player.is_on_floor() and used_wall_jump < statistics.wall_jump_max:
			# the next line is supposed to prevent kicking off the same wall, but it doesn't work if the whole damn map is a single object :/
			#if last_kicked_on == closest_valid_object.get_path().hash(): return
			last_kicked_on = closest_valid_object.get_path().hash()
			if Global.directional_walljump:
				var nearest_normal = hitbox.find_nearest_surface_normal(closest_valid_object)
				player.velocity = nearest_normal * statistics.jump_velocity
			player.velocity.y = statistics.jump_velocity
			used_wall_jump += 1
			air_jump_used = 0 # resets air jump on wall jump
		
		# is in the air
		elif air_jump_used < statistics.air_jump_max:
			air_jump_used += 1
			player.velocity.y = statistics.jump_velocity
	
	## POTENTIALLY JUMP OFF WALL ON RELEASE (FENNY'S VERSION)
	# i do not have the jump_off_wall() function coded
	#if Input.is_action_just_released("ui_jump") and Global.jump_on_release: jump_off_wall()
	
	## HANDLE SPRINT INPUT
	# increase speed and acceleration while grounded
	if Input.is_action_pressed("sprint") and accept_inputs and player.is_on_floor():
		effective_max_speed *= statistics.sprint_multi
		effective_accel *= statistics.sprint_multi
	# perform lunge on release
	if Input.is_action_just_released("lunge") and accept_inputs and not is_lunging and used_lunge_in_air < statistics.lunge_in_air_max:
		is_lunging = true
		used_lunge_in_air += 1
		# lunge returns after a cooldown (cools down instantly if player is grounded)
		await get_tree().create_timer(statistics.lunge_duration).timeout
		is_lunging = false
	
	## HANDLE DIVE INPUT
	if Input.is_action_pressed("dive") and accept_inputs and not player.is_on_floor():
		# perform a "dive" in the air (fall faster)
		effective_gravity *= statistics.dive_gravity_multi
		effective_accel *= 0.5
	
									#################
									## MOVE PLAYER ##
									#################
	
	## HANDLE GRAVITY; DEAL WITH FALL DAMAGE
	if closest_valid_object != null: 
		effective_gravity *= statistics.wall_gravity_reduction
	var height_current = player.position.y
	if player.is_on_floor():
		var fall_distance = height_highest - height_current
		if fall_distance > 0.0: 
			print("fall distance: ", floor(fall_distance))
			var fall_damage = AttackClass.new()
			fall_damage.amount = floor ( maxf( fall_distance - statistics.fall_height_ignore , 0.0 ) * Global.base_fall_damage * statistics.fall_damage_multiplier )
			if fall_damage.amount > 0.0:
				print("fall damage: ", fall_damage.amount)
				player.healthbar.recieve_damage(fall_damage)
		height_previous = 0.0
		height_highest = 0.0
	else:
		player.velocity.y -= effective_gravity * get_physics_process_delta_time()
		since_on_floor += get_physics_process_delta_time()
		if height_current > height_highest or height_current > height_previous:
			height_highest = height_current
		height_previous = height_current
	
	## PERFORM LUNGE
	if is_lunging:
		# get head rotation and then multiply it by the player's "basis"
		# i'm not sure exactly why this works. I kind of brute-forced my way here.
		var head_rotation = -(head.transform.basis.z)
		var lunge_direction_global = (player.transform.basis * head_rotation).normalized()
		
		# apply the lunge to player velocity
		player.velocity.x = lunge_direction_global.x * statistics.lunge_strength
		player.velocity.y = lunge_direction_global.y * statistics.lunge_strength
		player.velocity.z = lunge_direction_global.z * statistics.lunge_strength
	
	## MOVE PLAYER BY VELOCITY
	# TODO: make it so controller inputs can create a vector whose length is less than 1
	if direction:
		# higher acceleration when grounded
		if player.is_on_floor(): effective_accel *= 1.25
		
		# add snapshot and input velocity into "liminal_velocity"
		var liminal_velocity = player.velocity + ( direction * effective_accel * get_physics_process_delta_time() )
		# find velocity delta between this frame and the previous (positive is a velocity increase)
		var velocity_delta = liminal_velocity.length() - player.velocity.length()
		# add input vector to actual velocity
		if player.is_on_floor():
			if direction.x * player.velocity.x < 0: player.velocity.x += direction.x * statistics.accel * 2.5 * get_physics_process_delta_time()
			if direction.z * player.velocity.z < 0: player.velocity.z += direction.z * statistics.accel * 2.5 * get_physics_process_delta_time()
		player.velocity += direction * effective_accel * get_physics_process_delta_time()
		# remove speed increase (but not direction) if over max_speed
		if player.velocity.length() > effective_max_speed:
			player.velocity = player.velocity.normalized() * ( player.velocity.length() - velocity_delta )
	elif player.is_on_floor(): # slow down if grounded
		player.velocity.x = move_toward(player.velocity.x, 0, statistics.deccel * get_physics_process_delta_time())
		player.velocity.z = move_toward(player.velocity.z, 0, statistics.deccel * get_physics_process_delta_time())
	
	## VAULT OVER SMALL LEDGES
	# can happen once. must ground before doing it again.
	# TODO: make the vault only happen if you are FACING the ledge
	if accept_inputs and closest_valid_object != null and not is_vaulting and since_on_floor >= statistics.COYOTE_TIME and player.velocity.y <= 0 and not hitbox.object_exists_at_eyes():
		is_vaulting = true
		player.velocity.y = max(player.velocity.y, statistics.jump_velocity)
	
	## THE FINAL FUNCTION (TM)
	player.move_and_slide()

### [1] ###
# interpolation handling
# https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html
# dynamic fov youtube video (using unity)
# https://youtu.be/nWoWERs-28g
