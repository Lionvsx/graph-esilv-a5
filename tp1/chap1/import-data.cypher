MATCH (n)
RETURN LABELS(n) AS nodeType, COUNT(n) AS nodeCount
ORDER BY nodeCount DESC;