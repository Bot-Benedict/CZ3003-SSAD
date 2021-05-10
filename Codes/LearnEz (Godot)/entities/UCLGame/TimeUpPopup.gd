extends Popup

func _ready():
	$bg.hide()
	connect("about_to_show",self,"playAni")
	$backToUcl.hide()
	$getHelp.hide()
	
	$backToUcl.connect("pressed",self,"backToUCL")
	$getHelp.connect("pressed",self,"getHelp")
	pass 

func playAni():
	SoundManager.play_me("res://assets/sounds/gameOver.ogg",true,true,"res://assets/sounds/gameTheme.ogg")
	$bg.hide()
	$gameOverAni.play("gameover")
	

func _on_gameOverAni_animation_finished():
	$bg.show()
	$gameOverAni.queue_free()
	$backToUcl.show()
	$getHelp.show()
	pass #
	
func backToUCL():
	SoundManager.stop_me("res://assets/sounds/gameOver.ogg")
	SoundManager.play_bgm("themeSong",false)
	root.switch_scene("res://entities/UCL/UCLView.tscn")
	
func getHelp():
	SoundManager.stop_me("res://assets/sounds/gameOver.ogg")
	SoundManager.play_bgm("themeSong",false)
	root.switch_scene("res://entities/Discussion/DiscussionBoardController.tscn")

