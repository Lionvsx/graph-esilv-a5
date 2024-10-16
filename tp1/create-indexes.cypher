// Create index for User nodes
CREATE INDEX FOR (u:User) ON (u.id);

// Create index for Location nodes
CREATE INDEX FOR (l:Location) ON (l.id);