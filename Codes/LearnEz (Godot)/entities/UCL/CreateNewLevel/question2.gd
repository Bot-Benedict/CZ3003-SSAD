extends Container

var option1 = false
var option2 = false
var option3 = false
var option4 = false

func _ready():
	self.hide()
	$option1.connect("pressed",self,"option1_pressed")
	$option2.connect("pressed",self,"option2_pressed")
	$option3.connect("pressed",self,"option3_pressed")
	$option4.connect("pressed",self,"option4_pressed")
	pass # Replace with function body.

func option1_pressed():
	if (option1 == false):
		option1 = true
		option2 = false
		option3 = false
		option4 = false
		
func option2_pressed():
	if (option2 == false):
		option1 = false
		option2 = true
		option3 = false
		option4 = false
		
func option3_pressed():
	if (option3 == false):
		option1 = false
		option2 = false
		option3 = true
		option4 = false
		
func option4_pressed():
	if (option4 == false):
		option1 = false
		option2 = false
		option3 = false
		option4 = true
		
func checkAnswered():
	return (option1 or option2 or option3 or option4)

func correctAnswer():
	if (option1):
		return 0
	elif (option2):
		return 1
	elif (option3):
		return 2
	elif (option4):
		return 3

func Qnumber():
	return 2