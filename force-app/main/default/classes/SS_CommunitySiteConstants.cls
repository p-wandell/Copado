public without sharing class SS_CommunitySiteConstants {
    // Constants 

	public static String CUSTOM_LOGIN_PAGE_NAME = 'Login';
    private static String SETTING_NAME = '7Summits Community';

    /*
    private static RecordType PERSON_RECORD_TYPE;
    public static RecordType getPersonRecordType() {
        if (PERSON_RECORD_TYPE == null) {
            PERSON_RECORD_TYPE = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND IsPersonType = true AND IsActive = true];
        }
        return PERSON_RECORD_TYPE;
    }
    */

    private static Boolean SHOW_GROUP_LIST;
    public static Boolean getShowGroupList() {
        if (SHOW_GROUP_LIST == null) {
            SHOW_GROUP_LIST = getSetting().Show_Group_List__c;
        }
        return SHOW_GROUP_LIST;
    } 

	private static String COMMUNITY_NAME;
    public static String getCommunityName() {
        if (COMMUNITY_NAME == null) {
            COMMUNITY_NAME = getSetting().Community_Name__c;
        }
        return COMMUNITY_NAME;
    } 

    private static String COMMUNITY_ID;
    public static String getCommunityId() {
        try
        {
            if (COMMUNITY_ID == null) {
                COMMUNITY_ID = [SELECT Id FROM Community WHERE Name =: getCommunityName()][0].Id;
            }
        } catch (Exception e) {
            System.debug('Community does not exist named ' + getCommunityName());
        }
        return COMMUNITY_ID;
    }

    private static String COMMUNITY_PROFILE_NAME; // 'Customer Community Login User';
    public static String getCommunityProfileName() {
        if (COMMUNITY_PROFILE_NAME == null) {
            COMMUNITY_PROFILE_NAME = getSetting().Community_Profile_Name__c;
        }
        return COMMUNITY_PROFILE_NAME;
    } 

    private static String UNAUTHENTICATED_COMMUNITY_PROFILE_NAME; // '7Summits Customer Community Profile';
    public static String getUnauthenticatedCommunityProfileName() {
        if (UNAUTHENTICATED_COMMUNITY_PROFILE_NAME == null) {
            UNAUTHENTICATED_COMMUNITY_PROFILE_NAME = getSetting().Unauthenticated_Community_Profile_Name__c;
        }
        return UNAUTHENTICATED_COMMUNITY_PROFILE_NAME;
    } 

    private static String USERNAME_SUFFIX; //'@7SummitsCommunity.com';
    public static String getUsernameSuffix() {
        if (USERNAME_SUFFIX == null) {
            USERNAME_SUFFIX = getSetting().Username_Suffix__c;
        }
        return USERNAME_SUFFIX;
    } 

    private static String COMMUNITY_ACCOUNT_NAME;
    public static String getDefaultCommunityAccountName() {
        if (COMMUNITY_ACCOUNT_NAME == null) {
            COMMUNITY_ACCOUNT_NAME = getSetting().Default_Community_Account_Name__c;
        }
        return COMMUNITY_ACCOUNT_NAME;
    } 

    private static String COMMUNITY_ACCOUNT_ID;
    public static String getCommunityAccountId() {
        try
        {
            if (COMMUNITY_ACCOUNT_ID == null) {
                COMMUNITY_ACCOUNT_ID = [SELECT Id FROM Account WHERE Name =: getDefaultCommunityAccountName()].Id;
            }
        } catch (Exception e) {
            System.debug('Account does not exist named ' + getDefaultCommunityAccountName());
        }
        return COMMUNITY_ACCOUNT_ID;
    }

    private static SS_Community__c getSetting() {
        SS_Community__c setting = SS_Community__c.getValues(SETTING_NAME);
        if (setting == null) {
            // initialize a setting for test
            setting = new SS_Community__c();
            setting.Community_Name__c = 'A Customer Zone';
            setting.Community_Profile_Name__c = 'Customer Community Login User';
            setting.Username_Suffix__c = '@7SummitsCommunity.com';
            setting.Unauthenticated_Community_Profile_Name__c = '7Summits Customer Community Profile';
            setting.Default_Community_Account_Name__c = 'Test Community Customer 01';
        }
        return setting;
    }

    public static String USER_PROFILE_URL = '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformFeed';
    public static String GROUP_LIST_URL = '/_ui/core/chatter/groups/GroupListPage';
    public static String GROUP_PROFILE_URL = '/_ui/core/chatter/groups/GroupProfilePage?g=';
}