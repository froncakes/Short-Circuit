extends StaticBody2D

export var state = 0

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		AutoLoadScript.STORED_STATE = state
		AutoLoadScript.CHANGE_STORED = true
		queue_free()
