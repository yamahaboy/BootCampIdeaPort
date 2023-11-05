public with sharing class movieListController {
    @AuraEnabled(cacheable=true)
    public static List<MovieObject__c> getMovieList() {
        List<MovieObject__c> movies = [SELECT Id, Title__c, Genre__c, RaitingCalculated__c FROM MovieObject__c];
        System.debug(movies);
        return movies;
    }
}
