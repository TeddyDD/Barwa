extends Node

var copy_formats = [
	"RGB",
	"HSL",
	"Float RGB",
	"HTML",
	"TIC-80 Palette"
]

var save_formats = [
	"text file",
	"Gimp Palette",
	"json"
]

class Conventer:
	var palette
	func to_color(string):
		pass
	func to_string(id):
		pass

class HTMLConventer:
	extends Conventer
	func to_string(id):
		return palette.get_color(id).to_html()
	func to_color(string):
		# todo regex chk
		return Color(string)

class Exporter:
	extends Popup
	func takes_conventer():
		return false