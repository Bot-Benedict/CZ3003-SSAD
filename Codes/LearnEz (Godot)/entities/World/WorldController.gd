extends Node2D

var url = worldModel.getBaseUrl()
var result
var responseCode

func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	$loading.popup()
	
	loadWorlds()
	for button in $WorldBackground.get_children():
		button.connect("pressed", self, "handleSelectWorld", [button])
	for locks in $WorldUnlockedStatus.get_children():
		locks.hide()
	for button in $WorldPlay.get_children():
		button.set_block_signals(true)
		button.hide()
	for item in $Stars.get_children():
		item.hide()
	pass 

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")

func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
		
func loadWorlds():
		var apiUrl = url + '/all' 
		apiController.apiCallGet(apiUrl)
		
		yield(apiController, "request_completed")

		result = apiController.getResult()
		responseCode = apiController.getResponseCode()
		worldModel.setWorlds(result)
		
		setWorldNames()
		
		apiController.apiCallGet("UserUnlockWorld/" + userModel.getUserId())
		yield(apiController, "request_completed")
		worldModel.setUnlockStatus(apiController.getResult())
		setUnlocked()
		
func setWorldNames():
	for titleText in $WorldTitlesText.get_children():
		titleText.clear()
		var titleString = "[center]" + worldModel.getWorldNameByIdx(titleText.get_index()) + "[/center]"
		titleText.append_bbcode(titleString)
		titleText.show()
		
func handleSelectWorld(button):
	worldModel.setSelectedWorld(button.name)
	worldModel.setSelectedWorldIdx(button.get_index())
	root.switch_scene("res://entities/Level/LevelController.tscn")

func setUnlocked():
	for locks in $WorldUnlockedStatus.get_children():
		var idx = int(locks.get_index())
		var unlockStatus = worldModel.getWorldUnlockStatus(idx)
		var worldScore = int(worldModel.getWorldScoreByIdx(idx))
		if(unlockStatus == '0'):
			locks.show()
			($WorldBackground.get_child(idx)).set_block_signals(true)
		else:
			if(worldScore == 0):
				$WorldPlay.get_child(idx).show()
				$WorldPlay.get_child(idx).set_block_signals(false)
				pass
			else:
				($Stars.get_child(idx)).show()
				if(worldScore > 5 && worldScore < 1495):
					($Stars.get_child(idx)).play("1star")
				elif(worldScore >= 1495 && worldScore < 2995):
					($Stars.get_child(idx)).play("2star")
				else:
					($Stars.get_child(idx)).play("3star")
				locks.queue_free()
			
	$loading.hide()
			