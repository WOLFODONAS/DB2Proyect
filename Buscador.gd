extends Window
var currentTable
var currentFK
signal updating(newQ)
func start(table:String,fk:Array):
	print(table,"---",fk)
	$VBoxContainer/Label.text = "Buscar en " + table
	currentTable = table
	currentFK = fk
	popup()



func _on_button_pressed() -> void:
	var x  = Sql.get_table(currentTable,currentFK,$VBoxContainer/TextEdit.text)
	updating.emit(x)
	pass # Replace with function body.
