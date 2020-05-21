extends AnimatedSprite

func _ready():
	play("explode")

func _on_BigExplosion_animation_finished():
	queue_free()
