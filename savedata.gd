extends Control

var configdata = 10
var path = "user://data.json"

var default_data = {
	"player": {
		"name": "Jamie",
		"level":1,
		"health":10
		},
	"options": {
		"music_volume":0.5,
		"cheat_mode":false
	},
	"levels_completed":[1,2,3]
}


var data2 = {
	"comment":"awesome",
	"comment2":"awful"
}

var data = {}
var config = ConfigFile.new()

func _ready():
	load_game()
	update_text()
	
func load_game():
	var file = File.new()
	if not file.file_exists(path):
		reset_data()
		return
	file.open(path,file.READ)
	var dictionary = file.get_var()
	data = parse_json(dictionary)
	file.close()

func save_game():
	var file =File.new()
	file.open(path,File.WRITE)
	file.store_var(to_json(data))
	file.close()
	
func reset_data():
	data = default_data.duplicate(true)
	
func update_text():
	$Panel/Label.text += str(data) + "\n"
	
func save_data():
	var file = File.new()
	file.open("user://data2", File.WRITE_READ)
	file.store_var(data2)

func load_data():
	var file = File.new()
	if !file.file_exists("user://data2"):
		return false
	file.open("user://data2",File.READ_WRITE)
	data2 = file.get_var()
	file.close()
	return true
	
func savedata1():
	config.save("user://saves1")
	config.set_value("Values","ValueOne",configdata)
	
func load_data1():
	config.load("user://saves1")
	configdata = config.get_value("Values","ValueOne",configdata)


func _on_remove_health_pressed():
	data.player.health -= 1
	update_text()
	
func _on_save_pressed():
	save_game()

func _on_load_pressed():
	load_game()
	update_text()



func _on_delete_pressed():
	var dir = Directory.new()
	dir.remove(path)
	reset_data()
	update_text()
