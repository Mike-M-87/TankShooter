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
signal enemy_pro_health_updated(health)
signal enemy_pro_killed()

var EnemyDeathEffect = preload("res://Scenes/EnemyDeathEffect.tscn")
var kills = 0
var direction = Vector2()
var distance2 = 400
var distance = 300
const SLOW_RADIUS = 100

export (float) var max_health = 400
onready var health = max_health setget _set_health

export var max_speed: = 350
var _velocity: = Vector2.ZERO

var Player = null

onready var enHealthBar = $EnemyHealthBar
export (Color) var  killed_color = Color.black

func _ready():
	if load_data():
		tank.kills = tank.kills
		tank.tank_damage = tank.tank_damage
	
func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true
	
func _physics_process(delta):
	if Player != null:
		$enTankPro.look_at(Player.global_position + Vector2(0, 0))
		var target_global_position: Vector2 = Player.get_global_position()
		if global_position.distance_to(target_global_position) < distance:
			direction = Vector2(-1,-1)
		if global_position.distance_to(target_global_position) > distance:
			direction = Vector2(1,1)
		
		if global_position.distance_to(target_global_position) > distance && global_position.distance_to(target_global_position) < distance2:
			direction = Vector2(0,0)
		
		
		_velocity = Steering.arrive_to(
			_velocity,
			global_position,
			target_global_position,
			max_speed,
			SLOW_RADIUS
		)
	
	move_and_slide(_velocity * direction)


func _process(delta):
	if load_data():
		tank.kills = tank.kills
	
func damage(amount):
	_set_health(health - amount)
	enHealthBar.visible = true

func kill():
	set_physics_process(false)
	set_process(false)
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	emit_signal("enemy_pro_killed")

func _set_health(value):
	var prev_health = health
	health = clamp(value , 0 , max_health)
	if health != prev_health:
		emit_signal("enemy_pro_health_updated", health)
		if health == 0:
			kill()

func _on_EnemyPro_enemy_pro_killed():
	tank.kills += 2
	kills += 1
	save_data()
	$enTankPro.modulate = killed_color
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
	get_parent().get_parent().spawns -= 1


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		Player = body

func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		Player = null

func _on_HurtBox_body_entered(body):
	if body.is_in_group("playerbullet"):
		damage(tank.tank_damage)
		
func save_data():
	var file = File.new()
	file.open("user://tank", File.WRITE_READ)
	file.store_var(tank)
	
