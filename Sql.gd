extends Node
var db : SQLite

func _ready()->void:
	db = SQLite.new()
	db.path = "res://Database.db"
	db.foreign_keys = true



	
func get_table_info(table:String)->Array:
	db.open_db()
	db.query("PRAGMA table_info("+table+")")
	db.close_db()
	return db.query_result.duplicate()
	
func update(tab,data,cnd):
	db.open_db()
	db.update_rows(tab,cnd,data)
	db.close_db()
func insert(tb,data):
	db.open_db()
	db.insert_row(tb,data)
	db.close_db()
func delate(tb,cnd):
	db.open_db()
	db.delete_rows(tb,cnd)
	db.close_db()
func get_table(
		table:String,
		foreingKeys:PackedStringArray=[],
		strCondition:String="")-> Array:
	var tableInfo =get_table_info(table)
	db.open_db()
	#Sets the columns names 
	var clms =""
	for i in tableInfo:
		if !i["name"] in foreingKeys:
			clms+=i["name"]+","
		else:
			clms+=i["name"]+"Nombre,"
			print("000")
	clms=clms.substr(0,clms.length()-1)
	#create Joins for the foreingKeys
	var fkJoins = ""
	for i in foreingKeys:
		fkJoins+=(
		"join (select ID as " + i +"ID,"+
		"Nombre as "+i+ "Nombre from "+i+ ") as "+i+"Nombre on " + 
		table +"." +  i + " = "+ i + "Nombre."+i+"ID\n")
	#if has a condition, sets
	var cdn =("" if strCondition.is_empty() 
				else "Where "+strCondition)
	#create the query
	db.query(
		"select " + clms+" from \n(select * from "+table +
		"\n"+fkJoins + 
		")" + cdn
	)
	#returns a copy of the results
	db.close_db()
	return db.query_result.duplicate()


func _on_close_requested() -> void:
	print("aaa")
	#hide()
	pass # Replace with function body.
