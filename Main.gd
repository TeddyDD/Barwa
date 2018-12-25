extends Control

var ColorViewer = preload("res://controls/Color.tscn")
var palette = Pallete.new(ColorViewer)


var picker : = false setget set_picker
var precise_picker : = false setget set_precise_picker

func set_picker(value : bool) -> void:
	$"UI/Mouse Picker".visible = value
	picker = value
	
func set_precise_picker(value : bool) -> void:
	$"UI/Precise Picker".visible = value
	precise_picker = value

# Create new color in palette

func _on_New_pressed():
	$"UI/Color List/ScrollContainer/Colors List".add_child(palette.add_color())
	
class Pallete:
	var viewerClass
	
	# Hash id -> UserColor
	var colors = {}
	
	var file = null
	var _next_id : int = 0
	
	func _init(view):
		self.viewerClass = view
		
	func add_color():
		var color = Color()
		var id = get_next_id()
		var viewer = viewerClass.instance()
		viewer.get_node("HBoxContainer/Remove").connect("pressed", self, "_on_color_removed", [id])
		(viewer.get_node("HBoxContainer/Color field/ColorRect") as ColorRect).color = color
		viewer.name = str(id)
		self.colors[id] = {
			color = color,
			viewer = viewer
		}
		return viewer

	func remove_color(id):
		colors[id].viewer.queue_free()
		colors[id] = null
	
	func _on_color_removed(id):
		self.remove_color(id)
		
	func get_next_id() -> int:
		_next_id += 1
		return _next_id
	

class UserColor:
	var color = null
	var viewNode = null
	var id
	func _init(color : Color, id : int, view):
		self.id = id
		self.color = color
		self.viewNode = view
