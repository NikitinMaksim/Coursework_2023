extends Label
var s = 0
var m = 0

func _on_timer_timeout():
	s+=1
	if s>59:
		s=0
		m+=1
	text = "%02d:%02d" % [m,s]
