// Function to calculate Euclidean distance
WITH function() {
  RETURN sqrt(sum((a.rating - b.rating)^2 for a in reviews1
               for b in reviews2
               where a.areaId = b.areaId))
} AS euclideanDistance,
// Function to calculate Cosine similarity
function() {
  RETURN sum(a.rating * b.rating for a in reviews1
             for b in reviews2
             where a.areaId = b.areaId) /
         (sqrt(sum(a.rating^2 for a in reviews1)) *
          sqrt(sum(b.rating^2 for b in reviews2)))
} AS cosineSimilarity

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
     COLLECT({areaId: a.gid, rating: r1.rating}) AS reviews1,
     COLLECT({areaId: a.gid, rating: r2.rating}) AS reviews2,
     euclideanDistance, cosineSimilarity
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance() AS euclideanDistance,
       cosineSimilarity() AS cosineSimilarity

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
     COLLECT({areaId: a.gid, rating: r1.rating}) AS reviews1,
     COLLECT({areaId: a.gid, rating: r2.rating}) AS reviews2,
     euclideanDistance, cosineSimilarity
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistance() AS euclideanDistance,
       cosineSimilarity() AS cosineSimilarity
