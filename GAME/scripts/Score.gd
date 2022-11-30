extends Label

var score

func _physics_process(delta):
	score = "%06d"%AutoLoadScript.SCORE
	text = score
