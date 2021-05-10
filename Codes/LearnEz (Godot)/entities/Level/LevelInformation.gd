extends Popup

func _ready():
	connect("about_to_show",self,"loadLevelInformation")
	$close.connect("pressed",self,"closeLevelInfo")
	$playBtn.connect("pressed",self,"playGame")
	pass # Replace with function body.
	
func loadLevelInformation():

	var lvlIdx = int(levelModel.selectedLevelIdx)
	$levelname.clear()
	$levelname.append_bbcode("[u]" + levelModel.getLevelStageByIdx(lvlIdx) + ": " + levelModel.getLevelNameByIdx(lvlIdx))
	$levelDescription.clear()
	$levelDescription.append_bbcode(levelModel.getLevelDescription(lvlIdx))
	$userScore.clear()
	$userScore.append_bbcode("Your Score: " + levelModel.getLevelScoreByIdx(lvlIdx))
	$leaderboardInfo.clear()
	loadLeaderboardInformation()

func playGame():
	root.switch_scene("res://entities/Game/Game.tscn")
	self.hide()
	
func closeLevelInfo():
	self.hide()

func loadLeaderboardInformation():
	var apiUrl = levelModel.getBaseUrl() + '/leaderboard/' + levelModel.getLevelIDByIdx(levelModel.selectedLevelIdx)
	apiController.apiCallGet(apiUrl)
	
	yield(apiController, "request_completed")
	var result = apiController.getResult()

	var idx = 1
	for item in result:
		$leaderboardInfo.append_bbcode(str(idx) + ": " + item["name"] + "   " + item["score"] + "\n")
		idx += 1
	pass