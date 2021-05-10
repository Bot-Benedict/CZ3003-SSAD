extends Node2D

var ldbType = "class"
var world = "world1"

func _ready():
	
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	
	for lbl in $WorldLabels.get_children():
		lbl.clear()
	for button in $WorldBtns.get_children():
		button.connect("pressed", self, "handleSelectWorldLdrboard", [button])
	for button in $leaderboardType.get_children():
		button.connect("pressed",self,"handleChangeLeaderboard",[button])
		
	var apiURL = worldModel.getBaseUrl() + "/all"
	apiController.apiCallGet(apiURL)
		
	yield(apiController,"request_completed")	
		
	var result = apiController.getResult()
	
	for lbl in $WorldLabels.get_children():
		var idx = int(lbl.get_index())
		lbl.append_bbcode(result[idx]['worldID'] + " - " + result[idx]['worldName'])
		
	loadLeaderboardInformation(ldbType,world)
	$refresh_btn.connect("pressed",self,"reloadLeaderboard")
	pass 

func reloadLeaderboard():
	loadLeaderboardInformation(ldbType,world)
	
func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.return_to_last()

func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		 root.return_to_last()
		
func handleSelectWorldLdrboard(button):
	world = str(button.name)
	loadLeaderboardInformation(ldbType,str(button.name))

func handleChangeLeaderboard(button):
	if(str(button.name) == 'class'):
		ldbType = 'class'
		loadLeaderboardInformation(ldbType,world)
	else:
		ldbType = 'global'
		loadLeaderboardInformation(ldbType,world)
		
func loadLeaderboardInformation(ldbType,world):
	changePathLbl()
	$leaderboardData.clear()
	$userRank.clear()
	var data = {"type": ldbType,"group": userModel.getUserGroup(),"userID": userModel.getUserId()}
	var apiURL = 'UserUnlockWorld/' + world
	apiController.apiCallPut(data,apiURL)
	
	yield(apiController,"request_completed")
	
	var rank = 1
	
	var result = apiController.getResult()
	
	
	for i in range(result.size()):
		if(i < (result.size()) - 1):
			$leaderboardData.append_bbcode(str(rank) + "           " + result[i]['name'] + "        " + result[i]['score'] + "\n")
		rank += 1
		
	var userRankIdx = result.size()-1
	
	$userRank.append_bbcode(str(result[userRankIdx]['rank']) + "           " + userModel.getUserName() + "        " + result[userRankIdx]['score'] + "\n")

func changePathLbl():
	$currentpath.clear()
	$currentpath.append_bbcode("[u]" + ldbType.to_upper() + ": " + world.to_upper())
