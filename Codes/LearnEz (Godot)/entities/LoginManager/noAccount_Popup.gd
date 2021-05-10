extends Sprite

#Handles Error Message for invalid login
func _ready():
	self.hide()
	$Close_Btn.connect("pressed",self, "close_popup")
	pass 

func close_popup():
	self.hide()