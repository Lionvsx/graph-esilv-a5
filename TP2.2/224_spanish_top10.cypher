// Get the top 10 Spanish reviewers based on total reviews (NB)
MATCH (u:User {country: 'Spain'})-[r:review]->()
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 10
WITH collect(u) AS topSpanishReviewers
RETURN topSpanishReviewers

// check 224_spanish_top10.json