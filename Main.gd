extends Control

const ColorView = preload("res://controls/Color.tscn")

onready var palette = PalleteController.new(Palete.new())

func _ready():
	palette.list = $"UI/Color List/Bottom Panel/Colors List"
	palette.edit_handler = self

	var mp = $"UI/Mouse Picker Wrapper/VBoxContainer/MousePicker"
	mp.connect("set_color", self, "set_color")

	var pp = $"UI/Precise Picker"
	pp.connect("set_color", self, "set_color")


func edit(id, old_color, precise):
	var picker = set_picker(precise, true)
	picker.id = id
	picker.old_color = old_color

func set_color(id, color):
	palette.set_color(id, color)

# makes picker visible and returns node
func set_picker(precise, visible):
	match precise:
		false:
			$"UI/Mouse Picker Wrapper".visible = visible
			return $"UI/Mouse Picker Wrapper/VBoxContainer/MousePicker"
		true:
			$"UI/Precise Picker".visible = visible
			return $"UI/Precise Picker"


# signals

func _on_New_pressed():
	palette.add_color()

# classes

class PalleteController:
	var palette : Palete
	var views = {}

	var list # place in node tree to add views
	var edit_handler

	func _init(palette):
		self.palette = palette

	func add_color():
		var id = palette.add_color()
		var color = palette.get_color(id)

		var view = ColorView.instance()
		list.add_child(view)
		view.id = id
		view.color_rect.color = color
		_register_view_signals(view, id)
		views[id] = view
		return id
		
	func get_color(id):
		return palette.get_color(id)

	func edit_color(id, precise=false):
		var c = palette.get_color(id)
		edit_handler.edit(id, c, precise)

	func set_color(id, color):
		palette.set_color(id, color)
		var view = views[id]
		view.color_rect.color = color

	func swap_colors(id, other_id):
		var v1 = views[id]
		var v2 = views[other_id]
		var idx1 = v1.get_index()
		var idx2 = v2.get_index()
		list.move_child(v1, idx2)
		list.move_child(v2, idx1)

	func remove_color(id):
		var view = views[id]
		palette.remove_color(id)
		views.erase(id)
		_unregister_view_signals(view,id)
		view.queue_free()

	func _register_view_signals(view, id):
		view.pick.connect("pressed", self, "edit_color", [id])
		view.precise.connect("pressed", self, "edit_color", [id,true])
		view.remove.connect("pressed", self, "remove_color", [id])
		view.connect("swap_colors", self, "swap_colors")

	func _unregister_view_signals(view, id):
		view.pick.disconnect("pressed", self, "edit_color")
		view.precise.disconnect("pressed", self, "edit_color")
		view.remove.disconnect("pressed", self, "remove_color")
		view.disconnect("swap_colors", self, "swap_colors")

class Palete:
	var colors = {} # id -> color
	var color_index = []
	var _next_id = 0

	func get_next_id():
		_next_id += 1
		return _next_id

	func add_color():
		var id = get_next_id()
		var prev = color_index.back()

		color_index.append(id)

		colors[id] = Color() if not prev else Color(colors[prev].to_html())
		return id

	func remove_color(id):
		pass

	func get_color(id):
		return colors[id]

	func set_color(id, color):
		colors[id] = color

