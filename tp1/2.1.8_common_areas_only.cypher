// Use GDS to create a graph projection
CALL gds.graph.project(
  'reviewGraph',
  ['User', 'Area_4'],
  {
    review: {
      type: 'review',
      properties: ['NB', 'rating']
    }
  }
)

// Function to calculate Euclidean distance
WITH gds.similarity.euclidean() AS euclideanDistance,
     gds.similarity.cosine() AS cosineSimilarity

// For top reviewers by total reviews
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 2
WITH COLLECT(u) AS topUsers

MATCH (u1:User) WHERE u1 IN topUsers
MATCH (u2:User) WHERE u2 IN topUsers AND u1.id < u2.id
CALL gds.similarity.euclidean.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'NB'
})
YIELD similarity AS euclideanDistanceNB
CALL gds.similarity.cosine.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'NB'
})
YIELD similarity AS cosineSimilarityNB
CALL gds.similarity.euclidean.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'rating'
})
YIELD similarity AS euclideanDistanceRating
CALL gds.similarity.cosine.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'rating'
})
YIELD similarity AS cosineSimilarityRating
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
CALL gds.similarity.euclidean.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'NB'
})
YIELD similarity AS euclideanDistanceNB
CALL gds.similarity.cosine.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'NB'
})
YIELD similarity AS cosineSimilarityNB
CALL gds.similarity.euclidean.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'rating'
})
YIELD similarity AS euclideanDistanceRating
CALL gds.similarity.cosine.stream('reviewGraph', {
  sourceNodeFilter: u1.id,
  targetNodeFilter: u2.id,
  relationshipWeightProperty: 'rating'
})
YIELD similarity AS cosineSimilarityRating
RETURN u1.id AS user1Id, u2.id AS user2Id,
       euclideanDistanceNB, cosineSimilarityNB,
       euclideanDistanceRating, cosineSimilarityRating

// Drop the graph projection
CALL gds.graph.drop('reviewGraph')