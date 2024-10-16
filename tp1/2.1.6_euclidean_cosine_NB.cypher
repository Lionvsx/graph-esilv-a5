// For top reviewers by total reviews
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
MATCH (u1)-[r1:review]->(a:Area_4)
MATCH (u2)-[r2:review]->(a:Area_4)
WITH u1, u2, 
     COLLECT({areaId: a.gid, NB: toFloat(r1.NB)}) AS reviews1,
     COLLECT({areaId: a.gid, NB: toFloat(r2.NB)}) AS reviews2
WITH u1, u2, reviews1, reviews2,
     SQRT(REDUCE(s = 0.0, r IN reviews1 |
       s + (r.NB - CASE WHEN r.areaId IN [rev IN reviews2 | rev.areaId] 
                        THEN [rev IN reviews2 WHERE rev.areaId = r.areaId | rev.NB][0]
                        ELSE 0.0 END)^2
     )) AS euclideanDistance,
     REDUCE(dotProduct = 0.0, r IN reviews1 |
       dotProduct + r.NB * CASE WHEN r.areaId IN [rev IN reviews2 | rev.areaId] 
                                THEN [rev IN reviews2 WHERE rev.areaId = r.areaId | rev.NB][0]
                                ELSE 0.0 END
     ) / (SQRT(REDUCE(s = 0.0, r IN reviews1 | s + r.NB^2)) * 
          SQRT(REDUCE(s = 0.0, r IN reviews2 | s + r.NB^2))) AS cosineSimilarity
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance AS euclideanDistance,
       cosineSimilarity AS cosineSimilarity

UNION

// For top reviewers by distinct areas
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, COUNT(DISTINCT a) AS distinctAreas
ORDER BY distinctAreas DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
MATCH (u1)-[r1:review]->(a:Area_4)
MATCH (u2)-[r2:review]->(a:Area_4)
WITH u1, u2, 
     COLLECT({areaId: a.gid, NB: toFloat(r1.NB)}) AS reviews1,
     COLLECT({areaId: a.gid, NB: toFloat(r2.NB)}) AS reviews2
WITH u1, u2, reviews1, reviews2,
     SQRT(REDUCE(s = 0.0, r IN reviews1 |
       s + (r.NB - CASE WHEN r.areaId IN [rev IN reviews2 | rev.areaId] 
                        THEN [rev IN reviews2 WHERE rev.areaId = r.areaId | rev.NB][0]
                        ELSE 0.0 END)^2
     )) AS euclideanDistance,
     REDUCE(dotProduct = 0.0, r IN reviews1 |
       dotProduct + r.NB * CASE WHEN r.areaId IN [rev IN reviews2 | rev.areaId] 
                                THEN [rev IN reviews2 WHERE rev.areaId = r.areaId | rev.NB][0]
                                ELSE 0.0 END
     ) / (SQRT(REDUCE(s = 0.0, r IN reviews1 | s + r.NB^2)) * 
          SQRT(REDUCE(s = 0.0, r IN reviews2 | s + r.NB^2))) AS cosineSimilarity
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance AS euclideanDistance,
       cosineSimilarity AS cosineSimilarity