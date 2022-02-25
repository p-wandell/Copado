/*
 * Copyright (c) 2020. 7Summits Inc.
 */

// ===================
// Featured User Controller
// ===================
public with sharing class x7sExpFeaturedUserController {
    public class ExpeditionException extends Exception {}

    // Get user ID for a user
    @AuraEnabled
    public static User getUserInformation(Id userId) {
        try {
            User featuredUser = [SELECT Id, Name, Title, MediumPhotoUrl FROM User WHERE Id = :userId WITH SECURITY_ENFORCED ];
            return featuredUser;
        }
        catch (System.QueryException ex)
        {
            System.debug('getUserInformation()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }

    // Get the site prefix (for displaying links/assets)
    @AuraEnabled
    public static String getSitePrefix() {
        return x7sExpUtils.getSitePrefix();
    }

    // Get user List for a user
    @AuraEnabled
    public static List<User> getUserListInformation(List<Id> userIds) {
        try {

            Set<Id> userList = new Set<Id>();
            userList.addAll(userIds);
            List<User> featuredUser = [SELECT Id, Name, Title, MediumPhotoUrl FROM User WHERE Id = :userList WITH SECURITY_ENFORCED ];
            return featuredUser;

        }
        catch (System.QueryException ex)
        {
            System.debug('getUserListInformation()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }
}