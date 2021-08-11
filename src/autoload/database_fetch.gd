extends Node
const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path="res://Database/database.db"
var tablename="Database"
onready var timer=get_node("Timer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	db=SQLite.new()
	db.open_db()
	timer.set_wait_time(1)
	timer.start()

func readfromdb():
	db.query("select * from" + tablename + "where ID")
	var telemetry_data=db.query_result()
	telemetry_data=Dictionary(telemetry_data)
	print(telemetry_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	readfromdb()
