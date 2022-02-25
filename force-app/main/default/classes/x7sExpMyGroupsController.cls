/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpMyGroupsController {
    public class ExpeditionException extends Exception {}

    // Determine if user is in a group
    @AuraEnabled
    public static Boolean isInAGroup() {
        try {
            // Find group membership records for current user
            List<CollaborationGroupMember> groupMembers = [
                    SELECT MemberId
                    FROM CollaborationGroupMember
                    WHERE MemberId = :UserInfo.getUserId()
                    WITH SECURITY_ENFORCED
            ];

            // Hey, found one, return that we are in a group
            if (groupMembers.size() > 0) {
                return true;
            }
            return false;
        }
        catch (System.QueryException ex)
        {
            System.debug('isInAGroup()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }

    // Get a featured group by ID
    @AuraEnabled
    public static x7sExpResponse getFeaturedGroup(String groupIdString) {
        try {
            x7sExpResponse response = new x7sExpResponse();

            if (!String.isEmpty(groupIdString)) {
                CollaborationGroup featuredGroup = [
                        SELECT BannerPhotoUrl, Description, FullPhotoUrl, Id, MemberCount, Name, SmallPhotoUrl
                        FROM CollaborationGroup
                        WHERE Id = :groupIdString
                        WITH SECURITY_ENFORCED
                        ORDER BY Name ASC
                ];

                if (featuredGroup != null) {
                    response.results.add(featuredGroup);
                }
            }

            return response;
        }
        catch (System.QueryException ex)
        {
            System.debug('getFeaturedGroup()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }

    }

    // Get a featured group by list of IDs
    @AuraEnabled
    public static x7sExpResponse getFeaturedGroups(List<String> groupIdStrings, String numResultsString) {
        try {
            x7sExpResponse response = new x7sExpResponse();
            Integer queryLimit = Integer.valueOf(numResultsString);

            if (!x7sExpUtils.isNullOrEmpty(groupIdStrings)) {
                List<CollaborationGroup> featuredGroups = [
                        SELECT BannerPhotoUrl, Description, FullPhotoUrl, Id, MemberCount, Name, SmallPhotoUrl
                        FROM CollaborationGroup
                        WHERE Id IN :groupIdStrings
                        WITH SECURITY_ENFORCED
                        ORDER BY Name ASC
                        LIMIT :queryLimit
                ];

                if (featuredGroups != null) {
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

    // Get My Groups
    @AuraEnabled
    public static x7sExpResponse getMyGroups(String numResultsString) {
        try {
            x7sExpResponse response = new x7sExpResponse();
            Integer queryLimit = Integer.valueOf(numResultsString); // https://developer.salesforce.com/forums/?id=906F00000005FxqIAE

            // Get group Ids for current user
            List<Id> groupIds = new List<Id>();
            for (CollaborationGroupMember groupMembership : [SELECT CollaborationGroupId FROM CollaborationGroupMember WHERE MemberId = :UserInfo.getUserId() AND NetworkId != NULL]) {
                groupIds.add(groupMembership.CollaborationGroupId);
            }

            // And now query those groups with the IDs

            List<CollaborationGroup> myGroups = [
                    SELECT BannerPhotoUrl, Description, FullPhotoUrl, Id,MemberCount, Name, SmallPhotoUrl
                    FROM CollaborationGroup
                    WHERE Id IN :groupIds
                    WITH SECURITY_ENFORCED
                    ORDER BY Name ASC
                    LIMIT :queryLimit
            ];

            response.results = myGroups;

            return response;
        }
        catch (System.QueryException ex)
        {
            System.debug('getMyGroups()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }

    @AuraEnabled
    public static String getSitePrefix() {
        return x7sExpUtils.getSitePrefix();
    }
}