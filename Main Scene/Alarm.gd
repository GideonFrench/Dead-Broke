extends AudioStreamPlayer

var alarm : bool = false

func _ready():
	stop()
	alarm = false

func _process(delta):
	pass

func alarm_sound():
	if alarm == false:
		alarm = true
		play()
	
func stop_alarm():
	alarm = false
	stop()
