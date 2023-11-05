global class MovieDataSyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
    global MovieDataSyncBatch() {
        // Constructor logic syntax
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, tmdbId__c, Description__c, Title__c, Revenue__c, Raiting__c, PosterURL__c, TMDBSyncDate__c
            FROM MovieObject__c
            WHERE (TMDBSyncDate__c = null OR TMDBSyncDate__c < :Date.today().addMonths(-1)) AND tmdbId__c != null 
        ]);
    }
    global void execute(Database.BatchableContext bc, List<MovieObject__c> scope) {
        List<MovieObject__c> recordsToUpdate = new List<MovieObject__c>();
        
        tmdb app = new tmdb();

        for (MovieObject__c movie : scope) {
            tmdbMovieDetailsResponse movieDetails = app.getMovieDetails(Integer.valueOf(movie.tmdbId__c));
            movie.TMDBSyncDate__c = System.today();
            movie.Revenue__c = movieDetails.revenue;
            movie.Raiting__c = movieDetails.vote_average;
        }
        
        if (!recordsToUpdate.isEmpty()) {
            try {
                update recordsToUpdate;
            } catch (Exception e) {
                System.debug('Error updating records: ' + e.getMessage());
            }
        }
    }
    global void finish(Database.BatchableContext bc) {
        System.debug('Batched');
    }
}
