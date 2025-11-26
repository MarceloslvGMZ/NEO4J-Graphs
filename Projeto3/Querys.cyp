//////POSTS POPULARES
MATCH (p:Post)
OPTIONAL MATCH (p)<-[l:LIKED]-()
OPTIONAL MATCH (p)<-[:ON_POST]-(:Comment)
WITH p, count(l) AS likes, count(*) AS comments
RETURN p.text, likes, comments, (likes + comments) AS score
ORDER BY score DESC;


////////INFLUENCIADORES
MATCH (u:User)<-[f:FOLLOWS]-()
RETURN u.name AS user, count(f) AS followers
ORDER BY followers DESC;

//////COMUNIDADES
CALL gds.pageRank.stream({
  nodeProjection: 'User',
  relationshipProjection: {FOLLOWS:{type:'FOLLOWS', orientation:'NATURAL'}}
})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS user, score
ORDER BY score DESC;

///////////TEMAS ENGAJADOS
MATCH (p:Post)-[:HAS_TOPIC]->(t:Topic)
OPTIONAL MATCH (p)<-[l:LIKED]-()
OPTIONAL MATCH (p)<-[:ON_POST]-()
WITH t, count(l) AS likes, count(*) AS comments
RETURN t.name, likes + comments AS engagement
ORDER BY engagement DESC;

///////////RECOMENDAR USUARIOS
MATCH (u:User {id:$id})-[:FOLLOWS]->(friend)-[:FOLLOWS]->(suggestion)
WHERE NOT (u)-[:FOLLOWS]->(suggestion)
RETURN DISTINCT suggestion.name AS sug;
