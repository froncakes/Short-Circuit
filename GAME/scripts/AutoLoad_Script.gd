extends Node

var LEVEL_SPEED = .5
var LEVEL_LENGTH = 0
var LEVEL_POSITION = Vector2(0, 0)
var LEVEL_NUMBER = 0
var SCORE = 0
var PLAYER_ALIVE = true

func _DEATH():
	PLAYER_ALIVE = false

func _SET_SCORE(x):
	SCORE = x

func _SET_CURRENT(number):
	LEVEL_LENGTH = number
	print (LEVEL_LENGTH)

func _SET_POSITION(x, y):
	LEVEL_POSITION = Vector2(x,y)
	print (LEVEL_POSITION)

func _SET_NUMBER(number):
	LEVEL_NUMBER = number
	print (LEVEL_NUMBER)
