global class GoogleRegistrationHandler extends CommunityRegistrationHandler {
    global override void updateAdditionalFields(String userId, User u, Auth.UserData data) {
        // Useful to save the Google ID in a custom field
        u.Google_ID__c = data.identifier;

        // TODO - Not working...yet
        setImage(userId, data.attributeMap.get('picture'));
    }

    // https://github.com/jamesmelville/OpenIdConnectDemo/blob/master/src/classes/GoogleHandler.cls
    public void setImage(Id userId, String url) {
        
        try {
            //check user's existing photo
            ConnectApi.Photo p = ConnectApi.ChatterUsers.getPhoto(null, userId);
            
            // if they don't have a photo and we get a link to one
            if((p == null || p.photoVersionId == null) &&  url != null ) {
                AuthProvider googleAP = [SELECT Id FROM AuthProvider WHERE DeveloperName = 'Google'];

                //retrieve the photo from google
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + Auth.AuthToken.getAccessToken(googleAP.Id, 'open id connect'));
                HttpResponse res = new Http().send(req);
                Blob b = res.getBodyAsBlob();
                
                //set the photo on the user's profile
                ConnectApi.ChatterUsers.setPhoto(null, userId, new ConnectApi.BinaryInput(b,'image/jpg','user.jpg'));
            }
        }
        catch(Exception e){
            //don't block the user login by throwing an exception
        }
    }
}