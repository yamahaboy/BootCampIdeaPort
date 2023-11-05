public class MovieImportJSON {

    public void importMovies(String jsonData) {
        List<MovieData> movieList = (List<MovieData>) JSON.deserialize(jsonData, List<MovieData>.class);
        
        List<MovieObject__c> moviesToInsert = new List<MovieObject__c>();
        Set<String> processedTmdbIds = new Set<String>();
        
        for (MovieData movieData : movieList) {
            processMovieData(movieData, moviesToInsert, processedTmdbIds);
        }
        
        if (!moviesToInsert.isEmpty()) {
            insertMovies(moviesToInsert);
        }
    }

    private void processMovieData(MovieData movieData, List<MovieObject__c> moviesToInsert, Set<String> processedTmdbIds) {
        String tmdbId = movieData.tmdb_id;

        if (!processedTmdbIds.contains(tmdbId)) {
            MovieObject__c existingMovie = getExistingMovieByTmdbId(tmdbId);
            if (existingMovie == null) {
                MovieObject__c movie = createMovieObject(movieData, tmdbId);
                if (movie != null) {
                    setMovieScript(movie, movieData.script);
                    moviesToInsert.add(movie);
                }
            }
            processedTmdbIds.add(tmdbId);
        }
    }

    private MovieObject__c getExistingMovieByTmdbId(String tmdbId) {
        List<MovieObject__c> existingMovies = [SELECT Id FROM MovieObject__c WHERE tmdbId__c = :Decimal.valueOf(tmdbId) LIMIT 1];
        return (existingMovies.isEmpty()) ? null : existingMovies[0];
    }

    private MovieObject__c createMovieObject(MovieData movieData, String tmdbId) {
        MovieObject__c movie = new MovieObject__c();
        movie.LegacyId__c = movieData.id;
        movie.Title__c = movieData.name;
        movie.tmdbId__c = Decimal.valueOf(tmdbId); 
        movie.genre__c = movieData.genre;
        movie.raiting__c = movieData.rating;
        movie.budget__c = movieData.budget;
        movie.Revenue__c = movieData.revenue;
        movie.Description__c = (movieData.script != null) ? movieData.script.description : null;
        return movie;
    }

    private void setMovieScript(MovieObject__c movie, ScriptData scriptData) {
        if (scriptData != null) {
            Script__c script = getScriptById(scriptData.id);
            if (script == null) {
                script = createScript(scriptData);
            }
            if (script != null) {
                movie.Script__c = script.Id;
            }
        }
    }

    private Script__c getScriptById(String scriptId) {
        List<Script__c> scripts = [SELECT Id,LegacyId__c FROM Script__c WHERE LegacyId__c = :scriptId LIMIT 1];
        return (scripts.isEmpty()) ? null : scripts[0];
    }

    public Script__c createScript(ScriptData scriptData) {
        Script__c newScript = new Script__c();
        newScript.LegacyId__c = scriptData.id;
        newScript.Description__c = scriptData.description;
        
        try {
            insert newScript;
            System.debug('Successfully inserted script: ' + newScript.Id);
            return newScript;
        } catch (Exception e) {
            System.debug('Error inserting script: ' + e.getMessage());
            return null;
        }
    }

    private void insertMovies(List<MovieObject__c> movies) {
        try {
            insert movies;
        } catch (Exception e) {
            System.debug('Error inserting movies: ' + e.getMessage());
        }
    }
}




   



