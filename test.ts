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

const driver: Driver = neo4j.driver(uri, neo4j.auth.basic(user, password));

// Test the connection
async function testConnection() {
  const session = driver.session();
  try {
    const result = await session.run("RETURN 1 AS num");
    console.log(
      "Connection to Neo4j successful:",
      result.records[0].get("num").toNumber()
    );
  } catch (error) {
    console.error("Error connecting to Neo4j:", error);
  } finally {
    await session.close();
  }
}

testConnection();
