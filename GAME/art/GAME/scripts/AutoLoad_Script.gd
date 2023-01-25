extends Node

var LEVEL_SPEED = .5
var LEVEL_LENGTH = 0
var LEVEL_POSITION = Vector2(0, 0)
var LEVEL_NUMBER = 0
var SCORE = 0
var PLAYER_ALIVE = true

var just_timed_out = false
var timeouts = 0

var timer:Timer

#death lol
func _DEATH():
	PLAYER_ALIVE = false
	timer.stop()

#setter for score
func _SET_SCORE(x):
	SCORE = x

#setter for length
func _SET_CURRENT(number):
	LEVEL_LENGTH = number
	print (LEVEL_LENGTH)

#setter for position
func _SET_POSITION(x, y):
	LEVEL_POSITION = Vector2(x,y)
	print (LEVEL_POSITION)

#setter for level number
func _SET_NUMBER(number):
	LEVEL_NUMBER = number
	print (LEVEL_NUMBER)

#baby #social #picoCAD #,baby
#creates global timer
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(10)
	timer.connect("timeout", self, "on_button_timeout")
	timer.start()

func on_button_timeout() -> void:
	timeouts = timeouts +1
	just_timed_out = true
	print("timed out")
	timer.start()
