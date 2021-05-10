extends AudioStreamPlayer

var songPos = 0

func playSong():
	self.play()
	self.seek(songPos)
	
func stopSong():
	songPos = self.get_playback_position( )
	self.stop()
	