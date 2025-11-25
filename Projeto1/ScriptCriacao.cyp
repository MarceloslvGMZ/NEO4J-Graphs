CREATE (Genre)<-[:IN_GENRE]-(Serie)<-[:Watched {rating}]-()-[:Watched {rating}]->(Movie)-[:IN_GENRE]->(Genre),
(Movie)<-[:DIRECTED]-()-[:DIRECTED]->(Serie)<-[:ACTING_IN]-()-[:ACTING_IN]->(Movie)
