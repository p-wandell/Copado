public with sharing class x7sSlackController {
    
    //Bot token
    private static final string AccessToken='xoxb-3875761969-1110631142628-eWix3PZJxpZDroZ9qVJi4n6M';
    
    //Auth Token
    private static final string authToken = 'xoxp-3875761969-1097165596804-1104686010611-5e780e0e35114ecec9dce2505ededea7';
    
    /*
        Generic wrapper for http response
    */
    public class ResponseWrapper {
        @AuraEnabled
        public Integer responseCode {get;set;}

        @AuraEnabled
        public String responseStatus {get;set;}

        @AuraEnabled
        public String errorMessage {get;set;}

        @AuraEnabled
        public String responseBody {get;set;}
    }
	
    /**
    * This function will fetch the feed from Slack Channel based on channelId and feedLimit
    * @param  : channel     : Id of channel 
                feedLimit   : Limit of feed to fetch from channel
    * @return : ResponseWrapper (JSON from slack channel)
    */
    
    @AuraEnabled
    public static ResponseWrapper getChannelFeed(string channelId ,Integer feedLimit) {
        ResponseWrapper responseWrapper = new ResponseWrapper();
            Http http = new Http();
                HttpRequest req = new HttpRequest();
            	req.setEndpoint('https://slack.com/api/conversations.history?channel='+channelId+'&limit='+feedLimit);
                req.setMethod('GET');
                req.setHeader('Authorization','Bearer '+AccessToken);

            try{
                // Get that request
                HttpResponse response = http.send(req);
                // Process it
                response.setHeader('Set-Cookie', 'sameSite=none;Secure');
                responseWrapper.responseCode = response.getStatusCode();
                responseWrapper.responseStatus = response.getStatus();
                responseWrapper.responseBody = response.getBody();
                
            } catch (Exception e){
                responseWrapper.errorMessage = e.getMessage();
            }

        return responseWrapper;

    }
    /**
    * This will fetch all the user from Slack
    * @return : ResponseWrapper (List of users)
    */

    @AuraEnabled
    public static ResponseWrapper getUsersList() {
        ResponseWrapper responseWrapper = new ResponseWrapper();

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://slack.com/api/users.list');
            req.setMethod('GET');
            req.setHeader('Authorization','Bearer '+AccessToken);

            try{
                // Get that request
                HttpResponse response = http.send(req);
                // Process it
                responseWrapper.responseCode = response.getStatusCode();
                responseWrapper.responseStatus = response.getStatus();
                responseWrapper.responseBody = response.getBody();

                
            } catch (Exception e){
                responseWrapper.errorMessage = e.getMessage();
            }

        return responseWrapper;

    }

    /**
    * This will post to the slack channel based on postText and channelId
    * @param  : postText     : Text which will post to slack channel 
                channelId    : Id of Slack Channel
    * @return : ResponseWrapper 
    */

    @AuraEnabled
    public static ResponseWrapper postToSlack(String postText,String channelId) {
        ResponseWrapper responseWrapper = new ResponseWrapper();
        String encoded = EncodingUtil.urlEncode(postText, 'UTF-8');

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://slack.com/api/chat.postMessage?channel='+channelId+'&text='+encoded);
            req.setMethod('GET');
            req.setHeader('Authorization','Bearer '+AccessToken);

            try{
                // Get that request
                HttpResponse response = http.send(req);
                // Process it
                responseWrapper.responseCode = response.getStatusCode();
                responseWrapper.responseStatus = response.getStatus();
                responseWrapper.responseBody = response.getBody();
                
            } catch (Exception e){
                responseWrapper.errorMessage = e.getMessage();
            }

        return responseWrapper;

    }

    /**
    * This will convert the uploaded (By anyone) channel's file to public
    * @param  : fileId : Id of File which needs to be converted to public
    * @return : ResponseWrapper 
    */

    @AuraEnabled
    public static ResponseWrapper slackImage(String fileId) {
        ResponseWrapper responseWrapper = new ResponseWrapper();

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://slack.com/api/files.sharedPublicURL?file='+fileId);
            req.setMethod('GET');
            req.setHeader('Authorization','Bearer '+authToken);

            try{
                // Get that request
                HttpResponse response = http.send(req);
                // Process it
                responseWrapper.responseCode = response.getStatusCode();
                responseWrapper.responseStatus = response.getStatus();
                responseWrapper.responseBody = response.getBody();
                //system.debug('----code is'+response.getStatusCode());
                
            } catch (Exception e){
                responseWrapper.errorMessage = e.getMessage();
            }

        return responseWrapper;

    }
}