extends Node

#Login  Controller
func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	$username_empty_label.hide()
	$password_empty_label.hide()
	$Loading_bg.hide()
	$Loading_sprite.hide()
	$Reset_by_ID.hide()
	$Forget_Password_Btn.connect("meta_clicked", self, "forget_password_clicked")
	pass 

func forget_password_clicked(meta):
	$Reset_by_ID.show()
	$Forget_Password_Popup.show()
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		root.return_to_last()
