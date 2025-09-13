extends Label

var display_text = null : 
	set = _update_value

func _update_value(new_text):
	self.text = new_text
