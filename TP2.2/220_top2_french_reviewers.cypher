// Get the top two French users with the highest number of reviews
MATCH (u:User {country: 'France'})-[r:review]->()
WITH u, SUM(r.NB) AS reviewCount
ORDER BY reviewCount DESC
LIMIT 2
RETURN collect(u.id) AS topUserIds


// ╒══════════╕
// │topUserIds│
// ╞══════════╡
// │[70, 76]  │
// └──────────┘