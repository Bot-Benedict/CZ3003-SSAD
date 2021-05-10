extends RichTextLabel

var ms = 0
var s = 30
var m = 3
var running = true
signal no_time
	
func _process(delta):
	if(m == -1):
		self.running == false
		queue_free()
		emit_signal("no_time")
		
	if(running == true):
		if ms == 0:
			s -= 1
			ms = 9
		if s == 0:
			m -= 1
			s = 59
		set_text(str(m)+":"+str(s)+":"+str(ms))
	pass
	
func _on_ms_timeout():
	ms -= 1
	pass 
