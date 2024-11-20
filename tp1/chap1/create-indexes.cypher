// Create index for User nodes
CREATE INDEX IF NOT EXISTS FOR (u:User) ON (u.id);

CREATE INDEX IF NOT EXISTS FOR (u:User) on u.country;