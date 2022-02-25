/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
*/

public class x7sVideoListController {

    /**
    * Get youtube videos by username
    *
    * @param results max number of result
    * @param username Youtube username
    * @param key Youtube Key
    * @param order video order
    *
    * @return String youtube videos
    */

    @AuraEnabled
    public static String getYouTubeVideosByUsername(String results, String username, String key, String order) {
        String channelId = getYouTubeUsername(username, key);

        if (channelId == '-1')
        {
            return 'false';
        }
        
        String url = 'https://www.googleapis.com/youtube/v3/search?key='+key+'&channelId='+channelId+'&part=snippet,id&order='+order+'&maxResults='+results;
        HttpRequest req = new HttpRequest(); Http http = new Http(); req.setMethod('GET');req.setEndpoint(url);HttpResponse res = http.send(req);
        return res.getBody();   
    }
    
    /**
    * Get youtube videos by Channel
    *
    * @param results max number of result
    * @param channel youtube channel id
    * @param key Youtube Key
    * @param order video order
    *
    * @return String youtube videos
    */

    @AuraEnabled
    public static String getYouTubeVideosByChannel(String results, String channel, String key, String order) {
        String url = 'https://www.googleapis.com/youtube/v3/search?key='+key+'&channelId='+channel+'&part=snippet,id&order='+order+'&maxResults='+results;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');    
        req.setEndpoint(url);
        HttpResponse res = http.send(req);
        return res.getBody();   
    }
    
    /**
    * Get youtube videos by Playlist
    *
    * @param results max number of result
    * @param playlistId youtube playlistId id
    * @param key Youtube Key
    * @param order video order
    *
    * @return String youtube videos
    */

    @AuraEnabled
    public static String getYouTubeVideosByPlaylist(String results, String playlistId, String key, String order) {
        String url = 'https://www.googleapis.com/youtube/v3/playlistItems?key='+key+'&playlistId='+playlistId+'&part=snippet,id&&maxResults='+results;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');    
        req.setEndpoint(url);
        HttpResponse res = http.send(req);
        return res.getBody();   
    }

    /**
    * Get youtube username
    *
    * @param username Youtube username
    * @param key Youtube Key
    *
    * @return String youtube videos
    */

    public static String getYouTubeUsername(String username, String key) {
        String channelId = '-1';
        String url = 'https://www.googleapis.com/youtube/v3/channels?part=id&forUsername='+username+'&key='+key;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');    
        req.setEndpoint(url);
        HttpResponse res = http.send(req);
        String body = res.getBody();
        
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(body);
        List<Object> items = (List<Object>)root.get('items');

        if (items != null)
        {
            for (Object item : items) { 
                Map<String, Object> i = (Map<String, Object>)item; 
                channelId = String.valueOf(i.get('id'));}
        }

        return channelId;
    }
    
    /**
    * Get Vimeo Videos
    *
    * @param channel Vimeo channelId
    *
    * @return String Vimeo videos
    */

    @AuraEnabled
    public static String getVimeoVideos(String channel) {
        String      endpoint        = 'https://vimeo.com/api/v2/'+channel+'/videos.json';
        HttpRequest httpRequest     = new HttpRequest();
        Http        http            = new Http();

        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(endpoint);

        HttpResponse httpResponse = http.send(httpRequest);

        System.debug('Response: ' + httpResponse);
        System.debug('Body: ' + httpResponse.getBody());
        System.debug('Status: ' + httpResponse.getStatus());
        System.debug('Status Code: ' + httpResponse.getStatusCode());

        if (httpResponse.getStatusCode() == 200 &&
                httpResponse.getBody().indexOf('{') != -1) {
            return httpResponse.getBody();
        }
        else {
            throw new CalloutException(httpResponse.getBody());
        }

    }

    /**
    * Get Brightcove Videos
    *
    * @param accountId Brightcove Account Id
    * @param policyKey policyKey for authentication
    * @param playlistId Brightcove playlistId
    *
    * @return String Brightcove videos
    */

    @AuraEnabled
    public static String getBrightcoveVideos(String accountId , String policyKey, String playlistId) {
        String url = 'https://edge.api.brightcove.com/playback/v1/accounts/'+accountId+'/playlists/'+playlistId;
        String authorizationHeader = 'BCOV-Policy ' + policyKey;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET'); 
        req.setHeader('Authorization', authorizationHeader);   
        req.setEndpoint(url);
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200 &&
            res.getBody().indexOf('{') != -1) {
            return res.getBody();
        }
        else {
            throw new CalloutException(res.getBody());
        }
    }
     /**
    * Get Wistia Videos
    *
    * @param key key for authentication
    * @param projectId Wistia projectId
    *
    * @return String Wistia videos
    */

    @AuraEnabled
    public static String getWistiaVideos(String projectId , String key) {
        String url = 'https://api.wistia.com/v1/projects/'+projectId+'.json?access_token='+key;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET'); 
        req.setEndpoint(url);
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200 &&
            res.getBody().indexOf('{') != -1) {
            return res.getBody();
        }
        else {
            throw new CalloutException(res.getBody());
        }
    }
}