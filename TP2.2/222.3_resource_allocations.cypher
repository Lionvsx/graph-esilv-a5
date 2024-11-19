// Compute Resource Allocation between two users with IDs 70 and 76
MATCH (u1:User {id: 70})-[:review]->(a:Area_4)<-[:review]-(u2:User {id: 76})
WITH u1, u2, a, COUNT(*) AS commonNeighbors
MATCH (a)<-[:review]-(z:User)
WITH u1, u2, a, commonNeighbors, COUNT(z) AS degreeOfNeighbor
RETURN u1.id AS user1, u2.id AS user2,
       SUM(1.0 / degreeOfNeighbor) AS resourceAllocationScore

// ╒═════╤═════╤═══════════════════════╕
// │user1│user2│resourceAllocationScore│
// ╞═════╪═════╪═══════════════════════╡
// │70   │76   │0.01035976793019038    │
// └─────┴─────┴───────────────────────┘