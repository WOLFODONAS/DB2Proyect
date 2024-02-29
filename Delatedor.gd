extends Window
var tb = ""
func start(_tb):
	tb = _tb
	$VBoxContainer/Label.text = "Borrar de " + tb
	popup()



func _on_button_pressed() -> void:
	Sql.delate(tb,$VBoxContainer/LineEdit.text)
	pass # Replace with function body.
