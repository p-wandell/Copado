/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpFeaturedGroupsController {

    public class ExpeditionException extends Exception {}

    // Get a featured group by ID
    @AuraEnabled
    public static x7sExpResponse getFeaturedGroups(String groupIdsString) {
        try{
            x7sExpResponse response = new x7sExpResponse();

            List<String> idsList = groupIdsString.split(',');

            if (!x7sExpUtils.isNullOrEmpty(idsList)) {
                List<CollaborationGroup> featuredGroups = [
                        SELECT BannerPhotoUrl, Description, FullPhotoUrl, Id, MemberCount, Name, SmallPhotoUrl
                        FROM CollaborationGroup
                        WHERE Id IN :idsList
                        WITH SECURITY_ENFORCED
                ];

                if (!x7sExpUtils.isNullOrEmpty(featuredGroups)) {
                    response.results = featuredGroups;
                }
            }

            return response;
        }
        catch (System.QueryException ex)
        {
            System.debug('getFeaturedGroups()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }


    @AuraEnabled
    public static String getSitePrefix() {
        return x7sExpUtils.getSitePrefix();
    }
}