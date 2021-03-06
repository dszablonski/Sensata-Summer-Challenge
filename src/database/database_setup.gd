extends Spatial

# This script generates a SQLite database from a CSV file

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://database/database"
var csv_path = "res://database/telemetry_data_comma_seperated.csv"


func _ready():
	db = SQLite.new()
	fetchcsv()


func fetchcsv():
	var tablename = "Database"
	var maindata = []
	var fields = [
		"DateTime",
		"Hour",
		"TruckTyrePressureA",
		"TruckTyrePressureB",
		"TruckTyrePressureC",
		"TruckTyrePressureD",
		"TruckTyrePressureE",
		"TruckTyrePressureF",
		"TruckBrakePadsA",
		"TruckBrakePadsB",
		"TruckWheelBearingTempA",
		"TruckWheelBearingTempB",
		"TruckWheelBearingTempD",
		"TruckWheelBearingTempF",
		"TrailerTyrePressureA",
		"TrailerTyrePressureB",
		"TrailerTyrePressureC",
		"TrailerTyrePressureD",
		"TrailerTyrePressureE",
		"TrailerTyrePressureF",
		"TrailerTemperatureA",
		"TrailerTemperatureB",
		"TrailerTemperatureC",
		"TrailerTemperatureD",
		"TrailerTemperatureE",
		"TrailerTemperatureF",
		"TrailerWeightA",
		"TrailerWeightC",
		"TrailerWeightD",
		"TrailerWeightF",
		"TrailerWeightG",
		"TrailerBrakePadsA",
		"TrailerBrakePadsB",
		"TrailerBrakePadsC",
		"TrailerBrakePadsD",
		"TrailerBrakePadsE",
		"TrailerBrakePadsF"
	]
	var file = File.new()
	db.path = db_name
	db.open_db()
	file.open(csv_path, file.READ)
	while ! file.eof_reached():
		var data_set = Array(file.get_csv_line())
		if len(data_set) == 1:
			continue
		var data_set_dict = {}
		for i in range(len(fields)):
			data_set_dict[fields[i]] = data_set[i]
		maindata.append(data_set_dict)
	file.close()
	db.delete_rows(tablename, "true")
	db.query("update sqlite_sequence set seq=0 where name='%s'" % tablename)
	db.insert_rows(tablename, maindata)
