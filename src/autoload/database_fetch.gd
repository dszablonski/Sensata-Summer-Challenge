extends Node
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://database/database.db"
var tablename = "Database"


func _ready():
	db = SQLite.new()
	db.path = db_path
	db.open_db(db)


func read_db(year: int, month: int, day: int, hour: int) -> Dictionary:
	var hourtoget
	var monthtotals = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
	var days = ((year - 2021) * 365) + (monthtotals[month - 1])
	if year == 2021:
		days = days - 151
	days = days + day
	hourtoget = ((days - 1) * 24) + hour + 1
	db.query("select * from " + tablename + " where ID=" + str(hourtoget))
	return db.query_result[0]


func read_db_current_date_time() -> Dictionary:
	return read_db(
		GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay, GlobalDate.hour
	)


func read_db_current_date(hour: int) -> Dictionary:
	return read_db(GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay, hour)


func _on_RefreshDatabaseTimer_timeout() -> void:  # Left unimplemented
	print("Database to be refreshed!")
