//////////////////////////////////////////////////////////////////////////////////
// Create Nodes and edges using apoc stored procedure

WITH "https://data.nasa.gov/data.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.dataset AS dbs
//Split the spatial on space in order to create latitude and longitude properties
// The field is split on spaces and commas, this works but does have some issues
WITH dbs, apoc.text.split(dbs.spatial, "[\\s,+]",3) AS geo
//Create dataset node and set properties
MERGE (dataset:Dataset {name:dbs.identifier}) ON CREATE
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

// My attempt to create a new relationship without rerunning the entire code
// I noticed that there was a item calle "isPartOf" on some of the entries
// This was to show the dataset was part of a larger dataset
// I need to create a new realtionship in the DB
FOREACH(ignoreMe IN CASE WHEN trim(dbs.isPartOf) <> " " THEN [1] ELSE [] END | MERGE (aggregated_dataset:Dataset {name:dbs.isPartOf}) MERGE (dataset)-[:isPartOf]->(aggregated_dataset))



//Create contact point node and set property
MERGE (contactPoint:ContactPoint {name:dbs.contactPoint.fn}) ON CREATE 
	SET contactPoint.email = dbs.contactPoint.hasEmail
// Create the relationship betweem the dataset and Point of Contact
MERGE (dataset)-[:ForInfoContact]->(contactPoint)

// ForEach creates nodes for each value in the item, then creates relationships
FOREACH (keyWord in dbs.keyword | MERGE (keyword:Keyword {name:keyWord}) MERGE (keyword)-[:KEYWORD_IN]->(dataset))

FOREACH(pub in dbs.publisher.name | MERGE (publisher:Publisher {name:pub}) MERGE (publisher)-[:PUBLISHED]->(dataset))

FOREACH(pubParent in dbs.publisher.subOrganizationOf.name | MERGE (parent:PublisherParent {name:pubParent}) MERGE (publisher)-[:subOrganizationOf]->(parent))
FOREACH(pubParent2 in dbs.publisher.subOrganizationOf.subOrganizationOf.name | MERGE (grandparent:PublisherGrandParent {name:pubParent2}) MERGE (parent)-[:subOrganizationOf]->(grandparent))

FOREACH(t in dbs.theme | MERGE (theme:Theme {name:t}) MERGE (dataset)-[:IN_THEME]->(theme) MERGE (keyword)-[:IN_THEME]->(theme))




/////////////////////////////////////////////
// Do not run with import script ///////////
// Closeness Centrality Procedure
MATCH (keyword:Keyword)
WHERE keyword.id %2 = 0
WITH collect(keyword) AS nodes
CALL apoc.algo.closeness(['TYPE'],nodes,'INCOMING') YIELD keyword, score
RETURN keyword, score
ORDER BY score DESC