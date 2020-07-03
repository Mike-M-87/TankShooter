extends Panel

var config = ConfigFile.new()
var test1 = {
	"name":"Mike",
	"age":17
}
var test2 ={
	"name":"Fide",
	"age":18
}

func _ready():
	load_data_cfg()
	update_text()
	
func load_data_cfg():
	config.load("user://configfile")
	test1 = config.get_value("section1","test1")
	test2 = config.get_value("section1","test2")

func update_text():
	#$Panel/Label.text += str(configdata) + "\n"
	$Label.text += str(test1) 
	$Label.text += str(test2) + "\n"


func _on_remove_health_pressed():
	test1.age -= 1
	test2.age -= 1
	update_text()

func save_data_cfg():
	config.save("user://configfile")
	config.set_value("section1","test1",test1)
	config.set_value("section1","test2",test2)
	
func _on_save_pressed():
	save_data_cfg()


func _on_load_pressed():
	load_data_cfg()
	update_text()
	
