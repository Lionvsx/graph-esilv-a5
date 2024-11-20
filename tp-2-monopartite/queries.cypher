// 3.1 Cypher Projection
// Create projection for French tourists in 2019
CALL gds.graph.project.cypher(
    'French2019',
    'MATCH (n:Area_4) RETURN id(n) AS id',
    'MATCH (n1:Area_4)-[r:trip]->(n2:Area_4) 
     WHERE r.year = 2019 AND r.country = "France" 
     RETURN id(n1) AS source, id(n2) AS target, r.NB AS weight'
);

// 3.2 Community Detection
// Triangle count per node
CALL gds.triangleCount.stream('French2019')
YIELD nodeId, triangleCount
RETURN gds.util.asNode(nodeId).name AS name, triangleCount
ORDER BY triangleCount DESC;

// Triangle count by department
CALL gds.triangleCount.stream('French2019')
YIELD nodeId, triangleCount
RETURN gds.util.asNode(nodeId).gid_2 AS department, 
       SUM(triangleCount) AS totalTriangles
ORDER BY totalTriangles DESC;

// Local clustering coefficient
CALL gds.localClusteringCoefficient.stream('French2019')
YIELD nodeId, clusteringCoefficient
RETURN gds.util.asNode(nodeId).name AS name, clusteringCoefficient
ORDER BY clusteringCoefficient DESC;

// Community detection using Label Propagation
CALL gds.labelPropagation.stream('French2019')
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).gid_2 AS department, communityId
ORDER BY department;

// Community detection using Louvain
CALL gds.louvain.stream('French2019')
YIELD nodeId, communityId
RETURN communityId, COUNT(nodeId) AS size
ORDER BY size DESC;

// 3.3 Path Finding
// All shortest paths based on NB
CALL gds.allShortestPaths.stream({
    nodeProjection: '*',
    relationshipProjection: {
        trip: {
            type: 'trip',
            properties: 'NB'
        }
    },
    relationshipWeightProperty: 'NB'
})
YIELD sourceNodeId, targetNodeId, totalCost
RETURN gds.util.asNode(sourceNodeId).name AS source, 
       gds.util.asNode(targetNodeId).name AS target, 
       totalCost
ORDER BY totalCost ASC;

// Minimum Spanning Tree from Paris 1st district
MATCH (start:Area_4 {name: 'Paris 1° arrondissement'})
CALL gds.spanningTree.minimum.stream('French2019', {
    startNodeId: id(start)
})
YIELD sourceNodeId, targetNodeId, cost
RETURN gds.util.asNode(sourceNodeId).name AS source, 
       gds.util.asNode(targetNodeId).name AS target, 
       cost;

// 3.4 Centrality Measures
// PageRank
CALL gds.pageRank.stream('French2019')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY score DESC;

// PageRank statistics
CALL gds.pageRank.stream('French2019')
YIELD score
RETURN AVG(score) AS avgScore, 
       MIN(score) AS minScore, 
       MAX(score) AS maxScore;

// Degree centrality
CALL gds.degree.stream('French2019')
YIELD nodeId, score AS degree
RETURN gds.util.asNode(nodeId).name AS name, degree
ORDER BY degree DESC;

// Betweenness centrality
CALL gds.betweenness.stream('French2019')
YIELD nodeId, score AS betweenness
RETURN gds.util.asNode(nodeId).name AS name, betweenness
ORDER BY betweenness DESC;

// Closeness centrality
CALL gds.closeness.stream('French2019')
YIELD nodeId, score AS closeness
RETURN gds.util.asNode(nodeId).name AS name, closeness
ORDER BY closeness DESC;