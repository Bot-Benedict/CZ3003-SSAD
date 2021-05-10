extends Node

#Handle Launch Page
func _ready():
	SoundManager.play_bgm("themeSong",true) 
	root.set_screen_orientation(0)
	$to_Login_Btn.connect("pressed",self,"login_pressed")
	pass 
	
func login_pressed():
	root.switch_scene("res://entities/LoginManager/LoginController.tscn")
	
	#OS.shell_open("https://www.facebook.com/dialog/share?app_id=1376441105933128&display=popup&title=This%20is%20the%20title%20parameter&description=This%20is%20the%20description%20parameter&quote=New%20Assignment%20Posted%20quote%20parameter&caption=A%New%Assignment%Has%Been%Posted&href=https://learnez.a2hosted.com/CZ3003LabManual1.pdf&redirect_uri=https%3A%2F%2Flearnez.a2hosted.com/CZ3003LabManual1.pdf")