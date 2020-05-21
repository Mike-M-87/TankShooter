extends StaticBody2D

signal picked()


func _on_PickUpArea_body_entered(body):
	var Player = get_parent().get_node("Player")
	var health = Player.health
	var PickMsg = get_parent().get_node("CanvasLayer/PickMsg")
	if body.is_in_group("player"):
		Player.health += 50
		PickMsg.visible = false
		emit_signal("picked")
		queue_free()
