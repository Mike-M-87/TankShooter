extends Control


func _ready():
	get_node("Panel").visible = false
	get_node("BlackOverlay").visible = false
	
func _on_pause_button_pressed():
	$AudioStreamPlayer.playing = true
	get_tree().paused = true
	get_node("Panel").visible = true
	get_node("BlackOverlay").visible = true

func _on_resume_pressed():
	$AudioStreamPlayer.playing = true
	get_tree().paused = false
	get_node("Panel").visible = false
	get_node("BlackOverlay").visible = false
	
func _on_restart_pressed():
	$AudioStreamPlayer.playing = true
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_menu_pressed():
	$AudioStreamPlayer.playing = true
	get_parent().queue_free()
	get_tree().change_scene("res://Scenes/Menu.tscn")
	

