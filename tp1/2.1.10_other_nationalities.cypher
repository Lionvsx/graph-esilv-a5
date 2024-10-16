 
WITH ['British', 'American', 'Italian'] AS nationalities
UNWIND nationalities AS nationality
MATCH (u1:User {country: nationality})-[r1:review]->(a:Area_4)
WHERE r1.NB >= 5
WITH nationality, u1, COLLECT(DISTINCT a) AS areas1
MATCH (u2:User {country: nationality})-[r2:review]->(a:Area_4)
WHERE r2.NB >= 5 AND u1.id < u2.id
WITH nationality, u1, u2, areas1, COLLECT(DISTINCT a) AS areas2
WHERE SIZE(areas1) >= 5 AND SIZE(areas2) >= 5
WITH nationality, u1, u2, areas1, areas2,
     [x IN areas1 WHERE x IN areas2] AS intersection
WITH nationality, u1, u2,
     SIZE(intersection)*1.0 / SIZE(areas1 + [x IN areas2 WHERE NOT x IN areas1]) AS jaccard,
     SIZE(intersection)*1.0 / MIN(SIZE(areas1), SIZE(areas2)) AS overlap
RETURN nationality, AVG(jaccard) AS avgJaccard, AVG(overlap) AS avgOverlap