public class x7sGuideMeController {
    @AuraEnabled
    public static String getRecord(string fieldApiName) {
		if (!string.isBlank(fieldApiName)) {
			String userId = userInfo.getUserId();
            String query  = 'SELECT  Id, ' + fieldApiName + ' FROM User WHERE Id =: userId';

            try {
                sObject user = database.query(query);
				return JSON.serialize(user);    
            } 
			catch(exception e) {
                System.debug('getRecord error: '+e.getMessage());
                return null;    
            }
        } else {
            return null;    
        }
    }

    @AuraEnabled
    public static void updateUser(string userRec) {
        try {
            User u = (User)JSON.deserializeStrict(userRec, user.class);

            update u;
        }  
        catch(Exception e) {
            System.debug('updateUser error: '+e.getMessage());
        }
    }
}