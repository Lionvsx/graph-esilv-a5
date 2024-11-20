// For top reviewers by total reviews
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
MATCH (u1)-[r1:review]->(a:Area_4)<-[r2:review]-(u2)
WITH u1, u2, 
     COLLECT({areaId: a.gid, NB: toFloat(r1.NB), rating: toFloat(r1.rating)}) AS commonReviews1,
     COLLECT({areaId: a.gid, NB: toFloat(r2.NB), rating: toFloat(r2.rating)}) AS commonReviews2

WITH u1, u2, commonReviews1, commonReviews2,
     gds.similarity.euclidean(
       [x IN commonReviews1 | x.NB],
       [y IN commonReviews2 | y.NB]
     ) AS euclideanDistanceNB,
     gds.similarity.cosine(
       [x IN commonReviews1 | x.NB],
       [y IN commonReviews2 | y.NB]
     ) AS cosineSimilarityNB,
     gds.similarity.euclidean(
       [x IN commonReviews1 | x.rating],
       [y IN commonReviews2 | y.rating]
     ) AS euclideanDistanceRating,
     gds.similarity.cosine(
       [x IN commonReviews1 | x.rating],
       [y IN commonReviews2 | y.rating]
     ) AS cosineSimilarityRating

RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistanceNB, cosineSimilarityNB,
       euclideanDistanceRating, cosineSimilarityRating

UNION

// For top reviewers by distinct areas
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, COUNT(DISTINCT a) AS distinctAreas
ORDER BY distinctAreas DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
MATCH (u1)-[r1:review]->(a:Area_4)<-[r2:review]-(u2)
WITH u1, u2, 
     COLLECT({areaId: a.gid, NB: toFloat(r1.NB), rating: toFloat(r1.rating)}) AS commonReviews1,
     COLLECT({areaId: a.gid, NB: toFloat(r2.NB), rating: toFloat(r2.rating)}) AS commonReviews2

WITH u1, u2, commonReviews1, commonReviews2,
     gds.similarity.euclidean(
       [x IN commonReviews1 | x.NB],
       [y IN commonReviews2 | y.NB]
     ) AS euclideanDistanceNB,
     gds.similarity.cosine(
       [x IN commonReviews1 | x.NB],
       [y IN commonReviews2 | y.NB]
     ) AS cosineSimilarityNB,
     gds.similarity.euclidean(
       [x IN commonReviews1 | x.rating],
       [y IN commonReviews2 | y.rating]
     ) AS euclideanDistanceRating,
     gds.similarity.cosine(
       [x IN commonReviews1 | x.rating],
       [y IN commonReviews2 | y.rating]
     ) AS cosineSimilarityRating

RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistanceNB, cosineSimilarityNB,
       euclideanDistanceRating, cosineSimilarityRating