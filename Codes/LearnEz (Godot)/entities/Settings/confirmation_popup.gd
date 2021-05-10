extends Popup

var apiUrl = userModel.getBaseUrl() + '/updateAvatar/' + userModel.getUserId()
var result
var responseCode

func _ready():
	$accept_btn.connect('pressed',self,'handleChangeAvatar')
	$close_btn.connect('pressed',self,'closeConfirmationDialog')
	pass 

func closeConfirmationDialog():
	self.hide()
	
func handleChangeAvatar():
	var avatarID = (get_parent().currentSelection)[6]
	var data = {"avatarID": avatarID}
	
	apiController.apiCallPut(data,apiUrl)
		
	yield(apiController, "request_completed")
		
	result = apiController.getResult()
	responseCode = apiController.getResponseCode()
	
	userModel.setUserAvatarID(avatarID)
	userModel.setUserAvatar(get_parent().currentSelection)
	print(responseCode)
	
	self.hide()
	root.switch_scene("res://entities/Settings/SettingsController.tscn")
