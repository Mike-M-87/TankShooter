extends RigidBody2D

var explosion = preload("res://Scenes/Explosion.tscn")


func _on_Bullet_body_entered(body):
	var explosion_instance = explosion.instance()
	explosion_instance.position = get_global_position()
	get_parent().add_child(explosion_instance)
	queue_free()
