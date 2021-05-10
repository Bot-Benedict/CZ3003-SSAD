extends Sprite

func _ready():
	self.hide()
	$closeButton.connect("pressed",self,"closeButton_pressed")
	pass

func closeButton_pressed():
	self.hide()