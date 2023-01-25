extends Node2D

#starts death timer if the player is too far down
func _on_Floor_body_entered(body):
	if body.name == "Player":
		if DeathTimer.timer.time_left == 0:
			DeathTimer.start_timer()


#starts death timer if the player is too far left
func _on_Left_Wall_body_entered(body):
	if body.name == "Player":
		if DeathTimer.timer.time_left == 0:
			DeathTimer.start_timer()

#stops timer if the player exits the areas
func _on_Left_Wall_body_exited(body):
	if body.name == "Player":
		DeathTimer.stop_timer()

func _on_Floor_body_exited(body):
	if body.name == "Player":
		DeathTimer.stop_timer()
