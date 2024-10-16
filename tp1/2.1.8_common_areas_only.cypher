// Function to calculate Euclidean distance
WITH function() {
  RETURN sqrt(sum((a.NB - b.NB)^2 for a in commonReviews1
               for b in commonReviews2
               where a.areaId = b.areaId))
} AS euclideanDistanceNB,
// Function to calculate Cosine similarity for NB
function() {
  RETURN sum(a.NB * b.NB for a in commonReviews1
             for b in commonReviews2
             where a.areaId = b.areaId) /
         (sqrt(sum(a.NB^2 for a in commonReviews1)) *
          sqrt(sum(b.NB^2 for b in commonReviews2)))
} AS cosineSimilarityNB,
// Function to calculate Euclidean distance for ratings
function() {
  RETURN sqrt(sum((a.rating - b.rating)^2 for a in commonReviews1
               for b in commonReviews2
               where a.areaId = b.areaId))
} AS euclideanDistanceRating,
// Function to calculate Cosine similarity for ratings
function() {
  RETURN sum(a.rating * b.rating for a in commonReviews1
             for b in commonReviews2
             where a.areaId = b.areaId) /
         (sqrt(sum(a.rating^2 for a in commonReviews1)) *
          sqrt(sum(b.rating^2 for b in commonReviews2)))
} AS cosineSimilarityRating

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
     COLLECT({areaId: a.gid, NB: r1.NB, rating: r1.rating}) AS commonReviews1,
     COLLECT({areaId: a.gid, NB: r2.NB, rating: r2.rating}) AS commonReviews2,
     euclideanDistanceNB, cosineSimilarityNB,
     euclideanDistanceRating, cosineSimilarityRating
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistanceNB() AS euclideanDistanceNB,
       cosineSimilarityNB() AS cosineSimilarityNB,
       euclideanDistanceRating() AS euclideanDistanceRating,
       cosineSimilarityRating() AS cosineSimilarityRating

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
     COLLECT({areaId: a.gid, NB: r1.NB, rating: r1.rating}) AS commonReviews1,
     COLLECT({areaId: a.gid, NB: r2.NB, rating: r2.rating}) AS commonReviews2,
     euclideanDistanceNB, cosineSimilarityNB,
     euclideanDistanceRating, cosineSimilarityRating
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistanceNB() AS euclideanDistanceNB,
       cosineSimilarityNB() AS cosineSimilarityNB,
       euclideanDistanceRating() AS euclideanDistanceRating,
       cosineSimilarityRating() AS cosineSimilarityRating