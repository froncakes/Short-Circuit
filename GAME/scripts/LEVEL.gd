extends StaticBody2D

func _physics_process(delta):
	pass
	#if AutoLoadScript.PLAYER_ALIVE == true:
		#position += Vector2(-AutoLoadScript.LEVEL_SPEED,0)
		#print (position)

#increases level number (which gets called in the Levels script)
#and gets position and level length for creating the new level
func _on_Entrance_body_entered(body):
	#print(body)
	if body.name == "Player":
		AutoLoadScript._SET_CURRENT(get_parent().Level_Length)
		AutoLoadScript._SET_POSITION(get_global_position().x,get_global_position().y)
		AutoLoadScript._SET_NUMBER(AutoLoadScript.LEVEL_NUMBER+1)
		$Entrance.queue_free()

#on exiting a level increases score and deletes the exit so they cant recollect it
func _on_Exit_body_exited(body):
	if body.name == "Player":
		AutoLoadScript._SET_SCORE(AutoLoadScript.SCORE+30)
		print(AutoLoadScript.SCORE)
		$Exit.queue_free()
