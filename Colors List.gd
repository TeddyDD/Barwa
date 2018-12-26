extends GridContainer

func can_drop_data(position, data):
	if data is Dictionary:
		if data.has("id"):
				return true
	return false

func drop_data(position, data):
	var palette = $"/root/Main".palette
	var new_id = palette.add_color()
	palette.set_color(new_id, palette.get_color(data["id"]))
	