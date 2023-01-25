extends Label

var time

func _physics_process(delta):
	time = "%d"%AutoLoadScript.timer.time_left+" NEXT: "
	text = time
