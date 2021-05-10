extends Node

#Handle Detailed Discussion Page

var apiUrl_discussion = "discussion/"
var apiUrl_discussion_numOfComments = "discussion/numOfComments/"
var apiUrl_discussion_comments = "discussion/comments/"
var apiUrl_discussion_comments_call
var result_discussion
var result_discussion_numOfComments
var result_discussion_comments
var responseCode_discussion
var responseCode_discussion_numOfComments
var responseCode_discussion_comments
var posted_total_time
var total_time
var time_since_posted
var number_of_comments
var base_index = 0
var max_index
var comment_index
var scroll_down = "true"
var no_comments = "false"
var number_to_minus

func _ready():
	root.set_screen_orientation(0)
	
	$detailed_discussion.hide()
	
	render_detailed_discussion()
	
	$detailed_discussion/ScrollUp_Btn.connect("pressed",self,"scroll_up_comments_pressed")
	$detailed_discussion/ScrollDown_Btn.connect("pressed",self,"scroll_down_comments_pressed")
	$detailed_discussion/NewComment_Btn.connect("pressed",self,"new_comment_pressed")
	$refreshBtn.connect("pressed",self,"refresh_comments")
	pass 

func render_detailed_discussion():
	$loading.show()
	
	$detailed_discussion/detailed_discussion_title.clear()
	$detailed_discussion/detailed_discussion_postedby.clear()
	$detailed_discussion/detailed_discussion_details.clear()

	var apiUrl_discussion_call = apiUrl_discussion + root.discussion_selected
	
	apiController.apiCallGet(apiUrl_discussion_call)
	yield(apiController, "request_completed")
	
	result_discussion = apiController.getResult()
	responseCode_discussion = apiController.getResponseCode()
	
	$detailed_discussion/detailed_discussion_title.append_bbcode(result_discussion[0]["title"])
	$detailed_discussion/detailed_discussion_postedby.append_bbcode("By: ")
	$detailed_discussion/detailed_discussion_postedby.append_bbcode(result_discussion[0]["name"])
	$detailed_discussion/detailed_discussion_details.append_bbcode(result_discussion[0]["details"])

	var apiUrl_discussion_numOfComments_call = apiUrl_discussion_numOfComments + root.discussion_selected
	
	apiController.apiCallGet(apiUrl_discussion_numOfComments_call)
	yield(apiController, "request_completed")
	
	result_discussion_numOfComments = apiController.getResult()
	responseCode_discussion_numOfComments = apiController.getResponseCode()
	
	$detailed_discussion/detailed_discussion_postedby.append_bbcode("   |    ")
	$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(result_discussion_numOfComments))
	$detailed_discussion/detailed_discussion_postedby.append_bbcode(" Comments")

	number_of_comments = int(result_discussion_numOfComments)

	$detailed_discussion/detailed_discussion_postedby.append_bbcode("   |    ")
	
	var datetime = result_discussion[0]["time_created"]
	
	var posted_year = datetime[0] + datetime[1] + datetime[2] + datetime[3]
	var posted_month = datetime[5] + datetime[6]
	var posted_day = datetime[8] + datetime[9]
	var posted_hour = datetime[11] + datetime[12]
	var posted_minute = datetime[14] + datetime[15]
	var posted_second = datetime[17] + datetime[18]
	
	var datetime_dictionary = OS.get_datetime()
	var year = datetime_dictionary["year"]
	var month = datetime_dictionary["month"]
	var day = datetime_dictionary["day"]
	var hour = datetime_dictionary["hour"]
	var minute = datetime_dictionary["minute"]
	var second = datetime_dictionary["second"]

	if (int(posted_year) == int(year)):
		if (int(posted_month) == int(month)):
			if (int(posted_day) == int(day)):
				if (int(posted_hour) == int(hour)):
					if (int(posted_minute) == int(minute)):
						time_since_posted = floor(int(second) - int(posted_second))
						$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
						$detailed_discussion/detailed_discussion_postedby.append_bbcode(" seconds ago")
					else:
						time_since_posted = floor(int(minute) - int(posted_minute))
						$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
						$detailed_discussion/detailed_discussion_postedby.append_bbcode(" minutes ago")
				else:
					time_since_posted = floor(int(hour) - int(posted_hour))
					$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
					$detailed_discussion/detailed_discussion_postedby.append_bbcode(" hours ago")
			else:
				time_since_posted = floor(int(day) - int(posted_day))
				$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
				$detailed_discussion/detailed_discussion_postedby.append_bbcode(" days ago")
		else:
			time_since_posted = floor(((int(month) * 30.4167) + int(day))- ((int(posted_month) * 30.4167) + int(posted_day)))
			$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
			$detailed_discussion/detailed_discussion_postedby.append_bbcode(" days ago")
	else:
		time_since_posted = floor(((int(year) * 12) + month) - ((int(posted_year) * 12) + posted_month))
		$detailed_discussion/detailed_discussion_postedby.append_bbcode(str(time_since_posted))
		$detailed_discussion/detailed_discussion_postedby.append_bbcode(" months ago")
	
	apiUrl_discussion_comments_call = apiUrl_discussion_comments + root.discussion_selected
	
	render_comments()
	
	$detailed_discussion.show()

func render_comments():
	$loading.show()
	$detailed_discussion/comment_index_1.clear()
	$detailed_discussion/comment_content_1.clear()
	$detailed_discussion/comment_postedby_1.clear()
	
	$detailed_discussion/comment_index_2.clear()
	$detailed_discussion/comment_content_2.clear()
	$detailed_discussion/comment_postedby_2.clear()
	
	apiController.apiCallGet(apiUrl_discussion_comments_call)
	yield(apiController, "request_completed")
	
	result_discussion_comments = apiController.getResult()
	
	responseCode_discussion_comments = apiController.getResponseCode()
	
	#max_index = result_discussion_comments.size()
	max_index = int(number_of_comments)
	number_to_minus = 2
	
	if (max_index == 0):
		no_comments = "true"
	
	for i in range(1, 3):
		if (i == 1):
			
			if (base_index == max_index):
				
				scroll_down = "false"
				$detailed_discussion/comment_index_1.hide()
				$detailed_discussion/comment_content_1.hide()
				$detailed_discussion/comment_postedby_1.hide()
			
			else:
				
				comment_index = base_index + 1
				
				$detailed_discussion/comment_index_1.append_bbcode(str(comment_index))
				$detailed_discussion/comment_index_1.append_bbcode(".")
				$detailed_discussion/comment_content_1.append_bbcode(result_discussion_comments[base_index]["content"])
				$detailed_discussion/comment_postedby_1.append_bbcode(result_discussion_comments[base_index]["name"])
				
				base_index = base_index + 1
				number_to_minus = number_to_minus + 1
				
				$detailed_discussion/comment_index_1.show()
				$detailed_discussion/comment_content_1.show()
				$detailed_discussion/comment_postedby_1.show()
				
		if (i == 2):
			
			if (base_index == max_index):
			
				scroll_down = "false"
				$detailed_discussion/comment_index_2.hide()
				$detailed_discussion/comment_content_2.hide()
				$detailed_discussion/comment_postedby_2.hide()
			
			else:
				
				comment_index = base_index + 1
				
				$detailed_discussion/comment_index_2.append_bbcode(str(comment_index))
				$detailed_discussion/comment_index_2.append_bbcode(".")
				$detailed_discussion/comment_content_2.append_bbcode(result_discussion_comments[base_index]["content"])
				$detailed_discussion/comment_postedby_2.append_bbcode(result_discussion_comments[base_index]["name"])
				
				base_index = base_index + 1
				number_to_minus = number_to_minus + 1
				scroll_down = "true"
				
				$detailed_discussion/comment_index_2.show()
				$detailed_discussion/comment_content_2.show()
				$detailed_discussion/comment_postedby_2.show()
				
	if (no_comments == "true"):
		$detailed_discussion/no_comment_label.show()
	else:
		$detailed_discussion/no_comment_label.hide()
	
	if (base_index == max_index):
		scroll_down = "false"
	
	if (base_index <= 2):
		$detailed_discussion/ScrollUp_Btn.hide()
	else:
		$detailed_discussion/ScrollUp_Btn.show()
	
	if (scroll_down == "true"):
		$detailed_discussion/ScrollDown_Btn.show()
	else:
		$detailed_discussion/ScrollDown_Btn.hide()
		
	$loading.hide()

func scroll_up_comments_pressed():
	base_index = base_index - number_to_minus
	render_comments()
	pass

func scroll_down_comments_pressed():
	render_comments()
	pass

func refresh_comments():
	base_index = base_index - number_to_minus + 2
	render_detailed_discussion()
	pass

func new_comment_pressed():
	root.switch_scene("res://entities/Discussion/PostComment.tscn")

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.switch_scene("res://entities/Discussion/DiscussionBoardController.tscn")

func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/Discussion/DiscussionBoardController.tscn")