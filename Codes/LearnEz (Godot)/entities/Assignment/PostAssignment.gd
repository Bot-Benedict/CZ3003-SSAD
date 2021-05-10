extends Node

#Handle Post Assignment Page

var url = "assignment/teacher"
var apiUrl_file = "assignment/teacher/file/all"
var result
var result_fileURL
var responseCode
var responseCode_URL
var selectedClass
var selectedFile

var title_valid = "false"
var details_valid = "false"
var class_valid = "false"
var file_valid = "false"
var year_valid = "false"
var month_valid = "false"
var day_valid = "false"
var minute_valid = "false"
var hour_valid = "false"

func _ready():
	
	root.set_screen_orientation(0)
	
	$loading.popup()
	
	loadClassOptions()
	loadFileOptions()
	
	$ClassOption.connect("item_selected",self,"handleSelectedClass")
	$FileOption.connect("item_selected",self,"handleSelectedFile")
	$PostAssignment_Btn.connect("pressed",self,"post_assignment_pressed")
	
	$Post_Assignment_Success_Popup.hide()
	
	pass 
	
func post_assignment_pressed():
	
	var title_field = $title_field.get_text()
	var details_field = $details_field.get_text()
	var day_field = $day_field.get_text()
	var month_field = $month_field.get_text()
	var year_field = $year_field.get_text()
	var hour_field = $hour_field.get_text()
	var minute_field = $minute_field.get_text()
	
	if (minute_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input due date (minute)")
		minute_valid = "false"
		
	elif (minute_field != "" && minute_field.is_valid_integer() == false):
		
		$error_field.clear()
		$error_field.add_text("Please input valid due date (minute)")
		minute_valid = "false"
		
	elif (minute_field != "" && minute_field.is_valid_integer() == true):
		
		if (int(minute_field) < 0 || int(minute_field) > 59):
			
			$error_field.clear()
			$error_field.add_text("Please input valid due date (minute)")
			minute_valid = "false"
				
		else:
			
			minute_valid = "true"
	
	if (hour_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input due date (hour)")
		hour_valid = "false"
		
	elif (hour_field != "" && hour_field.is_valid_integer() == false):
		
		$error_field.clear()
		$error_field.add_text("Please input valid due date (hour)")
		hour_valid = "false"
		
	elif (hour_field != "" && hour_field.is_valid_integer() == true):
		
		if (int(hour_field) < 0 || int(hour_field) > 23):
			
			$error_field.clear()
			$error_field.add_text("Please input valid due date (hour)")
			hour_valid = "false"
				
		else:
			
			hour_valid = "true"
	
	if (year_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input due date (year)")
		year_valid = "false"
		
	elif (year_field != "" && year_field.is_valid_integer() == false):
		
		$error_field.clear()
		$error_field.add_text("Please input valid due date (year)")
		year_valid = "false"
		
	elif (year_field != "" && year_field.is_valid_integer() == true):
		
		if (int(year_field) < OS.get_datetime()["year"]):
			
			$error_field.clear()
			$error_field.add_text("Please input valid due date (year)")
			year_valid = "false"
				
		else:
			
			year_valid = "true"
	
	if (month_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input due date (month)")
		month_valid = "false"
		
	elif (month_field != "" && month_field.is_valid_integer() == false):
		
		$error_field.clear()
		$error_field.add_text("Please input valid due date (month)")
		month_valid = "false"
		
	elif (month_field != "" && month_field.is_valid_integer() == true):
		
		if (int(month_field) < 1 || int(month_field) > 12):
			
			$error_field.clear()
			$error_field.add_text("Please input valid due date (month)")
			month_valid = "false"
				
		else:
			
			month_valid = "true"
	
	if (day_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input due date (day)")
		day_valid = "false"
		
	elif (day_field != "" && day_field.is_valid_integer() == false):
		
		$error_field.clear()
		$error_field.add_text("Please input valid due date (day)")
		day_valid = "false"
		
	elif (day_field != "" && day_field.is_valid_integer() == true):
		
		if (int(day_field) < 1 || int(day_field) > 31):
			
			$error_field.clear()
			$error_field.add_text("Please input valid due date (day)")
			day_valid = "false"
				
		else:
			
			day_valid = "true"
	
	if (details_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input assignment details")
		details_valid = "false"
		
	else:
		
		details_valid = "true"
		
	if (selectedFile == null || selectedFile == "Select File"):
		
		$error_field.clear()
		$error_field.add_text("Please select a file")
		file_valid = "false"
		
	else:
		
		file_valid = "true"
		
	if (selectedClass == null || selectedClass == "Select Group"):
		
		$error_field.clear()
		$error_field.add_text("Please select a group")
		class_valid = "false"
		
	else:
		
		class_valid = "true"
	
	if (title_field == ""):
		
		$error_field.clear()
		$error_field.add_text("Please input assignment title")
		title_valid = "false"
		
	else:
		
		title_valid = "true"
		
	if (title_valid == "true" && details_valid == "true" && class_valid == "true" && file_valid == "true" && year_valid == "true" && month_valid == "true" && day_valid == "true" && hour_valid == "true" && minute_valid == "true"):
		
		$loading.popup()
		
		$error_field.clear()
		
		var user_id = userModel.getUserId()
		
		if (int(month_field) <= 9):
			month_field = "0" + month_field
		
		if (int(day_field) <= 9):
			day_field = "0" + day_field
			
		if (int(hour_field) <= 9):
			hour_field = "0" + hour_field
			
		if (int(minute_field) <= 9):
			minute_field = "0" + minute_field
		
		var due_date = str(year_field) + '-' + str(month_field) + '-' + str(day_field) + ' ' + str(hour_field) + ':' + str(minute_field) + ':59'
		
		var data = {"title": title_field, "details": details_field, "due_date": due_date, "group_id": selectedClass, "file_id": selectedFile}
		
		print(data)
		
		var apiUrl = url + '/' + user_id
		
		apiController.apiCallPost(data,apiUrl)
		
		yield(apiController, "request_completed")
		
		result = apiController.getResult()
		responseCode = apiController.getResponseCode()
		
		$loading.hide()
		
		if (str(responseCode) == "200"):
			$Post_Assignment_Success_Popup.show()
		else:
			$error_field.add_text("Error posting assignment. Please try again!")
			$error_field.show()
	
func loadClassOptions():
	
	$ClassOption.add_item("Select Group")
	$ClassOption.add_separator()
	
	for group in userModel.getUserGroup():
		$ClassOption.add_item(group['groupID'])
		$ClassOption.add_separator()

func loadFileOptions():
	
	apiController.apiCallGet(apiUrl_file)
	yield(apiController, "request_completed")
	
	result = apiController.getResult()
	responseCode = apiController.getResponseCode()
	
	$FileOption.add_item("Select File")
	$FileOption.add_separator()
	
	for file_id in result:
		$FileOption.add_item(file_id["file_name"])
		$FileOption.add_separator()
	
	$loading.hide()

func handleSelectedClass(id):
	
	selectedClass = $ClassOption.get_item_text(id)

func handleSelectedFile(id):
	
	selectedFile = $FileOption.get_item_text(id)
	

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.return_to_last()

func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/Assignment/AssignmentController.tscn")