@isTest
private class movieListControllerTest {
    @isTest
    static void testGetMovieList() {
        List<MovieObject__c> testMovies = new List<MovieObject__c>{
            new MovieObject__c(Title__c = 'Movie 1', Genre__c = 'Action', tmdbId__c = 303),
            new MovieObject__c(Title__c = 'Movie 2', Genre__c = 'Comedy', tmdbId__c = 301)
        };
        insert testMovies;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        List<MovieObject__c> result = movieListController.getMovieList();
        
        System.assertEquals(2, result.size());
        System.assertEquals('Movie 1', result[0].Title__c);
        System.assertEquals('Action', result[0].Genre__c);
        
        System.assertEquals('Movie 2', result[1].Title__c);
        System.assertEquals('Comedy', result[1].Genre__c);
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status": "success"}');
            response.setStatusCode(200);
            return response;
        }
    }
}
