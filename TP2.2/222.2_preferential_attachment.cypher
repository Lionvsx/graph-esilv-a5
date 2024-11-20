// Step 1: Calculate the degree (number of unique areas) for user 70
MATCH (u1:User {id: 70})-[:review]->(a1:Area_4)
WITH u1, COUNT(DISTINCT a1) AS degree1

// Step 2: Calculate the degree (number of unique areas) for user 76
MATCH (u2:User {id: 76})-[:review]->(a2:Area_4)
WITH u1, u2, degree1, COUNT(DISTINCT a2) AS degree2

// Step 3: Compute the preferential attachment score and return the result
RETURN u1.id AS user1, u2.id AS user2, degree1 * degree2 AS preferentialAttachmentScore


// ╒═════╤═════╤═══════════════════════════╕
// │user1│user2│preferentialAttachmentScore│
// ╞═════╪═════╪═══════════════════════════╡
// │70   │76   │30481                      │
// └─────┴─────┴───────────────────────────┘