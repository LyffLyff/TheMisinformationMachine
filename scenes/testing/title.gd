extends Label

var specimen_per_second : float
var lost_specimen : int = 0.0

var display_text = null : 
	set = _update_value

func _update_value(new_text):
	self.text = new_text


func _on_world_map_lost_specimen_speed_updated(n_specimen_per_second : float) -> void:
	specimen_per_second = n_specimen_per_second
