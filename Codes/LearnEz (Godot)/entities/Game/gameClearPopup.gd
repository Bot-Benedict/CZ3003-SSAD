extends Popup


func _ready():
	$gameClearControl.hide()
	connect("about_to_show",self,"playAni")
	$gameClearControl/BackToWorld.connect("pressed",self,"backToWorld")
	pass # Replace with function body.

func playAni():
	SoundManager.play_me("res://assets/sounds/gameClear.ogg",true,true,"res://assets/sounds/gameTheme.ogg")
	updateUserGameClear()
	$gameClearControl.hide()
	$gameClearAni.play("gameClear")


func _on_gameClearAni_animation_finished():
	$gameClearControl.show()
	$gameClearAni.queue_free()
	renderGameClearElements()
	pass 

func renderGameClearElements():
	var score = gameModel.getScore()
	if(score < 300):
		$gameClearControl/stars.play("1star")
	elif(score >= 300 && score < 600):
		$gameClearControl/stars.play("2star")
	else:
		$gameClearControl/stars.play("3star")
		
	$gameClearControl/scoreLbl.clear()
	$gameClearControl/scoreLbl.append_bbcode("[b]Your Score: " + str(score))
	
func backToWorld():
	SoundManager.stop_me("res://assets/sounds/gameClear.ogg")
	SoundManager.play_bgm("themeSong",false)
	root.switch_scene("res://entities/World/WorldController.tscn")
	
func updateUserGameClear():
	var apiUrl = "UserUnlockWorld/game/updateUser/" + userModel.getUserId()
	var data = {
              "score" : gameModel.getScore(),
              "levelID": levelModel.getLevelIDByIdx(levelModel.getSelectedLevelIdx()),
              "worldID": worldModel.getWorldIDbyIdx(worldModel.selectWorldIdx)
	}
	
	apiController.apiCallPut(data,apiUrl)
	yield(apiController,"request_completed")
	pass