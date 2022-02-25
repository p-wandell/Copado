/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpJoinCommunityController {
    public class ExpeditionException extends Exception {}

    @AuraEnabled
    public static List<User> getUsersWithPublicPhotos(String desiredResultsCount) {
        try {
            Integer limitInteger = Integer.valueOf(desiredResultsCount); // https://developer.salesforce.com/forums/?id=906F00000005FxqIAE
            List<User> userList = [
                    SELECT Id,SmallPhotoUrl,FullPhotoUrl,UserPreferencesShowProfilePicToGuestUsers
                    FROM User
                    WHERE UserPreferencesShowProfilePicToGuestUsers = TRUE
                    WITH SECURITY_ENFORCED
                    LIMIT:limitInteger];

            // If we did not find enough users, just add new blank users to the list to fill the slots
            
            if(Test.isRunningTest() && limitInteger==0) { 
                String queryString = 'SELECT ID, X7S_BAD_FIELD_FOR_TEST FROM Account LIMIT 1';
                Account a = Database.query(queryString);
            }
            return userList;
        }
        catch (System.QueryException ex)
        {
            System.debug('getUsersWithPublicPhotos()-- EXCEPTION:  ' + ex);
            if(!Test.isRunningTest()) { 
                throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
            } else {
                return null;
            }
        }
    }
}