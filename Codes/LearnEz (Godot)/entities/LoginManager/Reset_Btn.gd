extends TouchScreenButton

var url = userModel.getBaseUrl()
var result
var responseCode
var resetByIDLbl
var resetPasswordErr

#Handles Reset Password
func _ready():
	self.connect("pressed",self, "resetPassword")
	pass

func resetPassword():
	
	resetByIDLbl = get_parent().get_parent().get_node("Reset_by_ID")
	resetPasswordErr = get_parent().get_node("reset_password_empty_lbl")
	
	#Check if UserInput is Empty
	if resetByIDLbl.text == "":
		resetPasswordErr.clear()
		resetPasswordErr.append_bbcode("Please enter matric number of staff id!")
		resetPasswordErr.show()
	#If Not Empty
	else:
		resetPasswordErr.hide()
		#Make Call to Web API to generate reset password link. Send the link to User's email
		var apiUrl = url + '/resetpassword/link/' + resetByIDLbl.text
		
		apiController.apiCallGet(apiUrl)
		
		yield(apiController, "request_completed")

		result = apiController.getResult()
		responseCode = apiController.getResponseCode()
		
		#If Success
		if(responseCode == 200):
			for item in get_parent().get_children():
				item.hide()
			get_parent().hide()
			resetByIDLbl.hide()
			get_parent().get_parent().get_node("forget_pass_success_popup").show()
		#If Fail
		else:
			resetPasswordErr.clear()
			resetPasswordErr.append_bbcode("No User Found!")
			resetPasswordErr.show()