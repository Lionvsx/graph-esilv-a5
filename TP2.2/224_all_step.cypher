// Get the top 10 Spanish reviewers based on total reviews (NB)
MATCH (u:User {country: 'Spain'})-[r:review]->()
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 10
WITH collect(u) AS topSpanishReviewers

// Step 1: Get the top 10 Spanish reviewers based on total reviews (NB)
MATCH (u:User {country: 'Spain'})-[r:review]->()
WITH u, SUM(r.NB) AS totalReviews
ORDER BY totalReviews DESC
LIMIT 10
WITH collect(u) AS topSpanishReviewers

// Step 2: Unwind the top Spanish reviewers to analyze each unique pair
UNWIND topSpanishReviewers AS u1
UNWIND topSpanishReviewers AS u2
WITH u1, u2 WHERE id(u1) < id(u2)  // Ensure each pair is unique

// Step 3: Find shared neighbors (common areas reviewed) and calculate Total Neighbors and Preferential Attachment
MATCH (u1)-[:review]->(a:Area_4)<-[:review]-(u2)
WITH u1, u2, COUNT(DISTINCT a) AS sharedNeighbors
MATCH (u1)-[:review]->(a1:Area_4)
WITH u1, u2, sharedNeighbors, COUNT(DISTINCT a1) AS degree1
MATCH (u2)-[:review]->(a2:Area_4)
WITH u1, u2, sharedNeighbors, degree1, COUNT(DISTINCT a2) AS degree2

// Step 4: Calculate Preferential Attachment
WITH u1, u2, sharedNeighbors, degree1, degree2, degree1 * degree2 AS preferentialAttachment

// Step 5: Calculate Resource Allocation and Adamic-Adar
// For each shared neighbor (a), compute its degree and use it for the scores
MATCH (u1)-[:review]->(a:Area_4)<-[:review]-(u2)
MATCH (a)<-[:review]-(z:User)
WITH u1, u2, sharedNeighbors, preferentialAttachment, degree1, degree2, a, COUNT(z) AS degreeOfNeighbor
WITH u1, u2, sharedNeighbors, preferentialAttachment, degree1, degree2, 
     SUM(1.0 / degreeOfNeighbor) AS resourceAllocationScore,
     SUM(1.0 / log10(degreeOfNeighbor + 1)) AS adamicAdarScore

// Return the results ordered by Adamic-Adar
RETURN u1.id AS user1, u2.id AS user2, 
       sharedNeighbors, 
       degree1 AS totalNeighbors1, 
       degree2 AS totalNeighbors2,
       preferentialAttachment, 
       resourceAllocationScore, 
       adamicAdarScore
ORDER BY adamicAdarScore DESC
LIMIT 10



// ╒══════╤══════╤═══════════════╤═══════════════╤═══════════════╤══════════════════════╤═══════════════════════╤══════════════════╕
// │user1 │user2 │sharedNeighbors│totalNeighbors1│totalNeighbors2│preferentialAttachment│resourceAllocationScore│adamicAdarScore   │
// ╞══════╪══════╪═══════════════╪═══════════════╪═══════════════╪══════════════════════╪═══════════════════════╪══════════════════╡
// │134651│164748│7              │38             │66             │2508                  │0.02901583737013988    │2.3904138207999215│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │67654 │164748│8              │21             │66             │1386                  │0.0022710842090112567  │2.151898149733214 │
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │355463│164748│7              │31             │66             │2046                  │0.002592044618390992   │1.9909392804831434│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │211248│679659│6              │76             │32             │2432                  │0.017487819441959516   │1.9065082900534576│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │355463│211248│6              │31             │76             │2356                  │0.0019875964738090925  │1.6224388088986763│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │1504  │251659│4              │17             │23             │391                   │0.0018027612962377595  │1.1413798052074673│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │211248│164748│4              │76             │66             │5016                  │0.001113179615120749   │1.0955163465680382│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │211248│251659│2              │76             │23             │1748                  │0.001008663106102023   │0.6010076682334213│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │164748│679659│2              │66             │32             │2112                  │0.0007391005458721216  │0.5794886403061741│
// ├──────┼──────┼───────────────┼───────────────┼───────────────┼──────────────────────┼───────────────────────┼──────────────────┤
// │134651│355463│2              │38             │31             │1178                  │0.0006734562547214683  │0.5578824966408672│
// └──────┴──────┴───────────────┴───────────────┴───────────────┴──────────────────────┴───────────────────────┴──────────────────┘