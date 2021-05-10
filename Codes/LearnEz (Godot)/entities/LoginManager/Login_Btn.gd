extends TouchScreenButton

#Handles Login
var url = userModel.getBaseUrl()
var result
var responseCode
var usernameLabel
var passwordLabel 
var loading_bg
var loading_sprite

func _ready():
	usernameLabel = get_parent().get_node("username_empty_label")
	passwordLabel = get_parent().get_node("password_empty_label")
	loading_bg = get_parent().get_node("Loading_bg")
	loading_sprite = get_parent().get_node("Loading_sprite")
	connect("pressed",self,"verifyUser")

#Verify User Input
#If verified, get User Data from Database
func verifyUser():

	var login_val = get_parent().get_node("Login_Input").text
	var pass_val = get_parent().get_node("Password_Input").text

	if(login_val == ""):
		usernameLabel.show()
	else:
		usernameLabel.hide()

	if (pass_val == ""):
		passwordLabel.show()
	else:
		passwordLabel.hide()

	if(login_val != "" && pass_val != ""):
		
		loading_bg.show()
		loading_sprite.show()
		
		usernameLabel.hide()
		passwordLabel.hide()

		var apiUrl = url + '/' + login_val + '/' + pass_val
		apiController.apiCallGet(apiUrl)
		
		yield(apiController, "request_completed")

		result = apiController.getResult()
		responseCode = apiController.getResponseCode()
		
		if(responseCode == 200):
			getUserInfo()
		else:			
			loading_bg.hide()
			loading_sprite.hide()
			get_parent().get_node("NoAccount_Popup").show()


#Update the User Model
func getUserInfo():


	
	userModel.setUserID(result['userID'])
	userModel.setUserEmail(result['email'])
	userModel.setUserPassword(result['password'])
	userModel.setUserRole(result['role'])
	userModel.setUserAvatar(result['avatarURL'])
	userModel.setUserAvatarID(result['avatarID'])
	userModel.setUserName(result['name'])

	if(userModel.getUserRole() == "Student"):
		userModel.setUserGroup(result['userGroup'])
		userModel.setUserCurrency(int(result['currency']))
		loading_bg.hide()
		loading_sprite.hide()
		root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
	else:
		var apiUrl = "group/" + userModel.getUserId()
		apiController.apiCallGet(apiUrl)
		yield(apiController, "request_completed")
		userModel.setUserGroup(apiController.getResult())
		loading_bg.hide()
		loading_sprite.hide()
		root.switch_scene("res://entities/Menu/Teacher_MainMenu_Controller.tscn")
	pass