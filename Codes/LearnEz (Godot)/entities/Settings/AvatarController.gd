extends Node2D

var currentSelection

func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	
	updateSelectedAvatar(userModel.getUserAvatar())
	
	for button in $avatargroup.get_children():
		button.connect("pressed", self, "handleSelectAvatar", [button])
	
	$choose_avatar_btn.connect("pressed",self, "renderConfirmationDialog")
	
	pass

func handleSelectAvatar(button):
	currentSelection = button.name
	updateSelectedAvatar(currentSelection)
	
func updateSelectedAvatar(selection):
	$SelectedAvatar.play(selection)
	
func renderConfirmationDialog():
	$confirmation_popup.popup()
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		root.return_to_last()
		
func _input(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		root.return_to_last()