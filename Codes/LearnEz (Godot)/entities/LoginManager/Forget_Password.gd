extends Sprite

onready var resetByID = get_parent().get_node("Reset_by_ID")

#Handles Forget Password Popup
func _ready():
	self.hide()
	$Close_Btn.connect("pressed",self,"on_button_pressed")
	$reset_password_empty_lbl.hide()
	pass 

func on_button_pressed():
	resetByID.hide()
	self.hide()