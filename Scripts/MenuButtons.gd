extends Control

onready var LoadPanel = get_parent().get_node("LoadPanel")

func _ready():
	LoadPanel.visible = false
	get_tree().paused = false
	

func _on_newgame_pressed():
	var file = File.new()
	if file.file_exists("user://tank"):
		get_tree().get_root().get_node("Menu").queue_free()
		get_tree().change_scene("res://World.tscn")
	else:
		LoadPanel.visible = true
		yield(get_tree().create_timer(4),"timeout")
		LoadPanel.visible = false

func _on_quit_pressed():
	get_tree().quit()


func _on_upgrade_pressed():
	get_tree().change_scene("res://upgrademenu.tscn")
