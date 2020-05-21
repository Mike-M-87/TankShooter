extends AnimatedSprite

func _ready():
	play("animate")

func _on_EnemyDeathEffect_animation_finished():
	queue_free()
