extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
onready var camera = get_parent()

func start(duration = 0.5,frequency = 15, amplitude = 16):
	self.amplitude = amplitude
		
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / float(frequency)
	$Frequency.start()
	
	$Duration.start()
	$Duration.one_shot = true
	
	_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)

	$ShakeTween.interpolate_property(camera,"offset",camera.offset,rand,$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(camera,"offset",camera.offset,Vector2(),$Frequency.wait_time,TRANS,EASE)
	$ShakeTween.start()

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	print(camera.offset)
	_reset()
	$Frequency.stop()
