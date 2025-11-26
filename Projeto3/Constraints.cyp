///////CONSTRAINTS
CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT post_id IF NOT EXISTS FOR (p:Post) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT comment_id IF NOT EXISTS FOR (c:Comment) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT topic_name IF NOT EXISTS FOR (t:Topic) REQUIRE t.name IS UNIQUE;
CREATE CONSTRAINT hashtag_name IF NOT EXISTS FOR (h:Hashtag) REQUIRE h.name IS UNIQUE;

//////TOPICS
UNWIND ["Tech", "Music", "Sports", "Movies", "Politics"] AS t
CREATE (:Topic {name:t});


///////HASHTAGS
UNWIND ["#AI", "#Rock", "#Football", "#Cinema", "#News"] AS h
CREATE (:Hashtag {name:h});


///////////USERS
UNWIND range(1,10) AS id
CREATE (:User {id:id, name:"User " + id});

/////////////POSTS
UNWIND [
  {id:1, text:"Post sobre AI", topic:"Tech", hashtag:"#AI"},
  {id:2, text:"Gosto de Rock", topic:"Music", hashtag:"#Rock"},
  {id:3, text:"Jogo de ontem!", topic:"Sports", hashtag:"#Football"},
  {id:4, text:"Filme incrível", topic:"Movies", hashtag:"#Cinema"},
  {id:5, text:"Notícias da semana", topic:"Politics", hashtag:"#News"}
] AS postData
CREATE (p:Post {id:postData.id, text:postData.text})
WITH p, postData
MATCH (t:Topic {name:postData.topic})
MATCH (h:Hashtag {name:postData.hashtag})
CREATE (p)-[:HAS_TOPIC]->(t)
CREATE (p)-[:HAS_HASHTAG]->(h);


//////////RELACIONAR USUARIOS
MATCH (u:User), (p:Post)
WHERE u.id = p.id
CREATE (u)-[:POSTED]->(p);


///////////////COMENTARIOS
UNWIND [
  {id:1, user:2, post:1, text:"Muito bom!"},
  {id:2, user:3, post:1, text:"Concordo"},
  {id:3, user:4, post:2, text:"Rock é vida"},
  {id:4, user:5, post:3, text:"Grande jogo!"}
] AS cData
CREATE (c:Comment {id:cData.id, text:cData.text})
WITH c, cData
MATCH (u:User {id:cData.user})
MATCH (p:Post {id:cData.post})
CREATE (u)-[:COMMENTED]->(c)
CREATE (c)-[:ON_POST]->(p);

/////// LIKES
MATCH (u:User),(p:Post)
WHERE rand() < 0.3
CREATE (u)-[:LIKED]->(p);


////////FOLLOWERS
MATCH (u1:User),(u2:User)
WHERE u1 <> u2 AND rand() < 0.15
CREATE (u1)-[:FOLLOWS]->(u2);

