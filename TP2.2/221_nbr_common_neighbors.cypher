// Give the number of common neighbors between the two French who reviewed the most (seen before);
MATCH (u1:User {id: 70})-[:review]->(a:Area_4)<-[:review]-(u2:User {id: 76})
RETURN COUNT(DISTINCT a) as CommonNeighbors

// ╒═══════════════╕
// │CommonNeighbors│
// ╞═══════════════╡
// │27             │
// └───────────────┘