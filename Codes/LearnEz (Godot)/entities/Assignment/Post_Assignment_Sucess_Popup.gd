extends Sprite

func _ready():
	
	$done_btn.connect("pressed",self,"close_popup")
	$share_to_facebook_btn.connect("pressed",self,"share_to_facebook")
	$share_to_twitter_btn.connect("pressed",self,"share_to_twitter")
	pass
	
func close_popup():
	root.switch_scene("res://entities/Assignment/AssignmentController.tscn")

func share_to_facebook():
	var link = get_parent().result["message"][0]
	var facebookLink = "https://www.facebook.com/dialog/share?app_id=1376441105933128&display=popup&title=This%20is%20the%20title%20parameter&description=This%20is%20the%20description%20parameter&quote=New%20Assignment%20Posted&caption=A%New%Assignment%Has%Been%Posted&href="
	facebookLink = facebookLink + link + "&redirect_uri=" + link
	OS.shell_open(facebookLink)
	#print(get_parent().result["message"][0])
	
	
func share_to_twitter():
	var link = get_parent().result["message"][0]
	var twitterLink = "https://twitter.com/intent/tweet?text=New Assignment Posted " + link 
	OS.shell_open(twitterLink)
