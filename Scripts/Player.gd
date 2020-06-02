extends KinematicBody2D

var tank = {
	"rectx":678,
	"recty":105,
	"rectw":245,
	"recth":282,
	"tank1text":"EQUIP",
	"button1text":"BUY 500/=",
	"button2text":"BUY 2000/=",
	"bar_rectx":1040.047,
	"bar_recty":64.534,
	"bar_rectw":125,
	"bar_recth":270,
	"barrel1text":"EQUIP",
	"probarreltext":"BUY 300/=",
	"ultbarreltext":"BUY 1000/=",
	"protank_purchased":false,
	"ultimatetank_purchased":false,
	"probarrel_purchased":false,
	"ultbarrel_purchased":false,
	"tank_damage":20,
	"tank_speed":400,
	"tank_health":2,
	"barrel_rate":0.4,
	"kills":0
	}
	
signal health_updated(health)
signal killed()
signal gameover()



onready var joystick = get_parent().get_node("CanvasLayer/Joystick/joystick_button")
onready var Tank = $Tank
onready var TankSprite = $Tank/Sprite
onready var Barrel = $Barrel
export (Color) var killed_color = Color.white
export (float) var max_health = 100
onready var health = max_health setget _set_health
onready var invuln_timer = $InvulnerabilityTimer
onready var dead = $CanvasLayer/Dead
onready var effects_animation = $AnimationPlayer

var prev_value = Vector2()
var value = Vector2()

onready var Analog = get_parent().get_node("CanvasLayer/Analog")



var Move = Vector2()

func _ready():
	if load_data():
		tank.tank_health = tank.tank_health
#func _true_value():
#	if joystick.get_value() != Vector2(0,0):
#		value = joystick.get_value()
#		prev_value = value
#	if joystick.get_value() == Vector2(0,0):
#		value = prev_value
#	return value


func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true
	
	
func _process(delta):
	#_true_value()
	#Tank.rotation = _true_value().angle() 
	
	#on analog schene weare add formula 90-rad2deg(TouchPos.angle_to_point(position))
	# then if we are want to give them back to Radian just add this formual Radian = (Angle - 90)*-1 
	Move = Vector2(cos(-deg2rad(Analog.Angle-90)),sin(-deg2rad(Analog.Angle-90)))*Analog.Strength * (tank.tank_speed)
	
	Tank.rotation = deg2rad(-Analog.Angle)
	
	move_and_slide(Move)

	if Move != Vector2(0,0):
		$AudioStreamPlayer.playing = true
	else:
		$AudioStreamPlayer.playing = false
	
func _physics_process(delta):
	#move_and_slide(joystick.get_value() * speed)
	pass
func damage(amount):
	if invuln_timer.is_stopped():
		invuln_timer.start()
		_set_health(health - amount)

func kill():
	set_physics_process(false)
	set_process(false)
	dead.visible = true
	$CanvasLayer/Dead/DeadPanelAnim.play("DeadPanel")
	emit_signal("killed")

func _set_health(value):
	var prev_health = health
	health = clamp(value , 0 , max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()

func _on_HurtBox_body_entered(body):
	if body.is_in_group("enemybullet"):
		damage(tank.tank_health)
	
func _on_InvulnerabilityTimer_timeout():
	effects_animation.play("normal")


func _on_Player_killed():
	$Tank.modulate = killed_color
	$Barrel.modulate = killed_color
	yield(get_tree().create_timer(5),"timeout")
	queue_free()
	get_tree().change_scene("res://Scenes/Menu.tscn")
	emit_signal("gameover")



func _on_HurtBox_area_entered(area):
	if area.is_in_group("missile"):
		damage((tank.tank_health) * 10)
