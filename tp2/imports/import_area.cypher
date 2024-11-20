CALL {
LOAD CSV WITH HEADERS FROM "file:/gadm36.csv" as l FIELDTERMINATOR "\t"
MATCH (loc:Area_4{gid:toInteger(l.gid)})
SET
loc.gid_0=l.gid_0, loc.name_0=l.name_0, loc.gid_1=l.gid_1, loc.name_1=l.name_1,
loc.gid_2=l.gid_2,loc.name_2=l.name_2, loc.gid_3=l.gid_3,loc.name_3=l.name_3,
loc.gid_4=l.gid_4, loc.name_4=l.name_4, loc.lat=l.centroidlat, loc.long=l.centroidlong
};