extends "res://GAME/scripts/StateMachine.gd"

var rng = RandomNumberGenerator.new()

var floating = false

func _ready():
	add_state("normal")
	add_state("roller_skates")
	add_state("umbrella")
	add_state("rocket_boost")
	set_state(states.normal)
	print (state)

func _state_logic(delta):
	#state logic for normal mode
	if state == 0:
		parent.ACCELERATION = 12
		parent.MAX_SPEED = 84
		parent.FRICTION = 10
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 150
	
	#state logic for roller skates mode
	if state == 1:
		parent.ACCELERATION = 18
		parent.MAX_SPEED = 136
		parent.FRICTION = 5
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 140
	
	#state logic for umbrella mode
	if state == 2:
		parent.ACCELERATION = 10
		parent.MAX_SPEED = 72
		parent.FRICTION = 10
		parent.AIR_RESISTANCE = 1
		parent.GRAVITY = 4
		parent.JUMP_FORCE = 150
		
		if Input.is_action_just_pressed("ui_up") and parent.coyote_jump == false and parent.landing == true and parent.wall_sliding == false:
			floating = true
		
		if Input.is_action_just_released("ui_up") and parent.coyote_jump == false and parent.landing == true and parent.wall_sliding == false:
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

func _get_transition(delta):
	rng.randomize()
	var random_number = rng.randi_range(0, states.size()-1)
	print (random_number)
	
	while random_number == state or random_number == previous_state:
		random_number = rng.randi_range(0, states.size()-1)
	
	if random_number == 0:
		print("normal")
		return states.normal
	if random_number == 1:
		print("roller skates")
		return states.roller_skates
	if random_number == 2:
		print("umbrella")
		return states.umbrella
	if random_number == 3:
		print("rocket boost")
		return states.rocket_boost
	
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
