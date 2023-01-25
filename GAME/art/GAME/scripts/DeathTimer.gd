extends Node2D

var timer:Timer

func _process(delta):
	pass
	#print(timer.time_left)

#creates a timer child
func _ready():
	timer = Timer.new()
	timer.set_wait_time(.5)
	timer.connect("timeout", self, "on_button_timeout")
	add_child(timer)

#sends to the autoload script that the player should die
func on_button_timeout() -> void:
	AutoLoadScript._DEATH()
	timer.stop()

#functions to start/stop timers
func start_timer():
	timer.start()

func stop_timer():
	timer.stop()
