MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, COUNT(DISTINCT a) AS distinctAreas
ORDER BY distinctAreas DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
MATCH (u1)-[:review]->(a1:Area_4)
MATCH (u2)-[:review]->(a2:Area_4)
WITH u1, u2, COLLECT(DISTINCT a1) AS areas1, COLLECT(DISTINCT a2) AS areas2
WITH u1, u2, areas1, areas2,
     [x IN areas1 WHERE x IN areas2] AS intersection,
     areas1 + [x IN areas2 WHERE NOT x IN areas1] AS union
RETURN u1.id AS user1Id, u2.id AS user2Id,
       SIZE(intersection)*1.0 / SIZE(union) AS jaccardSimilarity
