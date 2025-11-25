////////////Recomendação baseada em Gênero
MATCH (u:User {id:$userId})-[:LISTENED]->(t:Track)-[:IN_GENRE]->(g:Genre)
WITH u, g, count(*) AS score
ORDER BY score DESC
LIMIT 1
MATCH (g)<-[:IN_GENRE]-(rec:Track)
RETURN rec.title AS recomendacao, g.name AS genero

/////////////Recomendar Musicas de artistas seguidos
MATCH (u:User {id:$userId})-[:FOLLOWS]->(a:Artist)<-[:PERFORMED_BY]-(t:Track)
RETURN t.title AS recomendacao, a.name AS artista;

//////////// Musicas Similiares a que ele curtiu

MATCH (u:User {id:$userId})-[:LIKED]->(:Track)-[:IN_GENRE]->(g:Genre)
MATCH (rec:Track)-[:IN_GENRE]->(g)
RETURN DISTINCT rec.title AS recomendacao, g.name AS genero
ORDER BY rec.title;

