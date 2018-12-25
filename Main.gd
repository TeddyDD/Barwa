extends Control

onready var ColorItem = preload("res://controls/Color.tscn")

var palette = {
	file = null,
	colors = []
}

var picker = false setget set_picker
var precise_picker = false setget set_precise_picker

func _ready():
	add_color()
	
func add_color():
	var c = {}
	c.color = Color(1,1,1,1)
	c.control = spawn_color_control()
	
	
func spawn_color_control():
	var c = ColorItem.instance()
	$"UI/Color List/ScrollContainer/List".add_child(c)
	return c
	

func set_picker(value : bool) -> void:
	$"UI/Mouse Picker".visible = value
	picker = value
	
func set_precise_picker(value : bool) -> void:
	$"UI/Precise Picker".visible = value
	precise_picker = value

# Create new color in palette

func _on_New_pressed():
	add_color()
