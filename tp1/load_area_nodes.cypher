CALL {
LOAD CSV WITH HEADERS FROM "file:/gadm36_4.csv" as l FIELDTERMINATOR "\t"
MERGE (loc:Area_4{gid:toInteger(l.gid),
gid_0:l.gid_0,name_0:l.name_0, gid_1:l.gid_1,name_1:l.name_1, gid_2:l.gid_2,name_2:l.name_2,
gid_3:l.gid_3,name_3:l.name_3, gid_4:l.gid_4,name_4:l.name_4})
};