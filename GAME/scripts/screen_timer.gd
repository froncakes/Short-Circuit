extends Label

var time

func _physics_process(delta):
	if AutoLoadScript.STORED_STATE == null:
		time = "%d"%AutoLoadScript.timer.time_left+" NEXT: "+"%d"%AutoLoadScript.NEXT_STATE+" STORED: "
	else:
		time = "%d"%AutoLoadScript.timer.time_left+" NEXT: "+"%d"%AutoLoadScript.NEXT_STATE+" STORED: "+"%d"%AutoLoadScript.STORED_STATE
	text = time
