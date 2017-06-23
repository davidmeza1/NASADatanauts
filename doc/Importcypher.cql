WITH "https://data.nasa.gov/data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword LIMIT 100

//Reads json file
WITH "file:///E:/Users/David/Documents/Neo4j/datanauts/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword

// For use on my MAC
WITH "file:///Users/dmeza/OneDrive/Github/NASAdatanauts/neo4j/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword



// Create Nodes and edges

WITH "file:///E:/Users/David/Documents/Neo4j/datanauts/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
MERGE (dataset:Dataset {id:dbs.identifier}) ON CREATE
	SET dataset.bureauCode = dbs.bureauCode, dataset.POC = dbs.contactPoint.fn, dataset.email = dbs.contactPoint.hasEmail,
	dataset.description = dbs.description, dataset.landingpage = dbs.landingpage, dataset.title = dbs.title

FOREACH (keyWord in dbs.keyword | MERGE (keyword:Keyword {name:keyWord}) MERGE (keyword)-[:KEYWORD_IN]->(dataset))

FOREACH(p in dbs.publisher.name | MERGE (publisher:Publisher {name:p}) MERGE (publisher)-[:PUBLISHED]->(dataset))
FOREACH(t in dbs.theme | MERGE (theme:Theme {name:t}) MERGE (dataset)-[:IN_THEME]->(theme))

// For use on my MAC
WITH "file:///Users/dmeza/OneDrive/Github/NASAdatanauts/neo4j/import/nasa_data.json" AS url
CALL apoc.load.json(urFOREACH(d in dbs.isPartOf | MERGE (data:Dataset {id:d}) MERGE (dataset)-[:IS_PART_OF]->(data))
l) YIELD value
UNWIND value.dataset AS dbs
MERGE (dataset:Dataset {id:dbs.identifier}) ON CREATE
	SET dataset.bureauCode = dbs.bureauCode, dataset.POC = dbs.contactPoint.fn, dataset.email = dbs.contactPoint.hasEmail,
	dataset.description = dbs.description, dataset.landingpage = dbs.landingpage, dataset.title = dbs.title

FOREACH (keyWord in dbs.keyword | MERGE (keyword:Keyword {name:keyWord}) MERGE (keyword)-[:KEYWORD_IN]->(dataset))

FOREACH(p in dbs.publisher.name | MERGE (publisher:Publisher {name:p}) MERGE (publisher)-[:PUBLISHED]->(dataset))
FOREACH(t in dbs.theme | MERGE (theme:Theme {name:t}) MERGE (dataset)-[:IN_THEME]->(theme))


// Closeness Centrality Procedure
MATCH (keyword:Keyword)
WHERE keyword.id %2 = 0
WITH collect(keyword) AS nodes
CALL apoc.algo.closeness(['TYPE'],nodes,'INCOMING') YIELD keyword, score
RETURN keyword, score
ORDER BY score DESC