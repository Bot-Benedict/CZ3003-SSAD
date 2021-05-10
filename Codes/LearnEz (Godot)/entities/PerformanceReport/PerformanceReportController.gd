extends Node2D

var selectedClass = userModel.getUserGroup()[0]['groupID']
onready var chart_node = get_node('Graph')

func _ready():
	
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	
	loadClassOptions()
	
	$ClassOpt.connect("item_selected",self,"handleSelectClass")
	
	chart_node.initialize(chart_node.LABELS_TO_SHOW.NO_LABEL,
	{
	World1 = Color(1.0, 0.18, 0.18),
	World2 = Color(0.58, 0.92, 0.07),
	World3 = Color(0.5, 0.22, 0.6),
	World4 = Color(0.2, 0.45, 0.18),
	World5 = Color(1.0, 0.32, 0.98),
	World6 = Color(0.54, 0.11, 0.20),
	})
	
	set_process(true)
	loadStudentsInformation()
	$generateReportBtn.connect("pressed",self,"generateReport")
	$refresh_btn.connect("pressed",self,"loadGraph")
	pass
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		root.switch_scene("res://entities/Menu/Teacher_MainMenu_Controller.tscn")

func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/Menu/Teacher_MainMenu_Controller.tscn")
		
func loadClassOptions():
	for group in userModel.getUserGroup():
		$ClassOpt.add_item(group['groupID'])
		$ClassOpt.add_separator()

func handleSelectClass(id):
	selectedClass = $ClassOpt.get_item_text(id)
	loadStudentsInformation()
	
func loadStudentsInformation():
	var btnxPos = 955
	var btnyPos = 220
	
	var lblxPos = 755
	var lblyPos = 225
	
	for button in $StudentList.get_children():
		$StudentList.remove_child(button)
		
	for lbl in $StudentLbls.get_children():
		$StudentLbls.remove_child(lbl)
		
	$loading.popup()	
	
	var apiURL = "group/students/" + selectedClass
	
	apiController.apiCallGet(apiURL)
		
	yield(apiController,"request_completed")	
	
	performanceModel.setStudentsList(apiController.getResult())
	
	for student in performanceModel.getStudentsList():
			
		var button = Button.new()
		button.set_position(Vector2(btnxPos,btnyPos))
		button.text = ">"
		$StudentList.add_child(button)
		btnyPos += 30
		
		var lbl = Label.new()
		lbl.text = student['userID'] + "  " + student['name']
		lbl.set_position(Vector2(lblxPos,lblyPos))
		lbl.add_color_override("font_color", Color(0,0,0,1))
		$StudentLbls.add_child(lbl)
		lblyPos += 30
		
	for button in $StudentList.get_children():
		button.connect("pressed",self,"handleSelectStudent",[button])
		
	loadGraph()
		
func handleSelectStudent(button):
	performanceModel.setSelectedStudentIdx(button.get_index())
	root.switch_scene("res://entities/PerformanceReport/StudentPerformanceReport.tscn")
	
func loadGraph():
	$loading.popup()	
	chart_node.clear_chart()
	
	var apiURL = "group/students/score/" + selectedClass
	
	apiController.apiCallGet(apiURL)
		
	yield(apiController,"request_completed")	
	var lvl1Score = []
	var lvl2Score = []
	var lvl3Score = []
	var lvl4Score = []
	var lvl5Score = []
	
	for item in apiController.getResult():
		if(int(item['levelID'])%5 == 1):
			lvl1Score.append(item['score'])
		elif(int(item['levelID'])%5 == 2):
			lvl2Score.append(item['score'])
		elif(int(item['levelID'])%5 == 3):
			lvl3Score.append(item['score'])
		elif(int(item['levelID'])%5 == 4):
			lvl4Score.append(item['score'])
		elif(int(item['levelID'])%5 == 0):
			lvl5Score.append(item['score'])
	

	chart_node.create_new_point({
	label = 'Level 1',
	values = {
	World1 = int(lvl1Score[0]),
	World2 = int(lvl1Score[1]),
	World3 = int(lvl1Score[2]),
	World4 = int(lvl1Score[3]),
	World5 = int(lvl1Score[4]),
	World6 = int(lvl1Score[5]),
	}
	})
	chart_node.create_new_point({
	label = 'Level 2',
	values = {
	World1 = int(lvl2Score[0]),
	World2 = int(lvl2Score[1]),
	World3 = int(lvl2Score[2]),
	World4 = int(lvl2Score[3]),
	World5 = int(lvl2Score[4]),
	World6 = int(lvl2Score[5]),
	}
	})
	chart_node.create_new_point({
	label = 'Level 3',
	values = {
	World1 = int(lvl3Score[0]),
	World2 = int(lvl3Score[1]),
	World3 = int(lvl3Score[2]),
	World4 = int(lvl3Score[3]),
	World5 = int(lvl3Score[4]),
	World6 = int(lvl3Score[5]),
	}
	})
	chart_node.create_new_point({
	label = 'Level 4',
	values = {
	World1 = int(lvl4Score[0]),
	World2 = int(lvl4Score[1]),
	World3 = int(lvl4Score[2]),
	World4 = int(lvl4Score[3]),
	World5 = int(lvl4Score[4]),
	World6 = int(lvl4Score[5]),
	}
	})
	chart_node.create_new_point({
	label = 'Level 5',
	values = {
	World1 = int(lvl5Score[0]),
	World2 = int(lvl5Score[1]),
	World3 = int(lvl5Score[2]),
	World4 = int(lvl5Score[3]),
	World5 = int(lvl5Score[4]),
	World6 = int(lvl5Score[5]),
	}
	})
	chart_node.set_max_values(5000)
	chart_node.set_labels(7)
	$loading.hide()

func generateReport():
	var url = apiController.baseUrl + "group/students/score/generatereport/" + selectedClass
	OS.shell_open(url)
	pass