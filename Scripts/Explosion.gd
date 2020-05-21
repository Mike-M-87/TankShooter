extends AnimatedSprite

func _ready():
	play("explode")
func _on_Explosion_animation_finished():
	queue_free()
