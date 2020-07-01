extends Node2D

onready var ScoreLabel = get_node("ScoreLabel")
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
	"kills":0,
	"level":0,
	"tank1_damage":20,
	"protank_damage":40,
	"ult_tank_damage":70,
	"tank1_health":2.0,
	"protank_health":1.0,
	"ult_tankhealth":0.5,
	"tank1_speed":400,
	"protank_speed":600,
	"ult_tankspeed":400,
	"tank1_upgrades":0,
	"protank_upgrades":0,
	"ult_tank_upgrades":0,
	"tank1_upg_txt":"UPGRADE 100/=",
	"protank_upg_txt":"UPGRADE 200/=",
	"ultank_upg_txt":"UPGRADE 300/=",
	"tur1_rate":0.4,
	"turpro_rate":0.3,
	"turult_rate":0.15,
	"tur1_upgrades":0,
	"turpro_upgrades":0,
	"turult_upgrades":0,
	"tur1_upg_points":50,
	"turpro_upg_points":70,
	"turult_upg_points":100,
	}

func _ready():
	if load_data():
		ScoreLabel.set_text(str(tank.kills))
		$LevelBar.value = (tank.level)
	
func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true

func save_data():
	var file = File.new()
	file.open("user://tank", File.WRITE_READ)
	file.store_var(tank)
	
