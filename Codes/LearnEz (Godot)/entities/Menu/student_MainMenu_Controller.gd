extends Node2D

#Student Main Menu

func _ready():
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	$playgame.connect("pressed",self,"playgame_pressed")
	$usercreations.connect("pressed",self,"usercreations_pressed")
	$assignments.connect("pressed",self,"assignments_pressed")
	$leaderboard.connect("pressed",self,"leaderboard_pressed")
	$discussionboard.connect("pressed",self,"discussionboard_pressed")
	$settings.connect("pressed",self,"settings_pressed")
	pass 

func playgame_pressed():
	root.switch_scene("res://entities/World/WorldController.tscn")
	

func usercreations_pressed():
	root.switch_scene("res://entities/UCL/UCLView.tscn")

func assignments_pressed():
	root.switch_scene("res://entities/Assignment/AssignmentController.tscn")
	
func leaderboard_pressed():
	root.switch_scene("res://entities/Leaderboard/LeaderboardController.tscn")
	
func discussionboard_pressed():
	root.switch_scene("res://entities/Discussion/DiscussionBoardController.tscn")	
	
func settings_pressed():
	root.switch_scene("res://entities/Settings/SettingsController.tscn")