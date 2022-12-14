extends Node2D

var CurrentLevel = 0

const Level_1 = preload("res://GAME/tscn folders/Level_1.tscn")

#calling create new level when the level number changes
func _physics_process(delta):
	#LevelNumber = AutoLoadScript.LEVEL_NUMBER
	#LevelPosition = AutoLoadScript.LEVEL_POSITION
	#CurrentLength = AutoLoadScript.LEVEL_LENGTH
	#LevelSpeed = AutoLoadScript.LEVEL_SPEED
	if CurrentLevel != AutoLoadScript.LEVEL_NUMBER:
		CurrentLevel = AutoLoadScript.LEVEL_NUMBER
		_Create_New_Level(AutoLoadScript.LEVEL_POSITION.x, AutoLoadScript.LEVEL_LENGTH)

#creates new level
func _Create_New_Level(lposition, length):
	print ("new level")
	var Level_Instance = Level_1.instance()
	Level_Instance.position = Vector2(lposition + length, 0)
	call_deferred("add_child", Level_Instance)
