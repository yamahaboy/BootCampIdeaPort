public with sharing class MovieSearchByTitleController {
    @AuraEnabled(cacheable=true)
    public static List<tmdbSearchMovieResult> searchMovie(String title) {
        tmdb movieInfo = new tmdb();
        return movieInfo.searchMovie(title).results;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getGenreIdByName() {
        Map<String, Integer> genreIdByName = new Map<String, Integer>();

        tmdb movieInfo = new tmdb();
        tmdbGenreListResponse genreListResponse = movieInfo.genreList(); 
        if (genreListResponse != null && genreListResponse.genres != null) {
            for (tmdbGenre genre : genreListResponse.genres) {
                genreIdByName.put(genre.name, genre.id);
            }
        }
        return genreIdByName; 
    }

    @AuraEnabled(cacheable=true)
    public static String getGenreNameById(Integer genreId) {
        tmdb movieInfo = new tmdb();
        Map<String, Integer> genreIdByName = getGenreIdByName();
        for (String name : genreIdByName.keySet()) {
            if (genreIdByName.get(name) == genreId) {
                return name;
            }
        }
        return null;
    }

}


