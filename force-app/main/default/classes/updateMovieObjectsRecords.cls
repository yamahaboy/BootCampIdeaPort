global class updateMovieObjectsRecords 
{
    @future(callout=true)
    public static void updateRecords(List<String> movieObjects)
    {   
        List<MovieObject__c> movies = [SELECT Id, TMDBId__c, Description__c, Title__c, Revenue__c, Raiting__c, PosterURL__c, TMDBSyncDate__c FROM MovieObject__c WHERE Id IN :movieObjects];
        tmdb app = new tmdb();
        
        for (MovieObject__c movieObject : movies) {
            tmdbMovieDetailsResponse movieDetails = app.getMovieDetails(Integer.valueOf(movieObject.TMDBId__c));
            
            if (movieDetails != null && String.isNotBlank(movieDetails.original_title)) {
                movieObject.Description__c = movieDetails.overview;
                movieObject.Title__c = movieDetails.original_title;
                movieObject.Revenue__c = movieDetails.revenue;
                movieObject.Raiting__c = movieDetails.vote_average;
                movieObject.PosterURL__c = movieDetails.poster_path;
                movieObject.TMDBSyncDate__c = Date.today();
            } else {
                System.debug('Movie details are missing or invalid for record with ID: ' + movieObject.Id);
            }
        }
        
        List<MovieObject__c> recordsToUpdate = new List<MovieObject__c>();
        for (MovieObject__c movieObject : movies) {
            if (String.isNotBlank(movieObject.Title__c)) {
                recordsToUpdate.add(movieObject);
            }
        }
        
        if (!recordsToUpdate.isEmpty()) {
            upsert recordsToUpdate;
        }
    }
}
