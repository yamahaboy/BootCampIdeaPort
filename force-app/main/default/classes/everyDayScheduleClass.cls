global class everyDayScheduleClass implements Schedulable {
    private static Boolean hasExecuted = false;

    global void execute(SchedulableContext ctx) {
        if (hasExecuted) {
            return;
        }
        
        Time preferredExecutionTime = Time.newInstance(18, 0, 0, 0); // 18:00
        
        Datetime now = Datetime.now();
        Date today = Date.today();
        Datetime preferredExecutionDatetime = Datetime.newInstance(today.year(), today.month(), today.day(), preferredExecutionTime.hour(), preferredExecutionTime.minute(), preferredExecutionTime.second());
        
        if (now >= preferredExecutionDatetime) {
            preferredExecutionDatetime = preferredExecutionDatetime.addDays(1);
        }
        
        List<MovieObject__c> moviesToSync = [SELECT Id FROM MovieObject__c WHERE TMDBSyncDate__c = null OR TMDBSyncDate__c < :Date.today().addMonths(-1)];
        
        if (!moviesToSync.isEmpty()) {
            List<String> movieObjectIds = new List<String>();
            for (MovieObject__c movie : moviesToSync) {
                movieObjectIds.add(String.valueOf(movie.Id));
            }
            // updateMovieObjectsRecords.updateRecords(movieObjectIds);
            Database.executeBatch(new MovieDataSyncBatch()); 
        }

        hasExecuted = true;
    }
}
