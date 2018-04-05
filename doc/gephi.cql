Example
You can export your graph as an unweighted network.

match path = (:Person)-[:ACTED_IN]->(:Movie)
WITH path LIMIT 1000
with collect(path) as paths
call apoc.gephi.add(null,'workspace0', paths) yield nodes, relationships, time
return nodes, relationships, time
You can export your graph as a weighted network, by specifying the property of a relationship, that holds the weight value.

match path = (:Person)-[r:ACTED_IN]->(:Movie) where exists r.weightproperty
WITH path LIMIT 1000
with collect(path) as paths
call apoc.gephi.add(null,'workspace0', paths, 'weightproperty') yield nodes, relationships, time
return nodes, relationships, time
You can also export with your graph other properties of your nodes and/or relationship by adding an optional array with the property names you want to export. Example for exporting birthYear and role property.

match path = (:Person)-[r:ACTED_IN]->(:Movie) where exists r.weightproperty
WITH path LIMIT 1000
with collect(path) as paths
call apoc.gephi.add(null,'workspace0', paths, 'weightproperty',['birthYear', 'role']) yield nodes, relationships, time
return nodes, relationships, time



Used this script

MATCH path=(:Keyword)-->(:Dataset)-->(:Theme)
WITH path LIMIT 500000
with collect(path) as paths
call apoc.gephi.add(null,'workspace1', paths) yield nodes, relationships, time
return nodes, relationships, time


