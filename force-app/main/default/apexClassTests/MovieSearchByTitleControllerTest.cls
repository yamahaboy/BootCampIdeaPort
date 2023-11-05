@isTest
private class MovieSearchByTitleControllerTest {
    @isTest
    static void testSearchMovie() {
        String mockResponse = '{"results": [{"id": 1, "title": "Test Movie"}]}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        List<tmdbSearchMovieResult> result = MovieSearchByTitleController.searchMovie('Test Movie');

        System.assertEquals(1, result.size());
        System.assertEquals('Test Movie', result[0].title);
    }

    @isTest
    static void testGetGenreIdByName() {
        String mockResponse = '{"genres": [{"id": 1, "name": "Action"}]}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        Map<String, Integer> genreIdByName = MovieSearchByTitleController.getGenreIdByName();

        System.assertEquals(1, genreIdByName.size());
        System.assertEquals(1, genreIdByName.get('Action'));
    }

    @isTest
    static void testGetGenreNameById() {
        String mockResponse = '{"genres": [{"id": 1, "name": "Action"}]}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        String genreName = MovieSearchByTitleController.getGenreNameById(1);

        System.assertEquals('Action', genreName);
    }


public class MockHttpResponseGenerator implements HttpCalloutMock {
    private String mockResponse;

    public MockHttpResponseGenerator(String mockResponse) {
        this.mockResponse = mockResponse;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(mockResponse);
        res.setStatusCode(200);
        return res;
    }
}

}
