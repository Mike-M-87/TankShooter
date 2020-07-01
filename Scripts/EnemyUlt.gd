extends KinematicBody2D

signal killed()
signal enemy_ult_health_updated(health)
var missile = preload("res://Scenes/EnemyMissile.tscn")
var can_fire = true

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
	"kills":0,
	"level":0,
	"tank1_damage":20,
	"protank_damage":40,
	"ult_tank_damage":70,
	"tank1_health":2.0,
	"protank_health":1.0,
	"ult_tankhealth":0.5,
	"tank1_speed":400,
	"protank_speed":600,
	"ult_tankspeed":400,
	"tank1_upgrades":0,
	"protank_upgrades":0,
	"ult_tank_upgrades":0,
	"tank1_upg_txt":"UPGRADE 100/=",
	"protank_upg_txt":"UPGRADE 200/=",
	"ultank_upg_txt":"UPGRADE 300/=",
	"tur1_rate":0.4,
	"turpro_rate":0.3,
	"turult_rate":0.15,
	"tur1_upgrades":0,
	"turpro_upgrades":0,
	"turult_upgrades":0,
	"tur1_upg_points":50,
	"turpro_upg_points":70,
	"turult_upg_points":100,
	}

var EnemyDeathEffect = preload("res://Scenes/EnemyDeathEffect.tscn")

var kills = 0
var direction = Vector2()
var distance2 = 400
var distance = 300
const SLOW_RADIUS = 100

export (float) var max_health = 1000
onready var health = max_health setget _set_health

export var max_speed: = 200
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
		$entankUlt.look_at(Player.global_position + Vector2(0, 0))
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

func damage(amount):
	_set_health(health - amount)
	enHealthBar.visible = true

func kill():
	set_physics_process(false)
	set_process(false)
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	emit_signal("killed")

func _set_health(value):
	var prev_health = health
	health = clamp(value , 0 , max_health)
	if health != prev_health:
		emit_signal("enemy_ult_health_updated", health)
		if health == 0:
			kill()

func _on_EnemyUlt_killed():
	tank.kills += 3
	kills += 1
	save_data()
	$entankUlt.modulate = killed_color
	yield(get_tree().create_timer(2),"timeout")
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


func _process(delta):
	if load_data():
		tank.kills = tank.kills
	if can_fire == true:
		var missile_instance = missile.instance()
		missile_instance.position = $entankUlt/BulletPoint.get_global_position()
		get_tree().get_root().get_node("world").get_node("Enemies").add_child(missile_instance)
		can_fire = false
		yield(get_tree().create_timer(5),"timeout")
		can_fire = true


func save_data():
	var file = File.new()
	file.open("user://tank", File.WRITE_READ)
	file.store_var(tank)
	
