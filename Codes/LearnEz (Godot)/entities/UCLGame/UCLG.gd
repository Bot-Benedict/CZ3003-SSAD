extends Node2D

onready var gameTimer = $TimerPopup/Timer
onready var Player = $Player
onready var ucl = $UCL

func _ready():
	SoundManager.stop_bgm("themeSong")
	SoundManager.play_me("res://assets/sounds/gameTheme.ogg",true)
	gameModel.setNumQuestions(5)
	root.set_screen_orientation(0)
	get_tree().set_auto_accept_quit(false)
	$TimerPopup/bg.modulate = Color(1,1,1,0.5)
	$Ready.play("ready")
	pass

func _on_Ready_animation_finished():
	$Ready.queue_free()
	$TimerPopup.popup()
	$TimerPopup/Timer/ms.start()
	Player.set_physics_process(true)
	pass 

func _on_Timer_no_time():
	$Questions.hide()
	gameTimer.set_process(false)
	$TimerPopup/Timer/ms.stop()
	$TimerPopup/bg.hide()

	$TimeUpPopup.popup()
	Player.set_physics_process(false)
	pass

func timeUp():
	if(userInventoryModel.getQuantityByIdx(1) == '0'):
		pass
	else:
		gameTimer.s += 20
		if(gameTimer.s >= 60):
			gameTimer.m += 1
			gameTimer.s -= 60
		userInventoryModel.reducePowerupQuantyByIdx(1)
		$timePowerupQuantityLbl.clear()
		$timePowerupQuantityLbl.append_bbcode(userInventoryModel.getQuantityByIdx(1))
	pass
	
func _on_Questions_popup_hide():
	if(gameModel.numQuestions == 0):
		Player.set_physics_process(false)
		gameModel.calculateScore(gameTimer.m,gameTimer.s,gameTimer.ms)
		$TimerPopup/Timer/ms.stop()
		$gameClearPopup.popup()
	pass
