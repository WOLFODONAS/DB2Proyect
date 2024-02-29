extends Window
var info = {}
var tb = ""
var isNM
var edit = false
var tbInfo
func start(x,_tb):
	tb = _tb
	tbInfo = Sql.get_table_info(tb)
	print(x)
	isNM =! tbInfo[0]["name"]=="ID"
	info = x
	#$VBoxContainer/HBoxContainer/Label.text = "Conditions" if isNM else "ID"
	popup()



func _on_check_button_toggled(toggled_on: bool) -> void:
	$VBoxContainer/HBoxContainer/LineEdit.editable = toggled_on
	edit = toggled_on

func _on_button_pressed() -> void:
	var qr = ""
	if edit:
		Sql.update(tb,info,$VBoxContainer/HBoxContainer/LineEdit.text)
	else:
		Sql.insert(tb,info)
	#get_tree().reload_current_scene()
	pass # Replace with function body.
