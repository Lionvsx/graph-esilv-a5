// Calculate total neighbors (reviewed areas) for each top reviewer
MATCH (u:User {country: 'France'})-[r:review]->(a:Area_4)
WITH u, COUNT(DISTINCT a) AS totalNeighbors
RETURN u.id AS userId, totalNeighbors
ORDER BY totalNeighbors DESC


// ╒═══════╤══════════════╕
// │userId │totalNeighbors│
// ╞═══════╪══════════════╡
// │2639   │256           │
// ├───────┼──────────────┤
// │387312 │247           │
// ├───────┼──────────────┤
// │76     │187           │
// ├───────┼──────────────┤
// │70     │163           │
// ├───────┼──────────────┤
// .....