// Calculate Euclidean distance and Cosine similarity
MATCH (u1:User {country: 'France'})-[r1:review]->(a:Area_4)<-[r2:review]-(u2:User {country: 'France'})
WHERE u1.id < u2.id
WITH u1, u2, a, r1.rating AS rating1, r2.rating AS rating2
WITH u1, u2, 
     COLLECT({areaId: a.gid, rating1: rating1, rating2: rating2}) AS commonReviews,
     SQRT(SUM((rating1 - rating2)^2)) AS euclideanDistance,
     SUM(rating1 * rating2) / (SQRT(SUM(rating1^2)) * SQRT(SUM(rating2^2))) AS cosineSimilarity

// For top reviewers by total reviews
WITH u1, u2, euclideanDistance, cosineSimilarity,
     SIZE([(u1)-[:review]->() | 1]) AS totalReviews1,
     SIZE([(u2)-[:review]->() | 1]) AS totalReviews2
ORDER BY totalReviews1 + totalReviews2 DESC
LIMIT 1
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance AS euclideanDistance,
       cosineSimilarity AS cosineSimilarity

UNION

// For top reviewers by distinct areas
MATCH (u1:User {country: 'France'})-[r1:review]->(a:Area_4)<-[r2:review]-(u2:User {country: 'France'})
WHERE u1.id < u2.id
WITH u1, u2, a, r1.rating AS rating1, r2.rating AS rating2
WITH u1, u2, 
     COLLECT({areaId: a.gid, rating1: rating1, rating2: rating2}) AS commonReviews,
     SQRT(SUM((rating1 - rating2)^2)) AS euclideanDistance,
     SUM(rating1 * rating2) / (SQRT(SUM(rating1^2)) * SQRT(SUM(rating2^2))) AS cosineSimilarity,
     COUNT(DISTINCT a) AS distinctAreas
ORDER BY distinctAreas DESC
LIMIT 1
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance AS euclideanDistance,
       cosineSimilarity AS cosineSimilarity
