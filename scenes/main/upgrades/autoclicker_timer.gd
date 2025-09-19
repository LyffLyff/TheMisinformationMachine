extends Timer

func _on_timeout() -> void:
	# add one poisoned individual to all countries
	CountryData.increment_static_specimen_for_all_countries()
