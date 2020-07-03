extends Node2D



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

signal new_spawn()
var startwave1 = true
var startProwave = false
var startUltwave = false

var Healthbar = preload("res://Scenes/HealthBar.tscn")

var PickUp = preload("res://Scenes/PickUp.tscn")
var enemy = preload("res://Scenes/Enemy.tscn")
var enemyPro = preload("res://Scenes/EnemyPro.tscn")
var enemyUlt = preload("res://Scenes/EnemyUlt.tscn")
var spawn_rate = 3
var can_spawn = true
var SpawnPoint

var spawns = 2

func choose(array):
	array.shuffle()
	return array.front()

func _ready():

	$WaveOneTimer.start()
	$WaveTwoTimer.start()
	assert($WaveOneTimer.wait_time == 60)
	assert($WaveTwoTimer.wait_time == 240)
	$PickUpTimer.start()
	load_data()
	if load_data():
		tank.kills = tank.kills
		tank.level = tank.level
	
func _process(delta):
	if load_data():
		tank.kills = tank.kills
	$CanvasLayer/PointsLabel.text = str("Points: ", tank.kills)
	if startwave1 == true:
		if can_spawn:
			SpawnPoint = choose([$SpawnPoint, $SpawnPoint2])
			var enemy_instance = enemy.instance()
			enemy_instance.position = SpawnPoint.get_global_position()
			get_node("Enemies").add_child(enemy_instance)
			emit_signal("new_spawn")
			can_spawn = false
			yield(get_tree().create_timer(spawn_rate),"timeout")
			can_spawn = true

	

	if startProwave == true:
		Pro_wave()
	if startUltwave == true:
		ultimate_wave()
func _physics_process(delta):
	
	if spawns > 6:
		set_process(false)
	
	elif spawns <= 3:
		set_process(true)

func Pro_wave():
	if can_spawn:
		SpawnPoint = choose([$SpawnPoint,$SpawnPoint2])
		var enemy_instance = enemyPro.instance()
		enemy_instance.position = SpawnPoint.get_global_position()
		get_node("Enemies").add_child(enemy_instance)
		emit_signal("new_spawn")
		can_spawn = false
		yield(get_tree().create_timer(spawn_rate),"timeout")
		can_spawn = true

func ultimate_wave():
	if can_spawn:
		SpawnPoint = choose([$SpawnPoint,$SpawnPoint2])
		var enemy_instance = enemyUlt.instance()
		enemy_instance.position = SpawnPoint.get_global_position()
		get_node("Enemies").add_child(enemy_instance)
		emit_signal("new_spawn")
		can_spawn = false
		yield(get_tree().create_timer(spawn_rate),"timeout")
		can_spawn = true
	

func _on_restart_pressed():
	get_tree().get_root().get_node("world").queue_free()
	
func _on_menu_pressed():
	get_tree().get_root().get_node("world").queue_free()

func _on_Player_gameover():
	get_tree().get_root().get_node("world").queue_free()
	

func _on_PickUpTimer_timeout():
	$PickUpTimer.wait_time *= 1.5
	if $PickUpTimer.is_stopped():
		$PickUpTimer.start()
	$CanvasLayer/PickMsg.visible = true
	$CanvasLayer/PickMsg/AnimationPlayer.play("PickMsg")
	var pickup_instance = PickUp.instance()
	pickup_instance.position = $PickUpPosition.get_global_position()
	add_child(pickup_instance)


func _on_Player_killed():
	$CanvasLayer/PointsLabel.visible = false
	$Player/CanvasLayer/Dead/Score.text = str("Your Score: " , tank.kills)
	save_data()
	
func save_data():
	var file = File.new()
	file.open("user://tank", File.WRITE_READ)
	file.store_var(tank)

func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true

func _on_world_new_spawn():
	spawns += 1
	

func _on_WaveOneTimer_timeout():
	$WaveOneTimer.stop()
	startwave1 = false
	startProwave = true
	tank.level += 1
	save_data()

func _on_WaveTwoTimer_timeout():
	$WaveTwoTimer.stop()
	startProwave = false
	startUltwave = true
	
