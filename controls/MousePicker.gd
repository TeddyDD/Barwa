tool
extends Control

var id
var old_color

export(NodePath) var wrapper

signal set_color(id, color)

var color = Color()
var mouse = false
export var control = true
export var saturation_speed = 0.005
export var safe_margin = 25 # pixels

func _ready():
	color.s = 1

func _gui_input(event):
	if not mouse:
		return
	
	var updated = false
	
	if event is InputEventMouseButton:
		var change = 0
		if control:
			match event.button_index:
				BUTTON_WHEEL_UP: change = saturation_speed
				BUTTON_WHEEL_DOWN: change = -saturation_speed
				BUTTON_RIGHT:
					mouse = false
					accept_event()
					_color_accepted()
					return
			var s = clamp(color.s + change, 0, 1)
			color = Color.from_hsv(color.h, s, color.v, 1.0)
			updated = true
	
	if event is InputEventMouse and control:
		var r = get_rect()
		var h = range_lerp(event.position.x, safe_margin, r.size.x - safe_margin, 0.0, 1.0)
		var v = range_lerp(event.position.y, safe_margin, r.size.y - safe_margin, 0.0, 1.0)
		color = Color.from_hsv(h, color.s, v, 1.0)
		updated = true
		
	if updated:
		accept_event()
		update()
		$Label.text = str(color.to_html(false))

func _color_accepted():
	emit_signal("set_color", id, color)
	id = null
	old_color = null
	get_node(wrapper).visible = false

func _draw():
	draw_rect(get_rect(), color)
	var p = get_local_mouse_position()
	draw_circle(p, 3, color.inverted())
	draw_line(p - Vector2(-30,0), p + Vector2(30,0), color.inverted(), 5, true)

func _on_MousePicker_mouse_entered():
	mouse = true

func _on_MousePicker_mouse_exited():
	mouse = false
