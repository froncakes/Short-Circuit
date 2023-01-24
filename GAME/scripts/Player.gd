extends KinematicBody2D

const TARGET_FPS = 60
var ACCELERATION = 12
var MAX_SPEED = 84
var FRICTION = 10
var AIR_RESISTANCE = 1
var GRAVITY = 4
var JUMP_FORCE = 140

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
	pass

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

#kills player if the death timer goes off
func _death_timer():
	if AutoLoadScript.PLAYER_ALIVE == false:
		queue_free()

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
