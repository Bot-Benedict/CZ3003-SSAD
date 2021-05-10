extends Sprite


func _ready():
	get_parent().get_node("logout_btn").connect("pressed",self,"renderLogoutBox")
	$close_btn.connect("pressed",self,"closeLogoutBox")
	$accept_btn.connect("pressed",self,"handleLogout")
	pass 

func renderLogoutBox():
	self.show()

func closeLogoutBox():
	self.hide()
	
func handleLogout():
	root.switch_scene("res://entities/Main/Launch.tscn")