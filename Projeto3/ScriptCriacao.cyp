CREATE (Topic)<-[:INTERESTED_IN]-(User)-[:LIKED]->(Post)<-[:ON_POST]-()<-[:COMMENTED]-(User)-[:FOLLOWS]->(User)-[:POSTED]->(Post)-[:HAS_HASHTAG]->(),
(Post)-[:HAS_TOPIC]->(Topic)
