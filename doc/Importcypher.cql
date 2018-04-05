// Downloads info on the firs 100 items on the website
WITH "https://data.nasa.gov/data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword, keys(dbs) LIMIT 100

//Reads json file from tthe import file in the neo4j folder
// The neo4j folder is to large to be placed on github
WITH "file:///E:/Users/David/Documents/Neo4j/datanauts/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword

// For use on my MAC, same command different url structure
WITH "file:///Users/dmeza/OneDrive/Github/NASAdatanauts/neo4j/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
RETURN dbs.contactPoint, dbs.description, dbs.keyword



// Create Nodes and edges using apoc stored procedure

WITH "https://data.nasa.gov/data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
//Split the spatial on space in order to create latitude and longitude properties
WITH dbs, SPLIT(dbs.spatial, " ") AS geo
//Create dataset node and set properties
MERGE (dataset:Dataset {id:dbs.identifier}) ON CREATE
	SET dataset.oid = dbs.`_id.$oid`,
	dataset.type = dbs.`@type`,
	dataset.accessLevel = dbs.accessLevel,
	dataset.accrualPeriodicity = dbs.accrualPeriodicity,
	dataset.bureauCode = dbs.bureauCode,
	dataset.description = dbs.description,
	dataset.downloadURL = dbs.distribition.downloadURL,
	dataset.mediaType = dbs.distribition.mediaType,
	dataset.issued = dbs.issued,
	dataset.landingPage = dbs.landingPage,
	dataset.language = dbs.language,
	dataset.modified = dbs.modified,
	dataset.programCode = dbs.programCode,
	dataset.latitude = TOFLOAT(geo[0]),
	dataset.longitude = TOFLOAT(geo[1]),
	dataset.temporal = dbs.temporal,
	dataset.title = dbs.title,
	dataset.license = dbs.license

//Create contact point node and se property
MERGE (contactPoint:ContactPoint {name:dbs.contactPoint.fn}) ON CREATE 
SET contactPoint.email = dbs.contactPoint.hasEmail
// Create the relationship betweem the dataset and Point of Contact
MERGE (dataset)-[:ForInfoContact]->(contactPoint)

// ForEach creates nodes for each value in the item, then creates relationships
FOREACH (keyWord in dbs.keyword | MERGE (keyword:Keyword {name:keyWord}) MERGE (keyword)-[:KEYWORD_IN]->(dataset))

FOREACH(pub in dbs.publisher.name | MERGE (publisher:Publisher {name:pub}) MERGE (publisher)-[:PUBLISHED]->(dataset))

FOREACH(pubParent in dbs.publisher.subOrganizationOf | MERGE (parent:PublisherParent {name:pubParent}) MERGE (publisher)-[:subOrganizationOf]->(parent))
FOREACH(pubParent2 in dbs.publisher.subOrganizationOf.subOrganizationOf | MERGE (grandparent:PublisherGrandParent {name:pubParent2}) MERGE (parent)-[:subOrganizationOf]->(grandparent))

FOREACH(t in dbs.theme | MERGE (theme:Theme {name:t}) MERGE (dataset)-[:IN_THEME]->(theme) MERGE (keyword)-[:IN_THEME]->(theme))

// For use on my MAC
WITH "file:///Users/dmeza/OneDrive/Github/NASAdatanauts/neo4j/import/nasa_data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
WITH dbs, SPLIT(dbs.spatial, " ") AS geo
MERGE (dataset:Dataset {id:dbs.identifier}) ON CREATE
	SET dataset.oid = dbs._id.$oid,
	dataset.type = dbs.@type,
	dataset.accessLevel = dbs.accessLevel,
	dataset.accrualPeriodicity = dbs.accrualPeriodicity,
	dataset.bureauCode = dbs.bureauCode,
	dataset.description = dbs.description,
	dataset.downloadURL = dbs.distribition.downloadURL,
	dataset.mediaType = dbs.distribition.mediaType,
	dataset.issued = dbs.issued,
	dataset.landingPage = dbs.landingPage,
	dataset.language = dbs.language,
	dataset.modified = dbs.modified,
	dataset.programCode = dbs.programCode,
	dataset.latitude = TOFLOAT(geo[0]),
	dataset.longitude = TOFLOAT(geo[1]),
	dataset.temporal = dbs.temporal,
	dataset.title = dbs.title,
	dataset.license = dbs.license

MERGE (contactPoint:ContactPoint {name:dbs.contactPoint.fn}) ON CREATE 
SET contactPoint.email = dbs.contactPoint.hasEmail

MERGE (dataset)-[:ForInfoContact]->(contactPoint))

FOREACH (keyWord in dbs.keyword | MERGE (keyword:Keyword {name:keyWord}) MERGE (keyword)-[:KEYWORD_IN]->(dataset))

FOREACH(pub in dbs.publisher.name | MERGE (publisher:Publisher {name:pub}) MERGE (publisher)-[:PUBLISHED]->(dataset))

FOREACH(pubParent in dbs.publisher.subOrganizationOf | MERGE (parent:PublisherParent {name:pubParent}) MERGE (publisher)-[:subOrganizationOf]->(parent))
FOREACH(pubParent2 in dbs.publisher.subOrganizationOf.subOrganizationOf | MERGE (grandparent:PublisherGrandParent {name:pubParent2}) MERGE (parent)-[:subOrganizationOf]->(grandparent))

FOREACH(t in dbs.theme | MERGE (theme:Theme {name:t}) MERGE (dataset)-[:IN_THEME]->(theme)) MERGE (keyword)-[:IN_THEME]->(theme)



// Closeness Centrality Procedure
MATCH (keyword:Keyword)
WHERE keyword.id %2 = 0
WITH collect(keyword) AS nodes
CALL apoc.algo.closeness(['TYPE'],nodes,'INCOMING') YIELD keyword, score
RETURN keyword, score
ORDER BY score DESC


