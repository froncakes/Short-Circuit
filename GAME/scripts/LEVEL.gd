extends Level

func _physics_process(delta):
	if AutoLoadScript.PLAYER_ALIVE == true:
		position += Vector2(-AutoLoadScript.LEVEL_SPEED,0)
		#print (position)

func _on_Entrance_body_entered(body):
	#print(body)
	if body.name == "Player":
		AutoLoadScript._SET_CURRENT(Level_Length)
		AutoLoadScript._SET_POSITION(get_global_position().x,get_global_position().y)
		AutoLoadScript._SET_NUMBER(AutoLoadScript.LEVEL_NUMBER+1)
		$Entrance.queue_free()


func _on_Exit_body_exited(body):
	if body.name == "Player":
		AutoLoadScript._SET_SCORE(AutoLoadScript.SCORE+30)
		print(AutoLoadScript.SCORE)
		$Exit.queue_free()
