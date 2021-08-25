extends Node
const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path="res://database/database.db"
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
	#print(telemetry_data)
	ID=ID+1

func read_db_time(day: int, hour: int) -> Dictionary:  # Deprecated
	var hourtoget
	hourtoget=((day-1)*24)+hour+1
	db.query("select * from " + tablename + " where ID=" + str(hourtoget))
	return db.query_result[0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_db_time_new(year:int, month: int, day: int, hour: int) -> Dictionary:
	var hourtoget
	var monthtotals=[0,31,59,90,120,151,181,212,243,273,304,334]
	var days=((year-2021)*365)+(monthtotals[month-1])
	if year==2021:
		days=days-151
	days=days+day
	hourtoget=((days-1)*24)+hour+1
	db.query("select * from " + tablename + " where ID=" + str(hourtoget))
	return db.query_result[0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_db_time_current() -> Dictionary:
	return read_db_time_new(
		GlobalDate.GlobalYear,
		GlobalDate.GlobalMonth,
		GlobalDate.GlobalDay,
		GlobalDate.hour
	)

func read_db_time_current_date(hour: int) -> Dictionary:
	return read_db_time_new(
		GlobalDate.GlobalYear,
		GlobalDate.GlobalMonth,
		GlobalDate.GlobalDay,
		hour
	)

func _on_Timer_timeout():
	#pass
	readfromdb()
