import { Driver } from "neo4j-driver";
import neo4j from "neo4j-driver";
import dotenv from "dotenv";

dotenv.config();

const uri = process.env.NEO4J_URI;
const user = process.env.NEO4J_USER;
const password = process.env.NEO4J_PASSWORD;

if (!uri || !user || !password) {
  throw new Error("Missing Neo4j connection details in environment variables");
}

export const driver: Driver = neo4j.driver(
  uri,
  neo4j.auth.basic(user, password)
);

export function closeDriver() {
  driver.close();
}

// Close the driver when the process exits
process.on("exit", closeDriver);
