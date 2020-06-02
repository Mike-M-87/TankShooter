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
	"kills":0
	}

signal new_spawn()
var startwave1 = true
var startProwave = false
var startUltwave = false


var PickUp = preload("res://Scenes/PickUp.tscn")
var enemy = preload("res://Scenes/Enemy.tscn")
var enemyPro = preload("res://Scenes/EnemyPro.tscn")
var enemyUlt = preload("res://Scenes/EnemyUlt.tscn")
var spawn_rate = 3
var can_spawn = true
var SpawnPoint

var spawns = -1

func choose(array):
	array.shuffle()
	return array.front()

func _ready():
	
	$PickUpTimer.start()
	
	if load_data():
		tank.kills = tank.kills
		
	yield(get_tree().create_timer(60),"timeout")
	startwave1 = false
	startProwave = true
	yield(get_tree().create_timer(180),"timeout")
	startProwave = false
	startUltwave = true

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
	var enemies = get_node("Enemies").get_child_count()
	if enemies > 10:
		set_process(false)
	else:
		set_process(true)
func Pro_wave():
	if can_spawn:
		SpawnPoint = choose([$SpawnPoint,$SpawnPoint2])
		var enemy_instance = enemyPro.instance()
		enemy_instance.position = SpawnPoint.get_global_position()
		get_node("Enemies").add_child(enemy_instance)
		emit_signal("new_spawn")
		can_spawn = false
		yield(get_tree().create_timer(3),"timeout")
		can_spawn = true

func ultimate_wave():
	if can_spawn:
		SpawnPoint = choose([$SpawnPoint,$SpawnPoint2])
		var enemy_instance = enemyUlt.instance()
		enemy_instance.position = SpawnPoint.get_global_position()
		get_node("Enemies").add_child(enemy_instance)
		emit_signal("new_spawn")
		can_spawn = false
		yield(get_tree().create_timer(5),"timeout")
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
