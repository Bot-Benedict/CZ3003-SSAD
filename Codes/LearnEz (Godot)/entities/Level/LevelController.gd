extends Node2D

onready var userCurrency = $Currency/userCurrency
var result
var responseCode

func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	
	$Loading.show()
	
	$WorldNumberLbl.clear()
	var worldNumber = int(worldModel.selectWorldIdx) + 1
	$WorldNumberLbl.append_bbcode("[center]World " + str(worldNumber) + "[/center]") 
	$WorldNameLbl.clear()
	$WorldNameLbl.append_bbcode("[center]" + worldModel.getWorldNameByIdx(worldModel.selectWorldIdx) + "[/center]") 
	userCurrency.clear()
	userCurrency.append_bbcode("$" + str(userModel.getUserCurrency()))
	
	for locks in $LevelLocks.get_children():
		locks.hide()
		
	for button in $SelectLvlBtn.get_children():
		button.connect("pressed", self, "handleSelectLevel", [button])
		
	for stars in $Stars.get_children():
		stars.hide()
		
	loadLevelInformation()
	pass 

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		root.switch_scene("res://entities/World/WorldController.tscn")
		
func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/World/WorldController.tscn")

func loadLevelInformation():
	var apiURL = levelModel.getBaseUrl() + '/' + worldModel.getWorldIDbyIdx(worldModel.selectWorldIdx)
	apiController.apiCallGet(apiURL)
	
	yield(apiController,"request_completed")
	levelModel.setLevels(apiController.getResult())
	
	apiURL = 'userunlocklevels/' + userModel.getUserId() + '/' + worldModel.getWorldIDbyIdx(worldModel.selectWorldIdx)
	apiController.apiCallGet(apiURL)
	
	yield(apiController,"request_completed")
	levelModel.setUnlockStatus(apiController.getResult())
	
	setLevelNames()
	setLockStatus()
	loadPowerupsInformation()
	
func loadPowerupsInformation():
	var apiUrl = powerupModel.getBaseUrl() + '/all' 
	apiController.apiCallGet(apiUrl)
		
	yield(apiController, "request_completed")

	result = apiController.getResult()
	responseCode = apiController.getResponseCode()

	powerupModel.setPowerups(result)
	
	for button in $Powerup.get_children():
		button.connect("pressed", self, "handleSelectBuyPowerup", [button])
	
	$UserInventory.loadUserInventory()

func handleSelectBuyPowerup(button):
	powerupModel.setSelectedPowerupIdx(int(button.get_index()))
	powerupModel.setSelectedPowerup()
	$BuyPowerUp.popup()

func setLevelNames():
	for lbl in $LevelNames.get_children():
		lbl.clear();
		lbl.append_bbcode('[center]' + levelModel.getLevelStageByIdx(lbl.get_index()))
	pass
	
func setLockStatus():
	for locks in $LevelLocks.get_children():
		var idx = int(locks.get_index())
		if(levelModel.getLevelUnlockStatusByIdx(idx) == '0'):
			locks.show()
			($SelectLvlBtn.get_child(idx)).set_block_signals(true)
		else:
			locks.hide()
			var lvlScore = int(levelModel.getLevelScoreByIdx(idx))
			($Stars.get_child(idx)).show()
			if(lvlScore == 0):
				($Stars.get_child(idx)).play(userModel.getUserAvatar())
				pass
			elif(lvlScore > 0 && lvlScore < 300):
				($Stars.get_child(idx)).play("1star")
			elif(lvlScore >= 300 && lvlScore < 600):
				($Stars.get_child(idx)).show()
				($Stars.get_child(idx)).play("2star")
			else:
				($Stars.get_child(idx)).play("3star")

func handleSelectLevel(button):
	levelModel.setSelectedLevelIdx(button.get_index())
	$LevelInformation.popup()
	
	