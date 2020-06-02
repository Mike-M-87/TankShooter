extends StaticBody2D

signal picked()

var tank = {
	"rectx":678,
	"recty":105,
	"rectw":245,
	"recth":282,
	"tank1text":"EQUIP",
	"button1text":"BUY 500/=",
	"button2text":"BUY 2000/=",
	"bar_rectx":1040.047,
	"bar_recty":64.534,
	"bar_rectw":125,
	"bar_recth":270,
	"barrel1text":"EQUIP",
	"probarreltext":"BUY 300/=",
	"ultbarreltext":"BUY 1000/=",
	"protank_purchased":false,
	"ultimatetank_purchased":false,
	"probarrel_purchased":false,
	"ultbarrel_purchased":false,
	"tank_damage":20,
	"tank_speed":400,
	"tank_health":2,
	"barrel_rate":0.4,
	"kills":0
	}

func _ready():
	load_data()
func _on_PickUpArea_body_entered(body):
	var Player = get_parent().get_node("Player")
	var health = Player.health
	var PickMsg = get_parent().get_node("CanvasLayer/PickMsg")
	if body.is_in_group("player"):
		Player.health += (tank.tank_health * 20)
		PickMsg.visible = false
		emit_signal("picked")
		queue_free()

func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true
