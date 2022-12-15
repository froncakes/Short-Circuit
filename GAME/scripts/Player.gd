extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 12
const MAX_SPEED = 84
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var motion = Vector2.ZERO
var buffered_jump = false
var coyote_jump = false
var wall_sliding = false
var move_direction = 1
var wall_direction = 0
var landing = false

onready var JumpBufferTimer = $JumpBufferTimer
onready var sprite = $Sprite
onready var CoyoteJumpTimer = $CoyoteJumpTimer
onready var LeftSlide = $LeftSlide
onready var RightSlide = $RightSlide
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	#puts value of left key versus right key and puts it in x_input
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	#calls update wall direction (further down script)
	_update_wall_direction()
	#detects x_input and makes the run animation and how fast the robot goes
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		#sprite.flip_h = x_input < 0
		move_direction = x_input
		sprite.animation = "Run"
	else:
		pass
		#idles if no x_input detected
		sprite.animation = "Idle"
	#gravity
	motion.y += GRAVITY * delta * TARGET_FPS
	
	#wall jump
	if wall_sliding == true:
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			motion.x = JUMP_FORCE * -wall_direction
			move_direction = -wall_direction
			sprite.animation = "Jump"
			_Jump()
	
	if is_on_floor():
		#for slowing down after you are moving
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		
		#landing animation
		if landing == true:
			if move_direction == 1:
				animationPlayer.play("Jump_Stretch")
			if move_direction == -1:
				animationPlayer.play("LJump_Stretch")
			landing = false
		
		#for jumping
		if Input.is_action_just_pressed("ui_up") or buffered_jump == true:
			motion.y = -JUMP_FORCE
			_Jump()
			buffered_jump = false
	else:
		#if in air
		landing = true
		
		#coyote jump
		if coyote_jump == true:
			if Input.is_action_just_pressed("ui_up"):
				motion.y = -JUMP_FORCE
				_Jump()
		
		sprite.animation = "Jump"
		
		#makes jumps smaller if you release aka holding jump longer makes the jump bigger and vice versa
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		#calls buffers jump if you are in the air.
		if Input.is_action_just_pressed("ui_up"):
			_buffer_jump()
		
		#for slowing down after you are moving but in air
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	#detecting if on wall
	if wall_direction != 0:
		wall_sliding = true
		_wall_slide()
	else:
		wall_sliding = false
		sprite.scale.x = move_direction
	
	var was_on_floor = is_on_floor()
	
	motion = move_and_slide(motion, Vector2.UP)
	
	# for detecting if just left ground for coyote jump
	var just_left_ground = not is_on_floor() and was_on_floor 
	if just_left_ground and motion.y >= 0:
		_coyote_jump()
	
	#kills player if the death timer goes off
	if AutoLoadScript.PLAYER_ALIVE == false:
		queue_free()

#for what wall to put the player on
func _update_wall_direction():
	var is_near_right_wall = RightSlide.is_colliding()
	var is_near_left_wall = LeftSlide.is_colliding()
	
	if is_near_left_wall == true and is_near_right_wall == true:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_left_wall) + int(is_near_right_wall)

#wall slide function, slows player down if they are on wall
func _wall_slide():
	sprite.scale.x = -wall_direction
	var max_motion = 72 if !Input.is_action_pressed("ui_down") else 72 * 6
	motion.y = min(motion.y, max_motion)
	sprite.animation = "Wall_Slide"

#animation jump
func _Jump():
	if move_direction == 1:
		animationPlayer.play("Jump")
	if move_direction == -1:
		animationPlayer.play("LJump")

#coyote and buffer jump timers
func _coyote_jump():
	coyote_jump = true
	CoyoteJumpTimer.start()
func _buffer_jump():
	buffered_jump = true
	JumpBufferTimer.start()

#deletes old levels
func _on_Resetter_body_entered(body):
	#print(body)
	if body.name == "LEVEL":
		print("delete")
		body.get_parent().queue_free()
	if body.name == "Text":
		print("delete")
		body.get_parent().queue_free()

func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
