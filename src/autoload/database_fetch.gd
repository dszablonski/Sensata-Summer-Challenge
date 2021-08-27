extends Node
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var res_db_path = "res://database/database.db"
var db_path = "user://database.db"
var tablename = "Database"


func _ready():
	var directory = Directory.new()
	# The database must be copied from res:// to user:// as res:// is read-only.
	# user:// is accessible at AppData/Roaming/Godot/app_userdata/Truck Viewer/
	directory.copy(res_db_path, db_path)
	# Opens the path to the database to allow access
	db = SQLite.new()
	db.path = db_path
	db.open_db(db)


func read_db(year: int, month: int, day: int, hour: int) -> Dictionary:
	var hourtoget
	# Calculate the day of year based on the month
	var monthtotals = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
	# Calculate the day number
	var days = ((year - 2021) * 365) + (monthtotals[month - 1])
	if year == 2021:
		# Adjust to the start of the database, 1/6/2021
		days = days - 151
	days = days + day
	# Calculate the hour number
	hourtoget = ((days - 1) * 24) + hour + 1
	# Fetch data for that hour
	db.query("select * from " + tablename + " where ID=" + str(hourtoget))
	return db.query_result[0]


func read_db_current_date_time() -> Dictionary:
	return read_db(
		GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay, GlobalDate.hour
	)


func read_db_current_date(hour: int) -> Dictionary:
	return read_db(GlobalDate.GlobalYear, GlobalDate.GlobalMonth, GlobalDate.GlobalDay, hour)


func _on_RefreshDatabaseTimer_timeout() -> void:  # Left unimplemented.
	# This is left as a proof of concept for how receiving real-time data could
	# work.
	# Every 60 seconds the database could be refreshed which would bring in any
	# new data and possibly any corrections for old data that was incorrectly
	# inputted.
	print("Database to be refreshed!")
