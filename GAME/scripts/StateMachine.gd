extends Node2D
class_name StateMachine

var rng = RandomNumberGenerator.new()

var state = null setget set_state
var previous_state = null
var states = {}
var able_transition = true
var next_state 
var stored_state = null

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		if AutoLoadScript.just_timed_out == true and able_transition:
			var transition = _get_transition(delta)
			if transition != null:
				set_state(transition)
			print(state)
			AutoLoadScript.just_timed_out = false
			AutoLoadScript.timer.start()
			create_next_state()
		elif AutoLoadScript.just_timed_out == true and able_transition == false:
			AutoLoadScript.timer.stop()

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

func add_state(state_name):
	states[state_name] = states.size()

func create_next_state():
	rng.randomize()
	var random_number = rng.randi_range(0, states.size()-1)
	print (random_number)
	
	while random_number == state or random_number == previous_state:
		random_number = rng.randi_range(0, states.size()-1)
	
	next_state = random_number
	AutoLoadScript.NEXT_STATE = next_state

func swap_stored():
	var NEXT = next_state
	if stored_state == null:
		create_next_state()
	else:
		next_state = stored_state
	
	stored_state = NEXT
	AutoLoadScript.NEXT_STATE = next_state
	AutoLoadScript.STORED_STATE = stored_state
