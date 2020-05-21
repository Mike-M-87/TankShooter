extends Node2D

var bullet = preload("res://Scenes/EnemyUltBullet.tscn")
var missile = preload("res://Scenes/EnemyMissile.tscn")
var bullet_speed = 1500
var fire_rate = 0.8
var can_fire = true

func _process(delta):
	if can_fire == true:
			var bullet_instance = bullet.instance()
			bullet_instance.position = $BulletPoint.get_global_position()
			bullet_instance.rotation_degrees = rotation_degrees
			bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
			get_parent().get_parent().add_child(bullet_instance)
			can_fire = false
			yield(get_tree().create_timer(fire_rate),"timeout")
			can_fire = true



func _on_EnemyUlt_killed():
	set_process(false)
