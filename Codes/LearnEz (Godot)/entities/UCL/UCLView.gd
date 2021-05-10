extends Node


#Handle User Created Level Page

var apiUrl_UCL = "ucl/all/all"
var result_UCL
var responseCode_UCL
var base_index = 0
var max_index
var nextPage = "true"
var number_to_minus = 0
var pageNumber = 1
var returnResult = []
var input_array = []
var chosen_index

func _ready():
	root.set_screen_orientation(0)
	render_ucl()
	
	$newLevel.connect("pressed", self, "newLevel_pressed")
	$nextPage.connect("pressed", self, "nextPage_pressed")
	$previousPage.connect("pressed", self, "previousPage_pressed")
	$UCLs/ucl1.connect("pressed",self,"ucl1_pressed")
	$UCLs/ucl2.connect("pressed",self,"ucl2_pressed")
	$UCLs/ucl3.connect("pressed",self,"ucl3_pressed")
	$UCLs/ucl4.connect("pressed",self,"ucl4_pressed")
	$UCLs/ucl5.connect("pressed",self,"ucl5_pressed")
	$UCLs/ucl6.connect("pressed",self,"ucl6_pressed")
	
	for button in $UCLs.get_children():
		button.connect("pressed", self, "handleSelectedUCL", [button])
	pass 

func newLevel_pressed():
	root.switch_scene("res://entities/UCL/CreateNewLevel/CreateUCLView.tscn")

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
        root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
		
func _input(delta):
	if Input.is_action_pressed('ui_cancel'):
		root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
		
func render_ucl():
	$loading.popup()	
	for UCLTitle in $UCLTitle.get_children():
		UCLTitle.clear()

	apiController.apiCallGet(apiUrl_UCL)
	yield(apiController, "request_completed")
	
	result_UCL = apiController.getResult()
	responseCode_UCL = apiController.getResponseCode()
	
	max_index = result_UCL.size()
	number_to_minus=30
	
	for i in range(1, 7):
		if (i == 1):
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle1.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5
				$loading.hide()
			
		if (i == 2):
			
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle2.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5
			
		if (i == 3):
			
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle3.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5
			
		if (i == 4):
			
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle4.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5
			
		if (i == 5):
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle5.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5
			
		if (i == 6):
			if (base_index >= max_index):
				nextPage = "false"
			else:
				$UCLTitle/UCLTitle6.append_bbcode("[center]" + result_UCL[base_index]["uclName"])
				base_index = base_index + 5
				number_to_minus = number_to_minus + 5

				nextPage = "true"

	if (base_index >= max_index):
		nextPage = "false"

	if (base_index <= 30):
		$previousPage.hide()
	else:
		$previousPage.show()
		
	if (nextPage == "true"):
		$nextPage.show()
	else:
		$nextPage.hide()

func previousPage_pressed():
	pageNumber -= 1
	base_index = base_index - number_to_minus
	render_ucl()
	pass

func nextPage_pressed():
	pageNumber += 1
	render_ucl()
	pass

func ucl1_pressed():
	chosen_index = pageNumber*30 - 30
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func ucl2_pressed():
	chosen_index = pageNumber*30 - 25
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func ucl3_pressed():
	chosen_index = pageNumber*30 - 20
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func ucl4_pressed():
	chosen_index = pageNumber*30 - 15
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func ucl5_pressed():
	chosen_index = pageNumber*30 - 10
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func ucl6_pressed():
	chosen_index = pageNumber*30 - 5
	get_questions()
	load_questions()
	root.switch_scene("res://entities/UCLGame/UCLGame.tscn")
	pass
	
func get_questions():
	for k in range(5):
		input_array.push_back(result_UCL[chosen_index+k])
	pass
		
func load_questions():
	for item in input_array:
		gameModel.setAllQuestionsByDifficulty(4,item)
	pass
	