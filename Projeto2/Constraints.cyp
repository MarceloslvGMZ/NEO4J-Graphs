/////////////////////////////////////////////////////////////////////////
// 1) CONSTRAINTS
/////////////////////////////////////////////////////////////////////////

CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT track_id IF NOT EXISTS FOR (t:Track) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT artist_id IF NOT EXISTS FOR (a:Artist) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT genre_name IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;

/////////////////////////////////////////////////////////////////////////
// 2) GENRES
/////////////////////////////////////////////////////////////////////////

UNWIND ["Rock","Pop","HipHop","Jazz","Electronic"] AS g
CREATE (:Genre {name:g});

/////////////////////////////////////////////////////////////////////////
// 3) ARTISTS (5)
/////////////////////////////////////////////////////////////////////////

UNWIND [
  {id:1, name:"Artist A", genres:["Rock"]},
  {id:2, name:"Artist B", genres:["Pop"]},
  {id:3, name:"Artist C", genres:["HipHop"]},
  {id:4, name:"Artist D", genres:["Jazz"]},
  {id:5, name:"Artist E", genres:["Electronic"]}
] AS a
CREATE (ar:Artist {id:a.id, name:a.name})
WITH ar, a
UNWIND a.genres AS g
MATCH (genre:Genre {name:g})
CREATE (ar)-[:IN_GENRE]->(genre);

/////////////////////////////////////////////////////////////////////////
// 4) USERS (10)
/////////////////////////////////////////////////////////////////////////

UNWIND range(1,10) AS i
CREATE (:User {id:i, name:"User " + i});

/////////////////////////////////////////////////////////////////////////
// 5) TRACKS (10)
/////////////////////////////////////////////////////////////////////////

UNWIND [
  {id:1, title:"Track 1", artist:1, genre:"Rock"},
  {id:2, title:"Track 2", artist:1, genre:"Rock"},
  {id:3, title:"Track 3", artist:2, genre:"Pop"},
  {id:4, title:"Track 4", artist:2, genre:"Pop"},
  {id:5, title:"Track 5", artist:3, genre:"HipHop"},
  {id:6, title:"Track 6", artist:4, genre:"Jazz"},
  {id:7, title:"Track 7", artist:5, genre:"Electronic"},
  {id:8, title:"Track 8", artist:5, genre:"Electronic"},
  {id:9, title:"Track 9", artist:3, genre:"HipHop"},
  {id:10,title:"Track 10",artist:4, genre:"Jazz"}
] AS t
CREATE (tr:Track {id:t.id, title:t.title})
WITH tr, t
MATCH (ar:Artist {id:t.artist})
CREATE (tr)-[:PERFORMED_BY]->(ar)
WITH tr, t
MATCH (g:Genre {name:t.genre})
CREATE (tr)-[:IN_GENRE]->(g);

/////////////////////////////////////////////////////////////////////////
// 6) USER INTERACTIONS
/////////////////////////////////////////////////////////////////////////

// LISTENED
MATCH (u:User),(t:Track)
WHERE rand() < 0.25   // 25% das músicas por usuário
CREATE (u)-[:LISTENED {
    times: toInteger(rand()*50)+1,
    last_play: date() - duration({days: toInteger(rand()*30)})
}]->(t);

// LIKED (10% de chance)
MATCH (u:User),(t:Track)
WHERE rand() < 0.10
CREATE (u)-[:LIKED]->(t);

// FOLLOW ARTIST (20% de chance)
MATCH (u:User),(a:Artist)
WHERE rand() < 0.20
CREATE (u)-[:FOLLOWS]->(a);
