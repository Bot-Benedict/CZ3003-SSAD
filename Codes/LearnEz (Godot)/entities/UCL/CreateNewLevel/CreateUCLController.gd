extends Node2D

var url = "ucl"
var result_UCL
var responseCode_UCL
var success = 0

func _ready():
	$nextStep.connect("pressed", self, "nextStep_pressed")
	$create.connect("pressed", self, "create_pressed")
	$Q1.connect("pressed",self,"Q1_pressed")
	$Q2.connect("pressed",self,"Q2_pressed")
	$Q3.connect("pressed",self,"Q3_pressed")
	$Q4.connect("pressed",self,"Q4_pressed")
	$Q5.connect("pressed",self,"Q5_pressed")
	get_node("enterAnswer").hide()
	get_node("create").hide()
	get_node("Q1").hide()
	get_node("Q2").hide()
	get_node("Q3").hide()
	get_node("Q4").hide()
	get_node("Q5").hide()

	pass
func nextStep_pressed():
	if (get_node("uclDesc").text != "") and (get_node("uclLevel").text != ""):
		get_node("enterLevel").hide()
		get_node("enterDesc").hide()
		get_node("uclDesc").hide()
		get_node("uclLevel").hide()
		get_node("enterAnswer").show()
		get_node("create").show()
		get_node("Q1").show()
		get_node("Q2").show()
		get_node("Q3").show()
		get_node("Q4").show()
		get_node("Q5").show()
		create_pressed()
		get_node("nextStep").hide()
	else:
		get_node("errorPopup").show()


func create_pressed():
	var flag = true
	var i = 1
	for question in $questionContainer.get_children():
		if ((question.get_node("questionTitle").text == "") or
		(question.get_node("ans1").text == "") or 
		(question.get_node("ans2").text == "") or
		(question.get_node("ans3").text == "") or
		(question.get_node("ans4").text == "") or
		(!question.checkAnswered())):
			get_node("errorPopup").show()
			flag = false
			if i == 1:
				Q1_pressed()
				break;
			elif i == 2:
				Q2_pressed()
				break;
			elif i == 3:
				Q3_pressed()
				break;
			elif i == 4:
				Q4_pressed()
				break;
			elif i == 5:
				Q5_pressed()
				break;
		i += 1
	if flag == true:
		var name = $uclLevel.get_text()
		var desc = $uclDesc.get_text()
		#for testing purposes
		print("Creating UCL!!")
		apiController.apiCallGet("ucl/all/all")
		yield(apiController, "request_completed")
		result_UCL = apiController.getResult()
		responseCode_UCL = apiController.getResponseCode()
		var totalSize = result_UCL.size()
		print(totalSize)
		print(result_UCL[totalSize-1])
		var uclId = int(result_UCL[totalSize-1]["uclID"]) + 1
		var user_id = userModel.getUserId()
		var apiUrl = "ucl/" + String(user_id)
		$loading.show()
		for question in $questionContainer.get_children():
			var data = {
				"uclID": uclId,
				"questionId": question.Qnumber(),
				"uclName": name,
				"uclDesc": desc,
				"questionTitle": question.get_node("questionTitle").get_text(),
				"option1": question.get_node("ans1").get_text(),
				"option2": question.get_node("ans2").get_text(),
				"option3": question.get_node("ans3").get_text(),
				"option4": question.get_node("ans4").get_text(),
				"correctOption": question.correctAnswer()
			}
			apiController.apiCallPost(data,apiUrl)
			yield(apiController, "request_completed")
			var result = apiController.getResult()
			var responseCode = apiController.getResponseCode()
			#for testing purposes.
			print("Response Code: " + String(responseCode))
			success+=1
		if (success == 5):
			$loading.hide()
			$createSuccess.show()
		else:
			get_node("createFail").show()


func Q1_pressed():
	get_node("questionContainer/question1").show()
	get_node("questionContainer/question2").hide()
	get_node("questionContainer/question3").hide()
	get_node("questionContainer/question4").hide()
	get_node("questionContainer/question5").hide()
	
func Q2_pressed():
	get_node("questionContainer/question1").hide()
	get_node("questionContainer/question2").show()
	get_node("questionContainer/question3").hide()
	get_node("questionContainer/question4").hide()
	get_node("questionContainer/question5").hide()
	
func Q3_pressed():
	get_node("questionContainer/question1").hide()
	get_node("questionContainer/question2").hide()
	get_node("questionContainer/question3").show()
	get_node("questionContainer/question4").hide()
	get_node("questionContainer/question5").hide()
	
func Q4_pressed():
	get_node("questionContainer/question1").hide()
	get_node("questionContainer/question2").hide()
	get_node("questionContainer/question3").hide()
	get_node("questionContainer/question4").show()
	get_node("questionContainer/question5").hide()
	
func Q5_pressed():
	get_node("questionContainer/question1").hide()
	get_node("questionContainer/question2").hide()
	get_node("questionContainer/question3").hide()
	get_node("questionContainer/question4").hide()
	get_node("questionContainer/question5").show()