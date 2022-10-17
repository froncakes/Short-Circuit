extends Node2D

var LevelSpeed = AutoLoadScript.LEVEL_SPEED

func _physics_process(delta):
	position -= Vector2(LevelSpeed,0)
