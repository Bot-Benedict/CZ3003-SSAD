extends Popup


func _ready():
	$close_btn.connect("pressed",self,"close_popup")
	pass
	
func close_popup():
	self.hide()


