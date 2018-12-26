extends PanelContainer

var id

signal swap_colors(id, other)

onready var pick = $HBoxContainer/Pick
onready var precise = $HBoxContainer/Precise
onready var remove = $HBoxContainer/Remove
onready var color_rect = $"HBoxContainer/Color field/ColorRect"

func swap(other_id):
	emit_signal("swap_colors", id, other_id)

