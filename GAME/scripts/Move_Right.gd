extends Node2D

func _physics_process(delta):
	if AutoLoadScript.PLAYER_ALIVE == true:
		position += Vector2(AutoLoadScript.LEVEL_SPEED,0)
		#print (position)
