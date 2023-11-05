@isTest
private class TestMovieImportJSON {
    @isTest
    static void testImportMoviesWithMockHTTP() {
        Script__c testScript1 = new Script__c(
            Description__c = 'Test description 1'
        );
        insert testScript1;

        Script__c testScript2 = new Script__c(
            Description__c = 'Test description 2'
        );
        insert testScript2;

        String jsonData = '[{"id":"1","name":"Avatar","tmdb_id":"19995","genre":"Action;Adventure;Fantasy;Science_Fiction","rating":7.2,"budget":237000000,"revenue":2787965087,"script":{"id":"1","description":"In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora on a unique mission, but becomes torn between following orders and protecting an alien civilization."}},'
                      + '{"id":"2","name":"Pirates of the Caribbean: At World\'s End","tmdb_id":"285","genre":"Adventure;Fantasy;Action","rating":6.9,"budget":300000000,"revenue":961000000,"script":{"id":"2","description":"Captain Barbossa, long believed to be dead, has come back to life and is headed to the edge of the Earth with Will Turner and Elizabeth Swann. But nothing is quite as it seems."}}]';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();

        MovieImportJSON movieImporter = new MovieImportJSON();
        movieImporter.importMovies(jsonData);

        Test.stopTest();

        List<MovieObject__c> insertedMovies = [SELECT Id, Title__c, Genre__c, Script__c FROM MovieObject__c];
        System.assertEquals(2, insertedMovies.size(), 'Number of inserted movies is incorrect');

    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"key":"value"}'); 
            
            return res;
        }
    }
}
