@isTest
private class MovieCatalogFilterControllerTest {

    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success", "data": ["Action", "Adventure", "Animation", "Comedy", "Crime", "Drama", "Family", "Fantasy", "History", "Horror", "Mystery", "Romance", "Science Fiction", "Thriller", "War", "Western"]}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testGetAllGenres() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        Test.startTest();

        List<String> genres = MovieCatalogFilterController.getAllGenres();

        Test.stopTest();

        System.assertEquals(16, genres.size(), 'Unexpected number of genres');
        System.assertEquals('Action', genres[0], 'Incorrect genre at index 0');
        System.assertEquals('Adventure', genres[1], 'Incorrect genre at index 1');
        System.assertEquals('Western', genres[15], 'Incorrect genre at index 15');
    }
}
