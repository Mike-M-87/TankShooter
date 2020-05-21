extends KinematicBody2D



var Player = null
var explosion = preload("res://Scenes/BigExplosion.tscn")

var distance2 = 400
var distance = 300
const SLOW_RADIUS = 100
export var max_speed: = 800
var _velocity: = Vector2.ZERO



func _physics_process(delta):
	if Player != null:
		look_at(Player.global_position + Vector2(0, 0))
		var target_global_position: Vector2 = Player.get_global_position()

		_velocity = Steering.follow(
			_velocity,
			global_position,
			target_global_position,
			max_speed
		)
	
	move_and_slide(_velocity)


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		Player = body

func _on_SensorArea_body_entered(body):
	var explosion_instance = explosion.instance()
	explosion_instance.position = get_global_position()
	get_parent().add_child(explosion_instance)
	queue_free()

