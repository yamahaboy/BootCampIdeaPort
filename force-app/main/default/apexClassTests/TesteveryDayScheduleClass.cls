@isTest
private class TesteveryDayScheduleClass {
    @isTest
    static void testMovieScheduler() {
       
        Script__c testScript = new Script__c(Name = 'Test Script',Title__c = 'Test', Genre__c= 'Action' );
        insert testScript;
        MovieObject__c movieForTest1 = new MovieObject__c();
        movieForTest1.Title__c = 'Test Movie';
        movieForTest1.tmdbId__c = 23;
        movieForTest1.Script__c = testScript.Id; 
        movieForTest1.Budget__c = 1000;
        movieForTest1.Genre__c = 'Action';
        movieForTest1.PlannedProductionStartDate__c = Date.today().addMonths(-1);
        movieForTest1.Raiting__c = 5; 
        insert movieForTest1;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
 
        Test.startTest();
        String scheduleExpression = '0 0 0 * * ?';
        String jobId = System.schedule('MovieObj', scheduleExpression, new everyDayScheduleClass()); 
        Test.stopTest();

        System.abortJob(jobId);
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
