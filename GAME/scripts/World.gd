extends Node2D

#var CurrentLevel = 0

#const Level_1 = preload("res://GAME/tscn folders/Level_1.tscn")

#func _physics_process(delta):
	#LevelNumber = AutoLoadScript.LEVEL_NUMBER
	#LevelPosition = AutoLoadScript.LEVEL_POSITION
	#CurrentLength = AutoLoadScript.LEVEL_LENGTH
	#LevelSpeed = AutoLoadScript.LEVEL_SPEED
	#if CurrentLevel != AutoLoadScript.LEVEL_NUMBER:
		#CurrentLevel = AutoLoadScript.LEVEL_NUMBER
		#_Create_New_Level(AutoLoadScript.LEVEL_POSITION.x, AutoLoadScript.LEVEL_LENGTH)

#func _Create_New_Level(lposition, length):
	#print ("new level")
	#var Level_Instance = Level_1.instance()
	#Level_Instance.position = Vector2(lposition + length, 0)
	#call_deferred("add_child", Level_Instance)

#kills player if they go below the camera
func _on_Floor_body_entered(body):
	if body.name == "Player":
		AutoLoadScript._DEATH()
		body.queue_free()

#kills player if they go all the way to the left 
func _on_Left_Wall_body_entered(body):
	if body.name == "Player":
		AutoLoadScript._DEATH()
		body.queue_free()
