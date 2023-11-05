@isTest
private class TestMovieObjectTrigger {
    @isTest
    static void testTrigger() {
        List<MovieObject__c> testMovies = new List<MovieObject__c>();
        for (Integer i = 0; i < 5; i++) {
            MovieObject__c movie = new MovieObject__c(
                Title__c = 'TestMovie' + i,
                Genre__c = 'Action',
                Budget__c = 5000,
                tmdbId__c = 174 + i
            );
            testMovies.add(movie);
        }

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        insert testMovies;
        Test.stopTest();

        List<MovieObject__c> updatedMovies = [SELECT Id, Title__c FROM MovieObject__c WHERE Id IN :testMovies];
        System.assertEquals(testMovies.size(), updatedMovies.size(), 'Number of records should be the same');
        for (Integer i = 0; i < updatedMovies.size(); i++) {
            for (Integer j = 0; j < updatedMovies.size(); j++) {
                System.assertEquals('Another title', updatedMovies[i].Title__c, 'Title should be set correctly');
            }
        }
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String responseBody = '{"overview": "Another overview", "original_title": "Another title", "revenue": 200000, "vote_average": 4, "poster_path": "/path/to/another/poster", "budget": 300000}';
            
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
}
