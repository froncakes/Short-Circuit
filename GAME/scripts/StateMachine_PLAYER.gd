extends "res://GAME/scripts/StateMachine.gd"

var floating = false
var wall_detection = true
var pogo_jumping = false
var rocket_movement = false
var reset_rotation = false

func _ready():
	add_state("normal")
	add_state("roller_skates")
	add_state("umbrella")
	add_state("rocket_boost")
	add_state("pogostick")
	set_state(states.pogostick)
	create_next_state()
	print (state)

func _state_logic(delta):
	
	parent._death_timer()
	
	#state logic for normal mode
	if state == 0:
		parent.ACCELERATION = 12
		parent.MAX_SPEED = 84
		parent.FRICTION = 10
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 150
		wall_detection = true
		rocket_movement = false
		floating = false
		pogo_jumping = false
		
		_base_movement(delta)
	
	#state logic for roller skates mode
	if state == 1:
		parent.ACCELERATION = 18
		parent.MAX_SPEED = 136
		parent.FRICTION = 5
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 140
		wall_detection = true
		rocket_movement = false
		floating = false
		pogo_jumping = false
		
		_base_movement(delta)
	
	#state logic for umbrella mode
	if state == 2:
		parent.ACCELERATION = 10
		parent.MAX_SPEED = 72
		parent.FRICTION = 10
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 190
		wall_detection = false
		rocket_movement = false
		parent.wall_sliding = false
		pogo_jumping = false
		
		_base_movement(delta)
		
		if Input.is_action_just_pressed("ui_up") and parent.coyote_jump == false and parent.landing == true:
			floating = true
		
		if Input.is_action_just_released("ui_up") and parent.coyote_jump == false and parent.landing == true:
			floating = false
		
		if floating == true:
			var max_motion = 10 if !Input.is_action_pressed("ui_down") else 10 * 6
			parent.motion.y = min(parent.motion.y, max_motion)
	
	#state logic for rocket boost mode
	if state == 3:
		parent.ACCELERATION = 20
		parent.MAX_SPEED = 160
		parent.FRICTION = 5
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 140
		wall_detection = true
		rocket_movement = true
		floating = false
		pogo_jumping = false
		
		_base_movement(delta)
	
	#state logic for pogostick mode
	if state == 4:
		parent.ACCELERATION = 1.10
		parent.MAX_SPEED = 250
		parent.FRICTION = 20
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 235
		wall_detection = false
		rocket_movement = false
		parent.wall_sliding = false
		floating = false
		
		if pogo_jumping == false:
			parent.textureProgress.value = 0
			reset_rotation = true
		
		if parent.textureProgress.value < 100:
			parent.textureProgress.value += 2
		
		_base_movement(delta)

func _get_transition(delta):
	if next_state == 0:
		print("normal")
		return states.normal
	if next_state == 1:
		print("roller skates")
		return states.roller_skates
	if next_state == 2:
		print("umbrella")
		return states.umbrella
	if next_state == 3:
		print("rocket boost")
		return states.rocket_boost
	if next_state == 4:
		print("pogostick")
		return states.pogostick
	
	return null

func _enter_state(new_state, old_state):
	#likely using for switching to other sprite sheets later
	match new_state:
		states.normal:
			pass
		states.roller_skates:
			pass
		states.umbrella:
			pass
		states.rocket_boost:
			pass
		states.pogostick:
			pass

func _exit_state(old_state, new_state):
	#likely using to play switch animation
	pass

func _base_movement(delta):
	#puts value of left key versus right key and puts it in x_input
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	
	parent._update_wall_direction()
	
	#detects x_input and makes the run animation and how fast the robot goes
	if rocket_movement != true:
		if state != 4:
			if x_input != 0:
				parent.motion.x += x_input * parent.ACCELERATION * delta * parent.TARGET_FPS
				parent.motion.x = clamp(parent.motion.x, -parent.MAX_SPEED, parent.MAX_SPEED)
				parent.move_direction = x_input
				parent.sprite.animation = "Run"
			else:
				#idles if no x_input detected
				parent.sprite.animation = "Idle"
	else:
		#detects x_input for rocket boost/car
		if x_input > 0:
			parent.move_direction = 1
			parent.motion.x += parent.move_direction * parent.ACCELERATION * delta * parent.TARGET_FPS
			parent.motion.x = clamp(parent.motion.x, -parent.MAX_SPEED*1.25, parent.MAX_SPEED*1.25)
			parent.sprite.animation = "Run"
		elif x_input < 0:
			parent.move_direction = -1
			parent.motion.x += parent.move_direction * parent.ACCELERATION * delta * parent.TARGET_FPS
			parent.motion.x = clamp(parent.motion.x, -parent.MAX_SPEED*1.25, parent.MAX_SPEED*1.25)
			parent.sprite.animation = "Run"
		else:
			parent.motion.x += parent.move_direction * parent.ACCELERATION * delta * parent.TARGET_FPS
			parent.motion.x = clamp(parent.motion.x, -parent.MAX_SPEED, parent.MAX_SPEED)
			parent.sprite.animation = "Idle"
	#gravity
	parent.motion.y += parent.GRAVITY * delta * parent.TARGET_FPS
	
	#wall jump
	if parent.wall_sliding == true:
		if Input.is_action_just_pressed("ui_up"):
			parent.motion.y = -parent.JUMP_FORCE
			parent.motion.x = parent.JUMP_FORCE * -parent.wall_direction
			parent.move_direction = -parent.wall_direction
			parent.sprite.animation = "Jump"
			parent._Jump()
	
	if parent.is_on_floor():
		#makes it so ur able to transition while on floor
		able_transition = true
		#reseting for pogostick
		if reset_rotation == true and pogo_jumping == false:
			parent.sprite.rotation = 0
		#for slowing down after you are moving
		if rocket_movement != true:
			if x_input == 0 or state == 4:
				parent.motion.x = lerp(parent.motion.x, 0, parent.FRICTION * delta)
		
		#landing animation
		if parent.landing == true:
			if parent.move_direction == 1:
				parent.animationPlayer.play("Jump_Stretch")
			if parent.move_direction == -1:
				parent.animationPlayer.play("LJump_Stretch")
			parent.landing = false
		
		#cant transition while pogo jumping
		if pogo_jumping == true:
			able_transition = false
		
		#for jumping
		if state != 4:
			if Input.is_action_just_pressed("ui_up") or parent.buffered_jump == true:
				parent.motion.y = -parent.JUMP_FORCE
				parent._Jump()
				parent.buffered_jump = false
		else: #pogostick jumping
			if Input.is_action_just_pressed("ui_up"):
				pogo_jumping = true
				parent.textureProgress.visible = true
			if Input.is_action_just_released("ui_up"):
				pogo_jumping = false
				#calculates jump height and turns rotation into radians
				var jump_height = -(parent.JUMP_FORCE * float(parent.textureProgress.value/100))
				var jump_angle = parent.sprite.rotation
				if(jump_angle == 0): #so we dont divide by 0
					parent.motion = Vector2(jump_angle, jump_height)
					parent.textureProgress.visible = false
				else: #math to jump with direction of angle
					var vx = jump_height * sin(jump_angle)
					print (vx)
					parent.textureProgress.visible = false
					parent.motion = Vector2(-vx, jump_height)
		if pogo_jumping == true: #pogostick x input
			if x_input > 0:
				if parent.sprite.rotation < 1.25:
					parent.sprite.rotation += .05
			if x_input < 0:
				if parent.sprite.rotation > -1.25:
					parent.sprite.rotation -= .05
			#print('sprite rotation: ', parent.sprite.rotation_degrees)
	else:
		#if in air for animation
		parent.landing = true
		parent.sprite.animation = "Jump"
		#makes it so you cant transition while in the air
		able_transition = false
		
		#coyote jump
		if parent.coyote_jump == true:
			if Input.is_action_just_pressed("ui_up"):
				parent.motion.y = -parent.JUMP_FORCE
				parent._Jump()
		
		#makes jumps smaller if you release aka holding jump longer makes the jump bigger and vice versa
		if Input.is_action_just_released("ui_up") and parent.motion.y < -parent.JUMP_FORCE/2:
			parent.motion.y = -parent.JUMP_FORCE/2
		
		#calls buffers jump if you are in the air.
		if state != 4:
			if Input.is_action_just_pressed("ui_up"):
				parent._buffer_jump()
		
		if state == 4:
			if x_input != 0:
				parent.motion.x += x_input * parent.ACCELERATION * delta * parent.TARGET_FPS
				parent.motion.x = clamp(parent.motion.x, -parent.MAX_SPEED, parent.MAX_SPEED)
		
		#for slowing down after you are moving but in air
		if x_input == 0:
			parent.motion.x = lerp(parent.motion.x, 0, parent.AIR_RESISTANCE * delta)
	
	#detecting if on wall
	if parent.wall_direction != 0 and floating == false and wall_detection == true:
		parent.wall_sliding = true
		parent._wall_slide()
	else:
		parent.wall_sliding = false
		parent.sprite.scale.x = parent.move_direction
	
	var was_on_floor = parent.is_on_floor()
	
	parent.motion = parent.move_and_slide(parent.motion, Vector2.UP)
	
	# for detecting if just left ground for coyote jump
	var just_left_ground = not parent.is_on_floor() and was_on_floor 
	if state != 4:
		if just_left_ground and parent.motion.y >= 0:
			parent._coyote_jump()
