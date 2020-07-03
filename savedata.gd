extends Control

var path = "user://data.json"
var config = ConfigFile.new()
var configdata = {
	"name": "Jamie",
	"level":1,
	"health":10,
	"age":17,
}



var test1 = {
	"name":"Mike",
	"age":17
}
var test2 ={
	"name":"Fide",
	"age":18
}
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


func _ready():
	var file = File.new()
	if !file.file_exists("user://configfile"):
		save_data_cfg()
		save_data_cfg()
		print("kkkhkhk")
	#load_data_cfg()
	#update_text()
	
	
func load_data_json(savepath):
	#if using json the savepath string must have the ".json" extension.
	var file = File.new()
	if not file.file_exists("user://"+savepath):
		reset_data()
	file.open("user://"+savepath,file.READ)
	var dictionary = file.get_var()
	if savepath == "test1.json":
		test1 = parse_json(dictionary)
	elif savepath == "test2.json":
		test2 = parse_json(dictionary)
	file.close()

func save_data_json(savepath):
	#if using json the savepath string must have the ".json" extension.
	var file =File.new()
	file.open("user://"+savepath,File.WRITE)
	if savepath == "test1.json":
		file.store_var(to_json(test1))
	elif savepath == "test2.json":
		file.store_var(to_json(test2))
	file.close()
	
func reset_data():
	pass
	
func update_text():
	#$Panel/Label.text += str(configdata) + "\n"
	$Panel/Label.text += str(test1) 
	$Panel/Label.text += str(test2) + "\n"

		
func save_data_txt(savepath):
	var file = File.new()
	file.open("user://"+savepath, File.WRITE_READ)
	if savepath == "test1":
		file.store_var(test1)
	elif savepath == "test2":
		file.store_var(test2)
	file.close()


func load_data_txt(savepath):
	var file = File.new()
	if !file.file_exists("user://"+savepath):
		return false
	file.open("user://"+savepath,File.READ_WRITE)
	if savepath == "test1":
		test1 = file.get_var()
	if savepath == "test2":
		test2 = file.get_var()
	file.close()
	return true
	
	
func save_data_cfg():
	config.save("user://configfile")
	config.set_value("section1","test1",test1)
	config.set_value("section1","test2",test2)
	
	
func load_data_cfg():
	config.load("user://configfile")
	test1 = config.get_value("section1","test1",test1)
	test2 = config.get_value("section1","test2",test2)


func _on_remove_health_pressed():
	test1.age -= 1
	test2.age -= 1
	update_text()
	
func _on_save_pressed():
	save_data_cfg()


func _on_load_pressed():
	load_data_cfg()
	update_text()
	



func _on_delete_pressed():
	var dir = Directory.new()
	dir.remove(path)
	reset_data()
	update_text()
