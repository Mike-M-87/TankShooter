extends Control


var tank = {
	"rectx":678,
	"recty":105,
	"rectw":245,
	"recth":282,
	"button1text":"BUY 500/=",
	"button2text":"BUY 2000/=",
	"bar_rectx":1040.047,
	"bar_recty":64.534,
	"bar_rectw":125,
	"bar_recth":270,
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
	
	$Panel.visible = true
	$Panel2.visible = false
	if load_data():
		$Panel/protank.text = (tank.button1text)
		$Panel/ultimatetank.text = (tank.button2text)
		$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
		$Panel2/probarrel.text = (tank.probarreltext)
		$Panel2/ultbarrel.text = (tank.ultbarreltext)
		$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
		$ScoreLabel.text = str("CashPoints: ", tank.kills)
		
		tank.protank_purchased = tank.protank_purchased
		tank.ultimatetank_purchased = tank.ultimatetank_purchased
		tank.probarrel_purchased = tank.probarrel_purchased
		tank.ultbarrel_purchased = tank.ultbarrel_purchased

		
		
func _process(delta):
	if load_data():
		$ScoreLabel.text = str("CashPoints: ", tank.kills)
		tank.protank_purchased = tank.protank_purchased
		tank.ultimatetank_purchased = tank.ultimatetank_purchased
		tank.probarrel_purchased = tank.probarrel_purchased
		tank.ultbarrel_purchased = tank.ultbarrel_purchased

func _on_quit_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_barrelpanel_pressed():
	$Panel2.visible = true
	$Panel.visible = false

func _on_tankpanel_pressed():
	$Panel.visible = true
	$Panel2.visible = false

func save_data():
	var file = File.new()
	file.open("user://tank", File.WRITE_READ)
	file.store_var(tank)
	
func load_data():
	var file = File.new()
	if !file.file_exists("user://tank"):
		return false
	file.open("user://tank",File.READ_WRITE)
	tank = file.get_var()
	file.close()
	return true

func _on_protank_pressed():
	if tank.protank_purchased == false:
		if tank.kills >= 500:
			tank.rectx = 667
			tank.recty = 535.898
			tank.rectw = 272
			tank.recth = 297
			tank.button1text = "USE"
			tank.kills -= 500
			tank.protank_purchased = true
			tank.tank_damage = 40
			tank.tank_speed = 600
			tank.tank_health = 1
			save_data()
			$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
			$Panel/protank.text = (tank.button1text)
			
		else:
			$notePanel.visible = true
			yield(get_tree().create_timer(2),"timeout")
			$notePanel.visible = false
	
	elif tank.protank_purchased == true:
		tank.rectx = 667
		tank.recty = 535.898
		tank.rectw = 272
		tank.recth = 297
		tank.button1text = "USE"
		tank.tank_damage = 40
		tank.tank_speed = 600
		tank.tank_health = 1
		save_data()
		$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
		$Panel/protank.text = (tank.button1text)
		$notePanel.visible = false

func _on_ultimatetank_pressed():
	if tank.ultimatetank_purchased == false:
		if tank.kills >=2000:
			tank.rectx = 34
			tank.recty = 879
			tank.rectw = 353
			tank.recth = 447
			tank.button2text = "USE"
			tank.tank_damage = 70
			tank.tank_speed = 400
			tank.tank_health = 0.5
			tank.kills -= 2000
			tank.ultimatetank_purchased = true
			save_data()
			$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
			$Panel/ultimatetank.text = (tank.button2text)
			
		else:
			$notePanel.visible = true
			yield(get_tree().create_timer(2),"timeout")
			$notePanel.visible = false
			
	elif tank.ultimatetank_purchased == true:
		tank.rectx = 34
		tank.recty = 879
		tank.rectw = 353
		tank.recth = 447
		tank.tank_damage = 70
		tank.tank_speed = 400
		tank.tank_health = 0.5
		tank.button2text = "USE"
		save_data()
		$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
		$Panel/ultimatetank.text = (tank.button2text)
		$notePanel.visible = false

		
		

func _on_tank1_pressed():
	tank.rectx = 682
	tank.recty = 113
	tank.rectw = 235
	tank.recth = 277
	tank.tank_damage = 20
	tank.tank_speed = 400
	tank.tank_health = 2
	save_data()
	$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)

func _on_barrel1_pressed():
	tank.bar_rectx = 1040.047
	tank.bar_recty = 64.534
	tank.bar_rectw = 125
	tank.bar_recth = 270
	tank.barrel_rate = 0.4
	save_data()
	$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
	

func _on_probarrel_pressed():
	if tank.probarrel_purchased == false:
		if tank.kills >= 300:
			tank.bar_rectx = 1030.967
			tank.bar_recty = 515.725
			tank.bar_rectw = 165.283
			tank.bar_recth = 274.872
			tank.probarreltext = "USE"
			tank.probarrel_purchased = true
			tank.kills -= 300
			tank.barrel_rate = 0.3
			save_data()
			$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
			$Panel2/probarrel.text = (tank.probarreltext)
			
		else:
			$notePanel.visible = true
			yield(get_tree().create_timer(2),"timeout")
			$notePanel.visible = false
			
	elif tank.probarrel_purchased == true:
		tank.bar_rectx = 1030.967
		tank.bar_recty = 515.725
		tank.bar_rectw = 165.283
		tank.bar_recth = 274.872
		tank.barrel_rate = 0.3
		tank.probarreltext = "USE"
		save_data()
		$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
		$Panel2/probarrel.text = (tank.probarreltext)
		$notePanel.visible = false
		

func _on_ultbarrel_pressed():
	if tank.ultbarrel_purchased == false:
		if tank.kills >= 1000:
			tank.bar_rectx = 1094
			tank.bar_recty = 884.183
			tank.bar_rectw = 159.25
			tank.bar_recth = 327.75
			tank.ultbarreltext = "USE"
			tank.ultbarrel_purchased = true
			tank.kills -= 1000
			tank.barrel_rate = 0.15
			save_data()
			$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
			$Panel2/ultbarrel.text = (tank.ultbarreltext)
			
		else:
			$notePanel.visible = true
			yield(get_tree().create_timer(2),"timeout")
			$notePanel.visible = false
	
	elif tank.ultbarrel_purchased == true:
		tank.bar_rectx = 1094
		tank.bar_recty = 884.183
		tank.bar_rectw = 159.25
		tank.bar_recth = 327.75
		tank.ultbarreltext = "USE"
		tank.barrel_rate = 0.15
		save_data()
		$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
		$Panel2/ultbarrel.text = (tank.ultbarreltext)
		$notePanel.visible = false

