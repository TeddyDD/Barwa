extends Control

const ColorView = preload("res://controls/Color.tscn")

onready var palette = PalleteController.new(Palete.new())

func _ready():
	palette.list = $"UI/Color List/Bottom Panel/Colors List"
	palette.edit_handler = self
	
	var mp = $"UI/Mouse Picker Wrapper/VBoxContainer/MousePicker"
	mp.connect("set_color", self, "set_color")


func edit(id, old_color, precise):
	var picker = set_picker(precise, true)
	picker.id = id
	picker.old_color = old_color
	
func set_color(id, color):
	prints(id, color)
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
	
	func edit_color(id):
		var c = palette.get_color(id)
		edit_handler.edit(id, c, false)
		
	func set_color(id, color):
		palette.set_color(id, color)
		var view = views[id]
		view.color_rect.color = color
		
		
	func remove_color(id):
		pass
		
	func _register_view_signals(view, id):
		view.pick.connect("pressed", self, "edit_color", [id])
	
	func _unregister_view_signals(view, id):
		view.pick.disconnect("pressed", self, "edit_color")

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

