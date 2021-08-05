extends Spatial

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Database/database.db"
var csv_path= "res://Database/Telemetrydatacommaseperated.csv"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _run():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	fetchcsv() # Replace with function body.

func fetchcsv():
	var maindata={}
	var file=File.new()
	file.open(csv_path, file.READ)
	for i in range(1,240):
		while !file.eof_reached():
			var data_set=Array(file.get_csv_line())
			maindata=data_set
			print(maindata)
			return maindata
	file.close()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
