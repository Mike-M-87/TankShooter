extends Control


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
	$Panel.visible = true
	$Panel2.visible = false
	if load_data():
		tank.protank_purchased = tank.protank_purchased
		tank.ultimatetank_purchased = tank.ultimatetank_purchased
		tank.probarrel_purchased = tank.probarrel_purchased
		tank.ultbarrel_purchased = tank.ultbarrel_purchased

		
		
func _process(delta):
	load_ugrades_data()
	
func _on_quit_pressed():
	$AudioStreamPlayer.playing = true
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_barrelpanel_pressed():
	$AudioStreamPlayer.playing = true
	$Panel2.visible = true
	$Panel.visible = false

func _on_tankpanel_pressed():
	$AudioStreamPlayer.playing = true
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
	$AudioStreamPlayer.playing = true
	if tank.protank_purchased == false:
		if tank.kills >= 500:
			equip_protank()
			tank.kills -= 500
			tank.protank_purchased = true
			save_data()
		else:
			not_enough_points()
	
	elif tank.protank_purchased == true:
		equip_protank()
		
func equip_protank():
	tank.rectx = 667
	tank.recty = 535.898
	tank.rectw = 272
	tank.recth = 297
	tank.button1text = "EQUIPPED"
	if tank.ultimatetank_purchased == true:
		tank.button2text = "EQUIP"
	tank.tank1text = "EQUIP"
	tank.tank_damage = tank.protank_damage
	tank.tank_speed = tank.protank_speed
	tank.tank_health = tank.protank_health
	save_data()
	$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
	$Panel/protank.text = (tank.button1text)


func _on_ultimatetank_pressed():
	$AudioStreamPlayer.playing = true
	if tank.ultimatetank_purchased == false:
		if tank.kills >=2000:
			equip_ultank()
			tank.kills -= 2000
			tank.ultimatetank_purchased = true
			save_data()
			
		else:
			not_enough_points()
			
	elif tank.ultimatetank_purchased == true:
		equip_ultank()

func equip_ultank():
	tank.rectx = 34
	tank.recty = 879
	tank.rectw = 353
	tank.recth = 447
	tank.tank_damage = tank.ult_tank_damage
	tank.tank_speed = tank.ult_tankspeed
	tank.tank_health = tank.ult_tankhealth
	tank.tank1text = "EQUIP"
	if tank.protank_purchased == true:
		tank.button1text = "EQUIP"
	tank.button2text = "EQUIPPED"
	save_data()
	$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
	$Panel/ultimatetank.text = (tank.button2text)
	#$notePanel.visible = false	

func _on_tank1_pressed():
	$AudioStreamPlayer.playing = true
	tank.rectx = 682
	tank.recty = 113
	tank.rectw = 235
	tank.recth = 277
	tank.tank_damage = tank.tank1_damage
	tank.tank_speed = tank.tank1_speed
	tank.tank_health = tank.tank1_health
	tank.tank1text = "EQUIPPED"
	if tank.ultimatetank_purchased == true and tank.protank_purchased == false:
		tank.button2text = "EQUIP"
	if tank.protank_purchased == true and tank.ultimatetank_purchased == false:
		tank.button1text = "EQUIP"
	if tank.protank_purchased == true and tank.ultimatetank_purchased == true:
		tank.button1text = "EQUIP"
		tank.button2text = "EQUIP"
	save_data()
	$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)

func _on_barrel1_pressed():
	$AudioStreamPlayer.playing = true
	tank.bar_rectx = 1040.047
	tank.bar_recty = 64.534
	tank.bar_rectw = 125
	tank.bar_recth = 270
	tank.barrel_rate = tank.tur1_rate
	tank.barrel1text = "EQUIPPED"
	if tank.probarrel_purchased == true and tank.ultbarrel_purchased == false:
		tank.probarreltext = "EQUIP"
	if tank.probarrel_purchased == false and tank.ultbarrel_purchased == true:
		tank.ultbarreltext = "EQUIP"
	if tank.probarrel_purchased == true and tank.ultbarrel_purchased == true:
		tank.probarreltext = "EQUIP"
		tank.ultbarreltext = "EQUIP"
	save_data()
	$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
	

func _on_probarrel_pressed():
	$AudioStreamPlayer.playing = true
	if tank.probarrel_purchased == false:
		if tank.kills >= 300:
			equip_probarrel()
			tank.probarrel_purchased = true
			tank.kills -= 300
			save_data()
		else:
			not_enough_points()
			
	elif tank.probarrel_purchased == true:
		equip_probarrel()

func equip_probarrel():
	tank.bar_rectx = 1030.967
	tank.bar_recty = 515.725
	tank.bar_rectw = 165.283
	tank.bar_recth = 274.872
	tank.barrel_rate = tank.turpro_rate
	tank.probarreltext = "EQUIPPED"
	if tank.ultbarrel_purchased == true:
		tank.ultbarreltext = "EQUIP"
	tank.barrel1text = "EQUIP"
	save_data()
	$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
	$Panel2/probarrel.text = (tank.probarreltext)


func _on_ultbarrel_pressed():
	$AudioStreamPlayer.playing = true
	if tank.ultbarrel_purchased == false:
		if tank.kills >= 1000:
			equip_ultbarrel()
			tank.ultbarrel_purchased = true
			tank.kills -= 1000
			save_data()
		else:
			not_enough_points()
	
	elif tank.ultbarrel_purchased == true:
		equip_ultbarrel()
		
func equip_ultbarrel():
	tank.bar_rectx = 1094
	tank.bar_recty = 884.183
	tank.bar_rectw = 159.25
	tank.bar_recth = 327.75
	tank.ultbarreltext = "EQUIPPED"
	if tank.probarrel_purchased == true:
		tank.probarreltext = "EQUIP"
	tank.barrel1text = "EQUIP"
	tank.barrel_rate = tank.turult_rate
	save_data()
	$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)
	$Panel2/ultbarrel.text = (tank.ultbarreltext)



func _on_upgrade_tank1_pressed():
	if tank.tank1_upgrades == 0:
		if tank.kills >= 100:
			tank.tank1_damage += 10
			tank.tank1_health -= 0.5
			tank.tank1_speed += 50
			tank.tank1_upgrades += 1
			tank.kills -= 100
			tank.tank1_upg_txt = "UPGRADE 150/="
			_on_tank1_pressed()
		else:
			not_enough_points()
	elif tank.tank1_upgrades == 1:
		if tank.kills >= 150:
			tank.tank1_damage += 10
			tank.tank1_health -= 0.5
			tank.tank1_speed += 50
			tank.tank1_upgrades += 1
			tank.kills -= 150
			tank.tank1_upg_txt = "UPGRADE: MAX"
			_on_tank1_pressed()
		else:
			not_enough_points()
	save_data()


func _on_upgrade_protank_pressed():
	if tank.protank_purchased == true:
		if tank.protank_upgrades  == 0:
			if tank.kills >= 200:
				tank.protank_damage += 10
				tank.protank_health -= 0.25
				tank.protank_upgrades += 1
				tank.kills -= 200
				tank.protank_upg_txt = "UPGRADE 250"
				equip_protank()
			else:
				not_enough_points()
		elif tank.protank_upgrades == 1:
			if tank.kills >= 250:
				tank.protank_damage += 10
				tank.protank_health -= 0.25
				tank.protank_upgrades += 1
				tank.kills -= 250
				tank.protank_upg_txt = "UPGRADE: MAX"
				equip_protank()
			else:
				not_enough_points()
	else:
		buy_first()
		
	save_data()

func _on_upgrade_ultank_pressed():
	if tank.ultimatetank_purchased == true:
		if tank.ult_tank_upgrades == 0:
			if tank.kills >= 300:
				tank.ult_tank_damage += 10
				tank.ult_tankhealth -= 0.125
				tank.ult_tankspeed += 50
				tank.ult_tank_upgrades += 1
				tank.ultank_upg_txt = "UPGRADE 400/="
				tank.kills -= 300
				equip_ultank()
				print("pippii")
			else:
				not_enough_points()
		elif tank.ult_tank_upgrades == 1:
			if tank.kills >= 400:
				tank.ult_tank_damage += 10
				tank.ult_tankhealth -= 0.125
				tank.ult_tank_upgrades += 1
				tank.ultank_upg_txt = "UPGRADE MAX"
				print("pippii")
				equip_ultank()
				tank.kills -= 400
			else:
				not_enough_points()
	else:
		buy_first()
	save_data()

func not_enough_points():
	$notePanel.visible = true
	yield(get_tree().create_timer(2),"timeout")
	$notePanel.visible = false

func buy_first():
	$notePanel2.visible = true
	yield(get_tree().create_timer(2),"timeout")
	$notePanel2.visible = false


func load_ugrades_data():
	if load_data():
		$ScoreLabel.text = str("CashPoints: ", tank.kills)
		tank.protank_purchased = tank.protank_purchased
		tank.ultimatetank_purchased = tank.ultimatetank_purchased
		tank.probarrel_purchased = tank.probarrel_purchased
		tank.ultbarrel_purchased = tank.ultbarrel_purchased
		
		$Panel/tank1.text = (tank.tank1text)
		$Panel/protank.text = (tank.button1text)
		$Panel/ultimatetank.text = (tank.button2text)
		$Panel/mySprite.region_rect = Rect2(tank.rectx,tank.recty,tank.rectw,tank.recth)
		$Panel2/barrel1.text = (tank.barrel1text)
		$Panel2/probarrel.text = (tank.probarreltext)
		$Panel2/ultbarrel.text = (tank.ultbarreltext)
		$Panel2/mySprite2.region_rect = Rect2(tank.bar_rectx,tank.bar_recty,tank.bar_rectw,tank.bar_recth)

		$Panel/Speed1.value = (tank.tank1_speed)/10
		$Panel/Damage1.value = (tank.tank1_damage)
		$Panel/Health1.value = (1/tank.tank1_health) * 30
		$Panel/HealthPro.value = (1/tank.protank_health) * 30
		$Panel/DamagePro.value = tank.protank_damage
		$Panel/SpeedPro.value = (tank.protank_speed)/10
		$Panel/HealthUlt.value = (1/tank.ult_tankhealth) * 30
		$Panel/SpeedUlt.value = (tank.ult_tankspeed)/10
		$Panel/DamageUlt.value = (tank.ult_tank_damage)
		$Panel/upgrade_tank1.text = tank.tank1_upg_txt
		$Panel/upgrade_protank.text = tank.protank_upg_txt
		$Panel/upgrade_ultank.text = tank.ultank_upg_txt
		
		$Panel2/fire_rate1.value = (1/tank.tur1_rate)*10
		$Panel2/fire_rate_pro.value = (1/tank.turpro_rate)*10
		$Panel2/fire_rate_ult.value = (1/tank.turult_rate) * 10
		$Panel2/turret1_upg.text = "UPGRADE: " + str(tank.tur1_upg_points)
		$Panel2/turretpro_upg.text = "UPGRADE: " + str(tank.turpro_upg_points)
		$Panel2/turretult_upg.text = "UPGRADE: " + str(tank.turult_upg_points)
		if tank.tur1_upgrades >= 2:
			$Panel2/turret1_upg.text = "UPGRADE: MAX"
		if tank.turpro_upgrades >= 2:
			$Panel2/turretpro_upg.text = "UPGRADE: MAX"
		if tank.turult_upgrades >=2:
			$Panel2/turretult_upg.text = "UPGRADE: MAX"
			
func _on_turret1_upg_pressed():
	if tank.tur1_upgrades < 2:
		if tank.kills >= tank.tur1_upg_points:
			tank.tur1_rate -= 0.05
			tank.kills -= tank.tur1_upg_points
			tank.tur1_upgrades += 1
			tank.tur1_upg_points += 50
			_on_barrel1_pressed()
		else:
			not_enough_points()
	

	save_data()
func _on_turretpro_upg_pressed():
	if tank.probarrel_purchased == true:
		if tank.turpro_upgrades < 2:
			if tank.kills >= tank.turpro_upg_points:
				tank.turpro_rate -= 0.05
				tank.kills -= tank.turpro_upg_points
				tank.turpro_upgrades += 1
				tank.turpro_upg_points += 50
				equip_probarrel()
			else:
				not_enough_points()
	else:
		buy_first()
	save_data()
	
func _on_turretult_upg_pressed():
	if tank.ultbarrel_purchased == true:
		if tank.turult_upgrades < 2:
			if tank.kills >= tank.turult_upg_points:
				tank.turult_rate  -= 0.025
				tank.kills -= tank.turult_upg_points
				tank.turult_upg_points += 100
				tank.turult_upgrades += 1
				equip_ultbarrel()
			else:
				not_enough_points()
	else:
		buy_first()

	save_data()

func _on_addkills_pressed():
	tank.kills += 1000
	save_data()

func _on_Reset_data_pressed():
	var dir = Directory.new()
	dir.remove("user://tank")
