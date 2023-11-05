trigger MovieObjectTrigger on MovieObject__c (after insert) {
    List<String> movieObjects = new List<String>();
    for (MovieObject__c movie : Trigger.new){
        movieObjects.add(String.valueOf(movie.Id));
    }
    if(!movieObjects.isEmpty()){
        updateMovieObjectsRecords.updateRecords(movieObjects);
    }
}



