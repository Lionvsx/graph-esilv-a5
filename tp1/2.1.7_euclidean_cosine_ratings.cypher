// Find top French reviewers by total reviews and distinct areas
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, SUM(r.NB) AS totalReviews, COUNT(DISTINCT a) AS distinctAreas
WITH u, totalReviews, distinctAreas
ORDER BY totalReviews DESC, distinctAreas DESC
LIMIT 4
WITH COLLECT({user: u, total: totalReviews, distinct: distinctAreas}) AS topReviewers

// Process both pairs
WITH topReviewers[0].user AS topTotalUser1,
     topReviewers[1].user AS topTotalUser2,
     topReviewers[2].user AS topDistinctUser1,
     topReviewers[3].user AS topDistinctUser2

// Calculate similarities for both pairs
UNWIND [
  {type: 'Total Reviews', u1: topTotalUser1.id, u2: topTotalUser2.id},
  {type: 'Distinct Areas', u1: topDistinctUser1.id, u2: topDistinctUser2.id}
] AS pair
MATCH (u1:User {id: pair.u1})-[r1:review]->(a:Area_4)<-[r2:review]-(u2:User {id: pair.u2})
WITH pair, COLLECT({rating1: toFloat(r1.rating), rating2: toFloat(r2.rating)}) AS commonReviews

// Calculate Euclidean distance and Cosine similarity
WITH pair, commonReviews,
     SQRT(REDUCE(s = 0.0, r IN commonReviews | s + (r.rating1 - r.rating2)^2)) AS euclideanDistance,
     CASE SIZE(commonReviews)
       WHEN 0 THEN null
       ELSE REDUCE(dot = 0.0, r IN commonReviews | dot + r.rating1 * r.rating2) / 
            (SQRT(REDUCE(s = 0.0, r IN commonReviews | s + r.rating1^2)) * 
             SQRT(REDUCE(s = 0.0, r IN commonReviews | s + r.rating2^2)))
     END AS cosineSimilarity

// Return results
RETURN 
  pair.type AS userPair,
  pair.u1 AS user1Id, 
  pair.u2 AS user2Id,
  euclideanDistance,
  cosineSimilarity,
  SIZE(commonReviews) AS commonReviewsCount
ORDER BY userPair