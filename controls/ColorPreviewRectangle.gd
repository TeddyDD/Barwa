extends ColorRect

onready var root = get_node("../../..")


func get_drag_data(position):
	var p = ColorRect.new()
	p.color = color
	p.rect_min_size = Vector2(50,50)
	set_drag_preview(p)
	
	return {id = root.id}
	
func can_drop_data(position, data):
	if data is Dictionary:
		if data.has("id"):
			if data["id"] != root.id:
				return true
	return false

func drop_data(position, data):
	root.swap(data["id"])