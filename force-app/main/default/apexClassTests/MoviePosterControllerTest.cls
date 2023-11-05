@isTest
public with sharing class MoviePosterControllerTest {
   @isTest
    static void testGetMoviePosterUrl() {
        MovieObject__c testMovie = new MovieObject__c(
            Name = 'Test Movie',
            PosterURL__c = '/test_poster.jpg',
            Genre__c = 'Action',
            tmdbId__c= 299
        );
        insert testMovie;

        HttpCalloutMock mock = new HttpCalloutMockImpl();

        Test.setMock(HttpCalloutMock.class, mock);

        String posterUrl = MoviePosterController.getMoviePosterUrl(testMovie.Id);

        String expectedUrl = 'https://image.tmdb.org/t/p/original' + testMovie.PosterURL__c;
        System.assertEquals(expectedUrl, posterUrl);
    }

    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"posterUrl": "/test_poster.jpg"}');
            response.setStatusCode(200);
            return response;
        }
    }
    
}


