extends Sprite


func _ready():
	$close_btn.connect("pressed",self,"closePasswordUpdateBox")
	pass 
	
func closePasswordUpdateBox():
	self.hide()
	
