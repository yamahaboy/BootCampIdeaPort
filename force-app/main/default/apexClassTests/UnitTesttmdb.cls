@isTest
private class UnitTesttmdb {
    @isTest
    static void testGetMovieDetails() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Integer movieId = 123; 

        Test.startTest();
        tmdb tmdbInstance = new tmdb();
        tmdbMovieDetailsResponse response = tmdbInstance.getMovieDetails(movieId);
        Test.stopTest();

        System.assertNotEquals(null, response);
        System.assertEquals('Another overview', response.overview);
        System.assertEquals('Another title', response.original_title);
        System.assertEquals(500000, response.revenue);
        System.assertEquals(8, response.vote_average);
        System.assertEquals('/path/to/another/poster', response.poster_path);
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"overview": "Another overview", "original_title": "Another title", "revenue": 500000, "vote_average": 8, "poster_path": "/path/to/another/poster", "budget": 300000, "release_date": "2023-02-15"}');
            res.setStatusCode(200);
            return res;
        }
    }
}
