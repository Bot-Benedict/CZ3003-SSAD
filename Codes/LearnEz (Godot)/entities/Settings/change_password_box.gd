extends Sprite

var url = userModel.getBaseUrl()
var result
var responseCode

func _ready():
	$password_nomatch_lbl.hide()
	get_parent().get_node("changepassword_btn").connect("pressed",self,"renderchangePasswordBox")
	$close_btn.connect("pressed",self,"closeChangePasswordBox")
	$submit_change_password_btn.connect("pressed",self,"verifyPasswordInput");
	pass 

func renderchangePasswordBox():
	self.show()
	
func closeChangePasswordBox():
	self.hide()

func verifyPasswordInput():
	var pass_val = $new_password.text
	var re_pass_val = $re_new_password.text
	
	if (pass_val != re_pass_val) || (pass_val == '' || re_pass_val == ''):
		$password_nomatch_lbl.show()
	else:
		$password_nomatch_lbl.hide()
		var apiUrl = url + '/' + userModel.getUserId()
		var data = {"password": pass_val}
		apiController.apiCallPut(data,apiUrl)
		
		yield(apiController, "request_completed")
		
		result = apiController.getResult()
		responseCode = apiController.getResponseCode()
		
		self.hide()
		get_parent().get_node("password_updated_box").show()
		