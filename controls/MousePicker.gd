tool
extends Control

var id
var old_color = null setget set_old_color


export(NodePath) var wrapper

signal set_color(id, color)

var color = Color()
var mouse = false
export var control = true
var mouse_pos
export var saturation_speed = 0.005
export var safe_margin = 25 # pixels

export(Texture) var color_checker

func _ready():
	color.s = 1

func _gui_input(event):
	if not mouse:
		return
	var updated = false
	var c = {
		h=color.h,
		s=color.s,
		v=color.v,
		a=color.a
	}
	
	match event.get_class():
		"InputEventMouseButton":
			match event.button_index:
				BUTTON_LEFT:
					if event.is_pressed():
						control = !control
						mouse_pos = event.position
					accept_event()
				BUTTON_WHEEL_UP: 
					c.s = clamp(color.s + saturation_speed, 0, 1)
					updated = true
				BUTTON_WHEEL_DOWN: 
					c.s = clamp(color.s - saturation_speed, 0, 1) 
					updated = true
				BUTTON_RIGHT:
					accept_event()
					mouse = false
					control = false
					_color_accepted()
		"InputEventMouseMotion":
			if control == true:
				mouse_pos = event.position
				_pos_to_color(event.position, c)
				updated = true
	if updated == true:
		color = Color.from_hsv(c.h, c.s, c.v, c.a)
		accept_event()
		update()
		$Label.text = str(color.to_html(false))
		
func _color_to_pos(color):
	var v = Vector2()
	v.x = range_lerp(color.h, 0.0, 1.0, safe_margin, get_rect().size.x - safe_margin)
	v.y = range_lerp(color.v, 0.0, 1.0, safe_margin, get_rect().size.y - safe_margin)
	return v
	
func _pos_to_color(pos, color):
	var r = get_rect()
	color.h = range_lerp(pos.x, safe_margin, r.size.x - safe_margin, 0.0, 1.0)
	color.v = range_lerp(pos.y, safe_margin, r.size.y - safe_margin, 0.0, 1.0)
	
func set_old_color(c):
	old_color = c
	if c:
		mouse_pos = _color_to_pos(c)
		color = c
		control = false

func _color_accepted():
	assert(id != null)
	assert(color != null)
	emit_signal("set_color", id, color)
	id = null
	old_color = null
	get_node(wrapper).visible = false

func _draw():
	draw_texture_rect(color_checker, get_rect(), true)
	draw_rect(get_rect(), color)
	var p = mouse_pos if mouse_pos else get_local_mouse_position()
	draw_circle(p, 3, color.contrasted())

func _on_MousePicker_mouse_entered():
	mouse = true

func _on_MousePicker_mouse_exited():
	mouse = false
