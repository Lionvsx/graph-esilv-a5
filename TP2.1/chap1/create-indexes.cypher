// Create index for User nodes
CREATE INDEX IF NOT EXISTS FOR (u:User) ON (u.id);

CREATE INDEX IF NOT EXISTS FOR (u:User) on u.country;

CREATE INDEX IF NOT EXISTS FOR (u:Area_4) on u.gid;

CREATE INDEX IF NOT EXISTS FOR (u:Area_4) on u.gid_4;