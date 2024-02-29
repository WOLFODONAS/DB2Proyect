extends Control
enum tables{
	none,
	Alumno,
	AlumnoAsignatura,
	Asignatura,
	AulaAsignaturaProfesor,
	Especialidad,
	Idioma,
	Profesor,
	Aula
}
var foreingKeys=[
	[],
	[],
	["Alumno","Asignatura"],
	["Especialidad","Idioma"],
	["Aula","Asignatura","Profesor","Dia"],
	[],
	[],
	["Especialidad"],
	[]
]
@onready var tabM:TabContainer = $TabContainer
@onready var searcher:Window = $Buscador
@onready var editorr:Window = $Editore
@onready var delat:Window = $Delatedor
func _ready() -> void:
	for i in tables.keys().slice(1):
		var indx = tables[i]
		var currentPanel = tabM.get_child(indx)
		var info = Sql.get_table_info(i)

		if info[0]["name"] =="ID":
			info.remove_at(0)
		var currentBar = currentPanel.get_node("VBoxContainer/HBoxContainer")
		for j in info:
			var k = j["name"]
			if k in foreingKeys[indx]:
				var newB = OptionButton.new()
				newB.name = k
				var opts = Sql.get_table(k)
				newB.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				newB.size_flags_vertical= Control.SIZE_EXPAND_FILL

				newB.add_item(k,9999)
				for q in opts:
					if not q["Nombre"]  == null:
						newB.add_item(q["Nombre"],q["ID"])
				currentBar.add_child(newB)
			else:
				var newI = LineEdit.new()
				newI.name = k
				newI.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				newI.size_flags_vertical= Control.SIZE_EXPAND_FILL
				newI.placeholder_text = k
				currentBar.add_child(newI)
				print("uuu")

func _on_button_pressed(extra_arg_0: int) -> void:
	
	tabM.current_tab = extra_arg_0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		tabM.current_tab = 0
		searcher.hide()
		editorr.hide()
		delat.hide()
	if tabM.current_tab !=0:
		if Input.is_action_just_pressed("buscar"):
			searcher.start(tables.keys()[tabM.current_tab],foreingKeys[tabM.current_tab])
		if Input.is_action_just_pressed("guardar"):
			var currentPanel = tabM.get_child(tabM.current_tab)
			var currentBar = currentPanel.get_node("VBoxContainer/HBoxContainer")
			var tbInfo = {}
			for i in currentBar.get_children():
				if i is OptionButton:
					var id = i.get_item_id(i.selected)
					if id != 9999:
						tbInfo[i.name] = id
				elif i is LineEdit:
					if i.text != "" or null:
						tbInfo[i.name] = i.text 
				print(i.name)
			editorr.start(tbInfo,tables.keys()[tabM.current_tab])
		if Input.is_action_just_pressed("borrar"):
			delat.start(tables.keys()[tabM.current_tab])
			pass


func _on_window_close_requested() -> void:
	searcher.hide()




func _on_buscador_updating(newQ: Array) -> void:
	var currentPanel = tabM.get_child(tabM.current_tab)
	var grid = currentPanel.get_node("VBoxContainer/ScrollContainer/HBoxContainer2")
	while grid.get_child_count() !=0:
		var x = grid.get_child(0)
		print(x)
		grid.remove_child(x)
		if x == null:
			break
		x.queue_free()
	var columns = {}
	if newQ.is_empty():
		var newLabel = Label.new()
		newLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newLabel.text = "Tabla Vacia"
		newLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		newLabel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		grid.add_child(newLabel)
		return
	var keys =  newQ[0].keys()
	for i in newQ[0].keys():
		var newLabel = Label.new()
		newLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newLabel.text = i+"\n"
		newLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		newLabel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		columns[i] = newLabel
		grid.add_child(newLabel)
	for i in newQ:
		for j in keys:
			columns[j].text += str(i[j])+"\n"

	pass # Replace with function body.




func _on_editore_close_requested() -> void:
	editorr.hide()
	pass # Replace with function body.


func _on_delatedor_close_requested() -> void:
	delat.hide()
	pass # Replace with function body.
