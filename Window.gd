extends Window

func start(table:String,fk:Array[String]):
	print(table,"---",fk)
	print("sobas")
	popup()
	Sql.get_table(table,fk)
	
