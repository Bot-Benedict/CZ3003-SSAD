extends Node

#Handle Post Discussion Page

var url = "discussion/comments"

func _ready():
	root.set_screen_orientation(0)
	$PostComment_Btn.connect("pressed",self,"post_comment_pressed")
	$Post_Comment_Success_Popup.hide()
	$RichTextLabel2.hide()
	pass 
	
func post_comment_pressed():

	var comment_content = $TextEdit.get_text()
	
	if (comment_content == ""):
		$RichTextLabel2.clear()
		$RichTextLabel2.add_text("Please input comment")
		$RichTextLabel2.show()
	else:
		$loading.popup()
		$RichTextLabel2.clear()
		var user_id = userModel.getUserId()
		var datetime_dictionary = OS.get_datetime()
		var second = datetime_dictionary["second"]
		if (second <= 9):
			second = '0' + str(datetime_dictionary["second"])
		var time_created = str(datetime_dictionary["year"]) + '-' + str(datetime_dictionary["month"]) + '-' + str(datetime_dictionary["day"]) + ' ' + str(datetime_dictionary["hour"]) + ':' + str(datetime_dictionary["minute"]) + ':' + str(second)
		
		var thread_id = root.discussion_selected
		
		var apiUrl = url + '/' + thread_id
		var data = {"content": comment_content, "time": time_created, "postedBy": user_id}
		apiController.apiCallPost(data,apiUrl)
		
		yield(apiController, "request_completed")
		
		var result = apiController.getResult()
		var responseCode = apiController.getResponseCode()
		$loading.hide()
		if (str(responseCode) == "200"):
			$Post_Comment_Success_Popup.show()
		else:
			$RichTextLabel2.add_text("Error posting comment. Please try again!")
			$RichTextLabel2.show()

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.return_to_last()