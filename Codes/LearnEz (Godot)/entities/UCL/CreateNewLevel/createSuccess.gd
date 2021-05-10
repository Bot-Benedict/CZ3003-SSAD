extends Sprite

func _ready():
	self.hide()
	$close.connect("pressed",self,"close_pressed")
	pass 

func close_pressed():
	root.switch_scene("res://entities/Menu/student_MainMenu_Controller.tscn")
	self.hide()