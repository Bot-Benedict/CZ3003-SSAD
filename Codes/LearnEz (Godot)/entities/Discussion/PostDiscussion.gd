extends Node

#Handle Post Discussion Page

var url = "discussion"

func _ready():
	root.set_screen_orientation(0)
	$PostDiscussion_Btn.connect("pressed",self,"post_discussion_pressed")
	$Post_Discussion_Success_Popup.hide()
	$RichTextLabel3.hide()
	pass 
	
func post_discussion_pressed():
	var discussion_title = $TextEdit.get_text()
	var discussion_details = $TextEdit2.get_text()
	
	if (discussion_title == "" && discussion_details == ""):
		$RichTextLabel3.clear()
		$RichTextLabel3.add_text("Please input discussion title and details")
		$RichTextLabel3.show()
	elif (discussion_title == ""):
		$RichTextLabel3.clear()
		$RichTextLabel3.add_text("Please input discussion title")
		$RichTextLabel3.show()
	elif (discussion_details == ""):
		$RichTextLabel3.clear()
		$RichTextLabel3.add_text("Please input discussion details")
		$RichTextLabel3.show()
	else:
		$loading.popup()
		$RichTextLabel3.clear()
		var user_id = userModel.getUserId()
		var datetime_dictionary = OS.get_datetime()
		var second = datetime_dictionary["second"]
		if (second <= 9):
			second = '0' + str(datetime_dictionary["second"])
		var time_created = str(datetime_dictionary["year"]) + '-' + str(datetime_dictionary["month"]) + '-' + str(datetime_dictionary["day"]) + ' ' + str(datetime_dictionary["hour"]) + ':' + str(datetime_dictionary["minute"]) + ':' + str(second)
		
		var apiUrl = url + '/' + user_id
		var data = {"title": discussion_title, "details": discussion_details, "time": time_created}
		apiController.apiCallPost(data,apiUrl)
		
		apiController.apiCallPost(data,apiUrl)
		
		yield(apiController, "request_completed")
		
		var result = apiController.getResult()
		var responseCode = apiController.getResponseCode()
		
		$loading.hide()
		if (str(responseCode) == "200"):
			$Post_Discussion_Success_Popup.show()
		else:
			$RichTextLabel3.add_text("Error posting discussion. Please try again!")
			$RichTextLabel3.show()

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.return_to_last()
		
func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		if(userModel.getUserRole() == 'Student'):
			root.return_to_last()