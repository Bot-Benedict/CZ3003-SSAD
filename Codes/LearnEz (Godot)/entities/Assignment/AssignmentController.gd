extends Node

#Handle Assignment Board Page

var no_assignment_background
var default_background
var apiUrl
var apiUrl_student = "assignment/student/"
var apiUrl_teacher_group = "assignment/teacher/group/"
var apiUrl_teacher_all = "assignment/teacher/"
var result
var responseCode
var selectedClass
var select_class = "false"
var base_index = 0
var max_index
var go_left = "false"
var go_right = "false"

func _ready():
	
	no_assignment_background = preload("res://images/assignment_window.png")
	default_background = preload("res://images/modal_window.png")
	
	$No_Assignment_Popup.hide()
	
	if (userModel.getUserRole() == "Student"):
		$ClassLabel.hide()
		$ClassOption.hide()
		$NewAssignment_Btn.hide()
	else:
		loadClassOptions()
		$ClassOption.connect("item_selected",self,"handleSelectedClass")
	
	$NewAssignment_Btn.connect("pressed",self,"new_assignment_pressed")
	$GoLeft_Btn.connect("pressed",self,"go_left_assignment_pressed")
	$GoRight_Btn.connect("pressed",self,"go_right_assignment_pressed")
	$Refresh_Btn.connect("pressed",self,"refresh_assignment")
	
	$assignment_2/assignment_viewmore_2.connect("meta_clicked",self,"assignment_viewmore")
	
	$assignment
	
	render_assignment()
	
	pass

func render_assignment():
	
	$loading.popup()
	
	$assignment_1.hide()
	$assignment_2.hide()
	$assignment_3.hide()
	$GoLeft_Btn.hide()
	$GoRight_Btn.hide()
	
	$assignment_1/assignment_title_1.clear()
	$assignment_1/assignment_details_1.clear()
	$assignment_1/assignment_postedby_1.clear()
	$assignment_1/assignment_duedate_1.clear()
	
	$assignment_2/assignment_title_2.clear()
	$assignment_2/assignment_details_2.clear()
	$assignment_2/assignment_postedby_2.clear()
	$assignment_2/assignment_duedate_2.clear()
	$assignment_2/assignment_URL_2.clear()
	
	$assignment_3/assignment_title_3.clear()
	$assignment_3/assignment_details_3.clear()
	$assignment_3/assignment_postedby_3.clear()
	$assignment_3/assignment_duedate_3.clear()
	
	if (userModel.getUserRole() == "Student"):
		apiUrl = apiUrl_student + userModel.getUserGroup()
	else:
		if (select_class == "false"):
			apiUrl = apiUrl_teacher_all + userModel.getUserId()
		else:
			apiUrl = apiUrl_teacher_group + selectedClass
			
	apiController.apiCallGet(apiUrl)
	yield(apiController, "request_completed")
	
	result = apiController.getResult()
	responseCode = apiController.getResponseCode()
	
	if (userModel.getUserRole() == "Student"):
		if (result.size() == 0):
			$No_Assignment_Popup.show()
	
	max_index = result.size()
	
	if (max_index != 0):
		
		$assignment_2/assignment_title_2.append_bbcode(result[base_index]["title"])
		$assignment_2/assignment_details_2.append_bbcode(result[base_index]["details"])
		$assignment_2/assignment_postedby_2.append_bbcode("Posted By: ")
		$assignment_2/assignment_postedby_2.append_bbcode(result[base_index]["name"])
		$assignment_2/assignment_duedate_2.append_bbcode("Due On: ")
		$assignment_2/assignment_duedate_2.append_bbcode(result[base_index]["due_date"])
		$assignment_2/assignment_URL_2.append_bbcode(result[base_index]["file_url"])
	
		$assignment_2/assignment_title_placeholder_2.show()
		$assignment_2/assignment_title_2.show()
		$assignment_2/assignment_details_placeholder_2.show()
		$assignment_2/assignment_details_2.show()
		$assignment_2/assignment_postedby_2.show()
		$assignment_2/assignment_duedate_2.show()
		$assignment_2.show()
		
		if (base_index+2 <= max_index):
		
			go_right = "true"
			
			$assignment_3.set_texture(default_background)
			
			$assignment_3/assignment_title_3.append_bbcode(result[base_index+1]["title"])
			$assignment_3/assignment_details_3.append_bbcode(result[base_index+1]["details"])
			$assignment_3/assignment_postedby_3.append_bbcode("Posted By: ")
			$assignment_3/assignment_postedby_3.append_bbcode(result[base_index+1]["name"])
			$assignment_3/assignment_duedate_3.append_bbcode("Due On: ")
			$assignment_3/assignment_duedate_3.append_bbcode(result[base_index+1]["due_date"])
			
			$assignment_3/assignment_title_placeholder_3.show()
			$assignment_3/assignment_title_3.show()
			$assignment_3/assignment_details_placeholder_3.show()
			$assignment_3/assignment_details_3.show()
			$assignment_3/assignment_postedby_3.show()
			$assignment_3/assignment_duedate_3.show()
			$assignment_3.show()
		
		else:
		
			go_right = "false"
			
			$assignment_3.set_texture(no_assignment_background)
			$assignment_3/assignment_title_placeholder_3.hide()
			$assignment_3/assignment_title_3.hide()
			$assignment_3/assignment_details_placeholder_3.hide()
			$assignment_3/assignment_details_3.hide()
			$assignment_3/assignment_postedby_3.hide()
			$assignment_3/assignment_duedate_3.hide()
			$assignment_3.show()
		
		if (base_index <= 0):
			
			go_left = "false"
			
			$assignment_1.set_texture(no_assignment_background)
			$assignment_1/assignment_title_placeholder_1.hide()
			$assignment_1/assignment_title_1.hide()
			$assignment_1/assignment_details_placeholder_1.hide()
			$assignment_1/assignment_details_1.hide()
			$assignment_1/assignment_postedby_1.hide()
			$assignment_1/assignment_duedate_1.hide()
			$assignment_1.show()
		
		else:
		
			go_left = "true"
		
			$assignment_1.set_texture(default_background)
			
			$assignment_1/assignment_title_1.append_bbcode(result[base_index-1]["title"])
			$assignment_1/assignment_details_1.append_bbcode(result[base_index-1]["details"])
			$assignment_1/assignment_postedby_1.append_bbcode("Posted By: ")
			$assignment_1/assignment_postedby_1.append_bbcode(result[base_index-1]["name"])
			$assignment_1/assignment_duedate_1.append_bbcode("Due On: ")
			$assignment_1/assignment_duedate_1.append_bbcode(result[base_index-1]["due_date"])
			
			$assignment_1/assignment_title_placeholder_1.show()
			$assignment_1/assignment_title_1.show()
			$assignment_1/assignment_details_placeholder_1.show()
			$assignment_1/assignment_details_1.show()
			$assignment_1/assignment_postedby_1.show()
			$assignment_1/assignment_duedate_1.show()
			$assignment_1.show()
		
	else:
		
		$assignment_1.hide()
		$assignment_2.hide()
		$assignment_3.hide()
	
	if (go_left == "true"):
		$GoLeft_Btn.show()
	else:
		$GoLeft_Btn.hide()
		
	if (go_right == "true"):
		$GoRight_Btn.show()
	else:
		$GoRight_Btn.hide()

	$loading.hide()

func loadClassOptions():
	
	$ClassOption.add_item("All Group")
	$ClassOption.add_separator()
	
	for group in userModel.getUserGroup():
		$ClassOption.add_item(group['groupID'])
		$ClassOption.add_separator()

func handleSelectedClass(id):
	
	selectedClass = $ClassOption.get_item_text(id)
	
	if (selectedClass == "All Group"):
		select_class = "false"
	else:
		select_class = "true"
		
	render_assignment()

func new_assignment_pressed():
	root.switch_scene("res://entities/Assignment/PostAssignment.tscn")
	
func go_left_assignment_pressed():
	base_index = base_index - 1
	render_assignment()
	
func go_right_assignment_pressed():
	base_index = base_index + 1
	render_assignment()

func assignment_viewmore(meta):
	OS.shell_open($assignment_2/assignment_URL_2.get_text())

func refresh_assignment():
	render_assignment()

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		if (userModel.getUserRole() == "Student"):
			root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
		else:
			root.switch_scene("res://entities/Menu/Teacher_MainMenu_Controller.tscn")
			
func _input(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		if (userModel.getUserRole() == "Student"):
			root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
		else:
			root.switch_scene("res://entities/Menu/Teacher_MainMenu_Controller.tscn")