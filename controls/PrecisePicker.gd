extends PanelContainer

var id
var old_color setget set_old_color

onready var picker := $VBoxContainer/ColorPicker
onready var ok = $VBoxContainer/Ok
onready var cancel = $VBoxContainer/Cancel

signal set_color(id, color)

func set_old_color(color):
	old_color = color
	picker.color = color

func _on_Ok_pressed():
	emit_signal("set_color", id, picker.color)
	visible = false

func _on_Cancel_pressed():
	id = null
	old_color = Color()
	visible = false
