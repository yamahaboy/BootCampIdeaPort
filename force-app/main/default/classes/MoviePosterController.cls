public with sharing class MoviePosterController {
    @AuraEnabled(cacheable=true)
    public static String getMoviePosterUrl(String movieId) {
        List<MovieObject__c> movie = [SELECT id, PosterURL__c FROM MovieObject__c WHERE Id = :movieId LIMIT 1];
        
        if(!movie.isEmpty()){
            return 'https://image.tmdb.org/t/p/original' + movie[0].PosterURL__c;
        } else {
            return null;
        }
    }
}
