extends Label

var specimen_per_second : float
var lost_specimen : int = 0.0

var display_text = null : 
	set = _update_value

func _update_value(new_text):
	self.text = new_text


func _on_world_map_lost_specimen_speed_updated(n_specimen_per_second : float) -> void:
	specimen_per_second = n_specimen_per_second

func _process(delta: float) -> void:
	lost_specimen += (lost_specimen + (specimen_per_second * delta))
	self.text = str(
		lost_specimen + 
		CountryData.get_total_poisoned_individuals()	# static offset
		)
