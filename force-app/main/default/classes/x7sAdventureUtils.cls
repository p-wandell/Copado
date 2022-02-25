/*
 * Copyright (c) 2020. 7Summits Inc.
 */

global with sharing class x7sAdventureUtils {

    // Return true/false to determine guest user
    global static Boolean isGuestUser() {
        return (UserInfo.getUserType() == 'Guest' || UserInfo.getUserName() == x7sAdventureTestConstants.GUEST_USERNAME);
    }

    // Get the site prefix
    global static String getSitePrefix() {
        return System.Site.getPathPrefix();
    }

    // Get picklist values for any object, any field
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) {
        List<String> picklistValues = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        SObject Object_name = targetType.newSObject();
        Schema.SObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPicklistValues(); //grab the list of picklist values for the passed field on the sobject

        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            picklistValues.add(a.getValue());//add the value  to our final list
        }

        return picklistValues;
    }

    // Build comma list string from a set
    public static String buildStringFromSet(Set<String> sourceSet) {
        String stringOutput = '';
        for (String thisString : sourceSet) {
            stringOutput += (stringOutput == '' ? '' : ', ') + thisString;
        }
        return stringOutput;
    }

    // Get User
    public static User getUser() {
        // BannerPhotoUrl, IsProfilePhotoActive
        User user;

        List<User> userList = [
                SELECT
                        Id, Email,PostalCode
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];

        if (!x7sAdventureUtils.isNullOrEmpty(userList)) {
            user = userList[0];
        }

        return user;
    }

    public static Boolean isNullOrEmpty(List<Object> objectList) {
        if (objectList == null || objectList.size() == 0) {
            return true;
        }
        return false;
    }

    public static List<String> createListFromMultiPicklist(String multiPicklistValue) {

        List<String> multiPicklistValueList = multiPicklistValue.split(';');
        return multiPicklistValueList;
    }

    public static Boolean doesStringContainListItem(List<String> compareList, String targetString) {

        for (String compareString : compareList) {

            //If list contains target string, return true
            if (targetString.contains(compareString)) {
                return true;
            }
        }
        return false;
    }

    public static Integer getYear() {
        Integer currentYear = System.today().year();
        return currentYear;
    }

    public static void throwErrorIfInsertPermissionMissing(DescribeSObjectResult describeSObjectInstance) {
        if (!describeSObjectInstance.isCreateable()) {
            System.debug(LoggingLevel.ERROR, 'Unable to insert ' + describeSObjectInstance.getName() + ' due to missing "Create" permission on sObject.');
            throw new AuraHandledException(System.Label.x7sAdventureErrorPermissionsMissing);
        }
    }

    public static void throwErrorIfUpdatePermissionMissing(DescribeSObjectResult describeSObjectInstance) {
        if (!describeSObjectInstance.isUpdateable()) {
            System.debug(LoggingLevel.ERROR, 'Unable to update ' + describeSObjectInstance.getName() + ' due to missing "Edit" permission on sObject.');
            throw new AuraHandledException(System.Label.x7sAdventureErrorPermissionsMissing);
        }
    }
}