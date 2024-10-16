MATCH (u1:User {id: 70})-[:review]->(a:Area_4)
WITH u1, COLLECT(DISTINCT id(a)) AS u1Areas
MATCH (u2:User {id: 76})-[:review]->(a:Area_4)
WITH u1, u1Areas, u2, COLLECT(DISTINCT id(a)) AS u2Areas
RETURN u1.id AS u1, u2.id AS u2,
       gds.similarity.jaccard(u1Areas, u2Areas) AS similarity;