public with sharing class MovieCatalogFilterController {
    @AuraEnabled(cacheable=true)
    public static List<String> getAllGenres() {
        List<String> genres = new List<String>();

        try {
            Schema.SObjectType movieObjectType = Schema.getGlobalDescribe().get('MovieObject__c');
            Schema.DescribeSObjectResult movieObjectDescribe = movieObjectType.getDescribe();
            Schema.DescribeFieldResult genreFieldDescribe = movieObjectDescribe.fields.getMap().get('Genre__c').getDescribe();

            List<Schema.PicklistEntry> picklistValues = genreFieldDescribe.getPicklistValues();
            
            for (Schema.PicklistEntry picklistEntry : picklistValues) {
                genres.add(picklistEntry.getValue());
            }
        } catch (Exception e) {
            System.debug('Error loading genres: ' + e.getMessage());
        }

        return genres;
    }
}