extends ColorPicker

func _on_PreciseColorPicker_preset_added(c):
	add_preset(c)


func _on_PreciseColorPicker_preset_removed(c):
	erase_preset(c)
