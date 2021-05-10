extends Node2D

onready var chart_node = get_node('Graph')

func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
		
	chart_node.initialize(chart_node.LABELS_TO_SHOW.NO_LABEL,
	{
		World = Color(1.0, 0.18, 0.18),
	})
	
	loadStudentOptions()
	loadWorldOptions()
	$StudentOpt.select(int(performanceModel.selectedStudentIdx) * 2)
	$StudentOpt.connect("item_selected",self,"handleSelectStudent")
	$WorldOpt.select(0)
	$WorldOpt.connect("item_selected",self,"handleSelectWorld")
	$generateReportBtn.connect("pressed",self,"generateStudentReport")	
	$refresh_btn.connect('pressed',self,"loadGraph")
	$WorldLbl.hide()
	pass

func loadStudentOptions():
	for student in performanceModel.getStudentsList():
		$StudentOpt.add_item(student['name']+ ' ' + student['userID'])
		$StudentOpt.add_separator()

func loadWorldOptions():
	
	$loading.popup()
	
	var apiUrl = worldModel.getBaseUrl() + '/all' 
	apiController.apiCallGet(apiUrl)
		
	yield(apiController, "request_completed")

	performanceModel.setWorlds(apiController.getResult())
		
	for world in performanceModel.getWorlds():
		$WorldOpt.add_item(world['worldName'])
		$WorldOpt.add_separator()
		
	loadGraph()
		
func handleSelectStudent(id):
	performanceModel.setSelectedStudentIdx(int(id)/2)
	loadGraph()
		
func handleSelectWorld(id):
	performanceModel.setSelectedWorldIdx(int(id)/2)
	loadGraph()

func loadGraph():
	$loading.popup()
	
	chart_node.clear_chart()
		
	var studentMatric = performanceModel.getStudentMatricByIdx(performanceModel.getSelectedStudentIdx())
	var worldID = performanceModel.getSelectedWorldIdByIdx(performanceModel.getSelectedWorldIdx())
	
	var apiURL = "group/students/" + studentMatric + "/" + worldID
		
	apiController.apiCallGet(apiURL)
		
	yield(apiController,"request_completed")	
	
	for item in apiController.getResult():
		chart_node.create_new_point({
		label = item['levelStage'],
		values = {
		World = int(item['score']),
		}
		})
	chart_node.set_labels(7)
	$WorldNameLbl.text = ": " + performanceModel.getWorldNameByIdx(performanceModel.selectedWorldIdx)
	$WorldNameLbl.show()
	$loading.hide()

func generateStudentReport():
	var url = apiController.baseUrl + "group/students/indv/score/generatereport/" + performanceModel.getStudentMatricByIdx(performanceModel.getSelectedStudentIdx())
	OS.shell_open(url)
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		root.return_to_last()
		
func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/PerformanceReport/PerformanceReportController.tscn")