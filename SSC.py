#importation
import sqlite3
import os

#database creation
connection=sqlite3.connect("telemetry/telemetrydatabase.db")

#intialising cursor
cursor=connection.cursor()

#create table
sql = """CREATE TABLE IF NOT EXISTS Telemetry
                (PID INTEGER PRIMARY KEY AUTOINCREMENT,
                DATETIME VARCHAR,
                TRUCKTYREPA INT,
                TRUCKTYREPB INT,
                TRUCKTYREPC INT,
                TRUCKTYREPD INT,
                TRUCKTYREPE INT,
                TRUCKTYREPF INT,
                TRUCKBRAKEA INT,
                TRUCKBRAKEB INT,
                TRUCKWBTEMPA INT,
                TRUCKWBTEMPB INT,
                TRUCKWBTEMPD INT,
                TRUCKWBTEMPF INT,
                TRAILERTYREPA INT,
                TRAILERTYREPB INT,
                TRAILERTYREPC INT,
                TRAILERTYREPD INT,
                TRAILERTYREPE INT,
                TRAILERTYREPF INT,
                TRAILERTEMPA INT,
                TRAILERTEMPB INT,
                TRAILERTEMPC INT,
                TRAILERTEMPD INT,
                TRAILERTEMPE INT,
                TRAILERTEMPF INT,
                TRAILERWEIGHTA INT,
                TRAILERWEIGHTC INT,
                TRAILERWEIGHTD INT,
                TRAILERWEIGHTF INT,
                TRAILERWEIGHTG INT,
                TRAILERBRAKEA INT,
                TRAILERBRAKEB INT,
                TRAILERBRAKEC INT,
                TRAILERBRAKED INT,
                TRAILERBRAKEE INT,
                TRAILERBRAKEF INT)"""
cursor.execute(sql)

#populate table
data=open("telem.csv")
for i in range(4,244):
    row=data.readline(i)
    row=str(row)
    sqlcommand="INSERT INTO Telemetry (DATETIME, TRUCKTYREPA, TRUCKTYREPB, TRUCKTYREPC, TRUCKTYREPD, TRUCKTYREPE, TRUCKTYREPF, TRUCKBRAKE A, TRUCKBRAKEB, TRUCKWBTEMPA, TRUCKWBTEMPB, TRUCKWBTEMPD, TRUCKWBTEMPF, TRAILERTYREPA, TRAILERTYREPB, TRAILERTYREPC, TRAILERTYREPD, TRAILERTYREPE, TRAILERTYREPF, TRAILERTEMPA, TRAILERTEMPB, TRAILERTEMPC, TRAILERTEMPD, TRAILERTEMPE, TRAILERTEMPF, TRAILERWEIGHTA, TRAILERWEIGHTC, TRAILERWEIGHTD, TRAILERWIEGHTF, TRAILERWEIGHTG, TRAILERBRAKEA, TRAILERBRAKEB, TRAILERBRAKEC, TRAILERBRAKED, TRAILERBRAKEE, TRAILERBRAKEF) VALUES ("+row+")"
    sql=sqlcommand
    cursor.execute(sql)
    cursor.commit()

        

