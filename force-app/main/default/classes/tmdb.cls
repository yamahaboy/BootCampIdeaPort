public with sharing class tmdb {
    private static final String API_KEY = '5bfef77f0d03fea766a8ab7ddfe11ab1';
    private static final String API_KEY_PARAM_NAME = 'api_key';
    private static final String API_VERSION = '3';

    private String authQueryParameter {
        get {
            return API_KEY_PARAM_NAME + '=' + API_KEY;
        }
    }

    private static final String BASE_URL = 'https://api.themoviedb.org/';

    private string buildResourceUrl(String resourceName) {
        return BASE_URL + API_VERSION + resourceName;
    }

    private HttpRequest authenticateRequest(HttpRequest request) {
        String endpoint = request.getEndpoint();
        if (endpoint.contains('?')) {
            endpoint += '&' + authQueryParameter;
        } else {
            endpoint += '?' + authQueryParameter;
        }
        request.setEndpoint(endpoint);

        return request;
    }

    public tmdbMovieDetailsResponse getMovieDetails (Integer movieId) {
        String resourceName = '/movie/' + String.valueOf(movieId);
        String endpoint = buildResourceUrl(resourceName);

        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request=authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);


        tmdbMovieDetailsResponse result = (tmdbMovieDetailsResponse) JSON.deserialize(response.getBody(), tmdbMovieDetailsResponse.class);
        System.debug(result);
        return result;
    }

   
    public tmdbGenreListResponse genreList() {
        String resourceName = '/genre/movie/list';
        String endpoint = buildResourceUrl(resourceName);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);

        tmdbGenreListResponse tmdbResponse = (tmdbGenreListResponse) JSON.deserialize(response.getBody(), tmdbGenreListResponse.class);
        return tmdbResponse;
    }

    public tmdbSearchMovieResponse searchMovie(String title) {
        String resourceName = '/search/movie';
        String endpoint = buildResourceUrl(resourceName);
        endpoint += '?query=' + EncodingUtil.urlEncode(title, 'UTF-8');
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());

        
        tmdbSearchMovieResponse result = (tmdbSearchMovieResponse) JSON.deserialize(response.getBody(), tmdbSearchMovieResponse.class);
        return result;
    }
}
