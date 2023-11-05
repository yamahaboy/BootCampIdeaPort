@isTest
public with sharing class TestUpdateMovieObjectsRecords {
   @isTest
    static void testUpdateRecords(){
        List <MovieObject__c> movieObjects = new List<MovieObject__c>();
        movieObjects.add(new MovieObject__c(Title__c = 'TestMovie', Genre__c = 'Action', Budget__c= 5000, tmdbId__c = 124));

        insert movieObjects;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        updateMovieObjectsRecords.updateRecords(new List<String>{movieObjects[0].Id} );
        Test.stopTest();

        List<MovieObject__c> movies = [SELECT Id, tmdbId__c,Description__c, Title__c, Revenue__c,Raiting__c,PosterURL__c, TMDBSyncDate__c  FROM MovieObject__c WHERE Id IN :movieObjects];
        
        System.assertEquals('Another overview', movies[0].Description__c);
        System.assertEquals('Another title', movies[0].Title__c);
        System.assertEquals(200000, movies[0].Revenue__c);
        System.assertEquals(4, movies[0].Raiting__c);
        System.assertEquals('/path/to/another/poster', movies[0].PosterURL__c);
        System.assertEquals(Date.today(), movies[0].TMDBSyncDate__c);
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"overview": "Another overview", "original_title": "Another title", "revenue": 200000, "vote_average": 4, "poster_path": "/path/to/another/poster", "budget": 300000}');
            res.setStatusCode(200);
            return res;
        }

    }
}