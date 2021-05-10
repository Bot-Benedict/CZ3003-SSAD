extends Sprite

func _ready():
	$done_btn.connect("pressed",self,"close_popup")
	pass
	
func close_popup():
	root.switch_scene("res://entities/Discussion/DetailedDiscussion.tscn")
