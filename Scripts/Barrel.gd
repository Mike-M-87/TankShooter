extends Node2D

var tank = {
	"rectx":678,
	"recty":105,
	"rectw":245,
	"recth":282,
	"button1text":"BUY 500/=",
	"button2text":"BUY 2000/=",
	"bar_rectx":1040.047,
	"bar_recty":64.534,
	"bar_rectw":125,
	"bar_recth":270,
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

onready var BarrelSprite = $Sprite
onready var joystick = $CanvasLayer/Joystick/joystick_button
onready var Analog = $CanvasLayer/Analog

var bullet = preload("res://Scenes/Bullet.tscn")

var bullet_speed = 1000
var fire_rate = 0.4
var can_fire = true
var barrel = get_parent()
var prev_value = Vector2()
var value = Vector2()


func _true_value():
	if joystick.get_value() != Vector2(0,0):
		value = joystick.get_value()
		prev_value = value
	if joystick.get_value() == Vector2(0,0):
		value = prev_value
	return value

func _ready():
	BarrelSprite.texture = preload("res://Sprites/Tanks.png")
	BarrelSprite.region_enabled = true
	if load_data():
		tank.barrel_rate = tank.barrel_rate
		BarrelSprite.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
	
func _process(delta):
		
	#_true_value()
	#rotation = _true_value().angle()
	rotation = deg2rad(-Analog.Angle)
	#if joystick.get_button_pos().length() > 15 and can_fire:
	if Analog.Strength > 0.5 and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(0, bullet_speed).rotated(rotation))
		get_parent().get_parent().add_child(bullet_instance)
		$AudioStreamPlayer2D.playing = true
		can_fire = false
		yield(get_tree().create_timer(tank.barrel_rate),"timeout")
		can_fire = true


func _on_Player_killed():
	set_process(false)

func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true

