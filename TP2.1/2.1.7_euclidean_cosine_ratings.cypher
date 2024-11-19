// Find top French reviewers by total reviews and distinct areas
MATCH (u:User {country: 'France'})
WITH u, 
     SIZE([(u)-[:review]->() | 1]) AS totalReviews,
     SIZE([(u)-[:review]->(:Area_4) | 1]) AS distinctAreas
WITH u, totalReviews, distinctAreas
ORDER BY totalReviews DESC, distinctAreas DESC
LIMIT 4
WITH COLLECT({user: u, total: totalReviews, distinct: distinctAreas}) AS topReviewers

// Process both pairs
WITH topReviewers[0].user AS topTotalUser1,
     topReviewers[1].user AS topTotalUser2,
     topReviewers[2].user AS topDistinctUser1,
     topReviewers[3].user AS topDistinctUser2

// Calculate similarities for total reviews pair
MATCH (topTotalUser1)-[r1:review]->(a:Area_4)<-[r2:review]-(topTotalUser2)
WITH topTotalUser1, topTotalUser2, topDistinctUser1, topDistinctUser2,
     COLLECT({rating1: toFloat(r1.rating), rating2: toFloat(r2.rating)}) AS totalCommonReviews

// Calculate similarities for distinct areas pair
MATCH (topDistinctUser1)-[r1:review]->(a:Area_4)<-[r2:review]-(topDistinctUser2)
WITH topTotalUser1, topTotalUser2, topDistinctUser1, topDistinctUser2,
     totalCommonReviews,
     COLLECT({rating1: toFloat(r1.rating), rating2: toFloat(r2.rating)}) AS distinctCommonReviews

// Calculate Euclidean distance and Cosine similarity for both pairs
WITH ['Total Reviews', 'Distinct Areas'] AS pairTypes,
     [totalCommonReviews, distinctCommonReviews] AS commonReviewsList,
     [topTotalUser1, topDistinctUser1] AS user1List,
     [topTotalUser2, topDistinctUser2] AS user2List
UNWIND RANGE(0, 1) AS i
WITH pairTypes[i] AS pairType,
     commonReviewsList[i] AS commonReviews,
     user1List[i] AS u1,
     user2List[i] AS u2
WITH pairType, u1, u2, commonReviews,
     SQRT(REDUCE(s = 0.0, r IN commonReviews | s + (r.rating1 - r.rating2)^2)) AS euclideanDistance,
     CASE SIZE(commonReviews)
       WHEN 0 THEN null
       ELSE REDUCE(dot = 0.0, r IN commonReviews | dot + r.rating1 * r.rating2) / 
            (SQRT(REDUCE(s = 0.0, r IN commonReviews | s + r.rating1^2)) * 
             SQRT(REDUCE(s = 0.0, r IN commonReviews | s + r.rating2^2)))
     END AS cosineSimilarity

// Return results
RETURN 
  pairType AS userPair,
  u1.id AS user1Id, 
  u2.id AS user2Id,
  euclideanDistance,
  cosineSimilarity,
  SIZE(commonReviews) AS commonReviewsCount
