/////////////////////////////////////////////////////////////////////////
// 1) CONSTRAINTS
/////////////////////////////////////////////////////////////////////////

CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT movie_id IF NOT EXISTS FOR (m:Movie) REQUIRE m.id IS UNIQUE;
CREATE CONSTRAINT series_id IF NOT EXISTS FOR (s:Series) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT genre_name IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;
CREATE CONSTRAINT actor_id IF NOT EXISTS FOR (a:Actor) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT director_id IF NOT EXISTS FOR (d:Director) REQUIRE d.id IS UNIQUE;

/////////////////////////////////////////////////////////////////////////
// 2) GENRES
/////////////////////////////////////////////////////////////////////////

UNWIND ["Action","Drama","Comedy","Sci-Fi","Thriller"] AS g
CREATE (:Genre {name:g});

/////////////////////////////////////////////////////////////////////////
// 3) ACTORS (10)
/////////////////////////////////////////////////////////////////////////

UNWIND range(1,10) AS i
CREATE (:Actor {id:i, name:"Actor " + i});

/////////////////////////////////////////////////////////////////////////
// 4) DIRECTORS (5)
/////////////////////////////////////////////////////////////////////////

UNWIND range(1,5) AS i
CREATE (:Director {id:i, name:"Director " + i});

/////////////////////////////////////////////////////////////////////////
// 5) USERS (10)
/////////////////////////////////////////////////////////////////////////

UNWIND range(1,10) AS i
CREATE (:User {id:i, name:"User " + i});

/////////////////////////////////////////////////////////////////////////
// 6) MOVIES (5)
/////////////////////////////////////////////////////////////////////////

UNWIND [
  {id:1, title:"Movie A", year:2020, genres:["Action","Thriller"]},
  {id:2, title:"Movie B", year:2022, genres:["Drama"]},
  {id:3, title:"Movie C", year:2019, genres:["Comedy"]},
  {id:4, title:"Movie D", year:2021, genres:["Sci-Fi","Action"]},
  {id:5, title:"Movie E", year:2018, genres:["Drama","Thriller"]}
] AS m
CREATE (movie:Movie {id:m.id, title:m.title, year:m.year})
WITH movie, m
UNWIND m.genres AS g
MATCH (genre:Genre {name:g})
CREATE (movie)-[:IN_GENRE]->(genre);

/////////////////////////////////////////////////////////////////////////
// 7) SERIES (5)
/////////////////////////////////////////////////////////////////////////

UNWIND [
  {id:1, title:"Series A", seasons:2, genres:["Drama"]},
  {id:2, title:"Series B", seasons:1, genres:["Action","Sci-Fi"]},
  {id:3, title:"Series C", seasons:3, genres:["Comedy"]},
  {id:4, title:"Series D", seasons:1, genres:["Thriller"]},
  {id:5, title:"Series E", seasons:4, genres:["Sci-Fi"]}
] AS s
CREATE (series:Series {id:s.id, title:s.title, seasons:s.seasons})
WITH series, s
UNWIND s.genres AS g
MATCH (genre:Genre {name:g})
CREATE (series)-[:IN_GENRE]->(genre);

/////////////////////////////////////////////////////////////////////////
// 8) RELACIONAMENTOS ACTING_IN
/////////////////////////////////////////////////////////////////////////


MATCH (m:Movie)
UNWIND range(1,3) AS i
MATCH (a:Actor {id:i})
CREATE (a)-[:ACTING_IN]->(m);

MATCH (s:Series)
UNWIND [4,5] AS i
MATCH (a:Actor {id:i})
CREATE (a)-[:ACTING_IN]->(s);

/////////////////////////////////////////////////////////////////////////
// 9) RELACIONAMENTOS DIRECTED
/////////////////////////////////////////////////////////////////////////

MATCH (m:Movie)
MATCH (d:Director)
WITH m, d ORDER BY m.id, d.id
WITH m, collect(d)[m.id] AS chosenDirector
CREATE (chosenDirector)-[:DIRECTED]->(m);

MATCH (s:Series)
MATCH (d:Director)
WITH s, d ORDER BY s.id, d.id
WITH s, collect(d)[s.id] AS chosenDirector
CREATE (chosenDirector)-[:DIRECTED]->(s);

/////////////////////////////////////////////////////////////////////////
// 10) WATCHED + RATING
/////////////////////////////////////////////////////////////////////////

MATCH (u:User), (m:Movie)
WHERE u.id <= 5 AND m.id IN [1,2,3]
CREATE (u)-[:WATCHED {rating: toInteger(rand()*5)+1}]->(m);

MATCH (u:User), (s:Series)
WHERE u.id > 5 AND s.id IN [1,2,3]
CREATE (u)-[:WATCHED {rating: toInteger(rand()*5)+1}]->(s);
