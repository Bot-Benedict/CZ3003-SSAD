extends Sprite

func _ready():
	$Return_Btn.connect("pressed",self,"close_popup")
	pass
	
func close_popup():
	root.switch_scene("res://entities/Menu/Student_MainMenu_Controller.tscn")
