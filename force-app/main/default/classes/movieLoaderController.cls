    public with sharing class movieLoaderController {
    @AuraEnabled 
    public static void importMovies(String jsonData) {
        System.debug('Received JSON Data in Apex: ' + jsonData);
        MovieImportJSON movieImporter = new MovieImportJSON();
        movieImporter.importMovies(jsonData);
        System.debug('JSONDATA=>' + jsonData);
    }
}



