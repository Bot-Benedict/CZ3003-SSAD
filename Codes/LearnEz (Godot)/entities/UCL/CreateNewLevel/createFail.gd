extends Sprite

func _ready():
	self.hide()
	$close.connect("pressed",self,"close_pressed")
	pass 

func close_pressed():
	self.hide()