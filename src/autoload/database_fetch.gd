extends Node
const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path="res://Database/database.db"
var tablename="Database"
onready var timer=get_node("Timer")
var ID=1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#var output
	db=SQLite.new()
	db.path=db_path
	db.open_db(db)
	timer.set_wait_time(1)
	timer.start()
	#output=read_db_time(3,5)
	#print(output)

func readfromdb():
	db.query("select * from " + tablename + " where ID=" + str(ID))
	var telemetry_data=db.query_result
#	print(telemetry_data)
	ID=ID+1

func read_db_time(day: int, hour: int) -> Dictionary:
	var hourtoget
	hourtoget=((day-1)*24)+hour+1
	db.query("select * from " + tablename + " where ID=" + str(hourtoget))
	return db.query_result[0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	#pass
	readfromdb()
