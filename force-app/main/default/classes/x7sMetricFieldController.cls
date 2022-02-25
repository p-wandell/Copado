/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sMetricFieldController {
    @AuraEnabled
    public static String fetchMetricsData(List<String> fieldNames) {
        String metricsData;

        List<String> fieldApiNames = new List<String>();
        for (String fieldName : fieldNames) {
            if (String.isNotBlank(fieldName)) {
                fieldApiNames.add(String.escapeSingleQuotes(fieldName));
            }
        }
        System.debug('Field API Names: ' + fieldApiNames);

        String loggedInUserId = UserInfo.getUserId();

        if (Test.isRunningTest()) {
            List<User> communityUser = [SELECT Id FROM User WHERE Username = 'x7sNewUser@7summits.com' WITH SECURITY_ENFORCED];
            if (communityUser.size() > 0) {
                loggedInUserId = communityUser[0].Id;
            }
            System.debug('Test mode userId: ' + loggedInUserId);
        }

        String contactRecId;
        User userRecord = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Id = :loggedInUserId WITH SECURITY_ENFORCED];
        contactRecId = userRecord.ContactId;
        String accountRecId;

        List<Contact> contactRecords = [SELECT Id, AccountId FROM Contact WHERE Id = :contactRecId WITH SECURITY_ENFORCED];
        if (contactRecords.size() > 0) {
            accountRecId = contactRecords[0].AccountId;
        }
        List<UserDataWrapper> dataWrapperList = new List<UserDataWrapper>();

        for (String str : fieldApiNames) {
            if (str != null && str != '') {
                List<String> fieldAndObjectNames = new List<String>();
                List<String> metricFieldNames = str.split('\\.');

                for (String fieldAndObject : metricFieldNames) {
                    fieldAndObjectNames.add(fieldAndObject);
                }

                String query = 'SELECT Id, ';
                String fieldApi;
                String objectApi;

                /*** if contact/account ***/
                if (fieldAndObjectNames.size() > 1) {
                    objectApi = fieldAndObjectNames[fieldAndObjectNames.size() - 2];
                    fieldApi = fieldAndObjectNames[fieldAndObjectNames.size() - 1];

                    query += fieldApi;

                    query += ' FROM ' + objectApi + ' WHERE Id = ';

                    if (objectApi == 'Contact') {
                        query += '\'' + userRecord.ContactId + '\'';
                    } else if (objectApi == 'Account') {
                        query += ' \'' + String.escapeSingleQuotes(accountRecId) + '\'';
                    }
                } else {
                    objectApi = 'User';
                    fieldApi = String.escapeSingleQuotes(str);
                    query += fieldApi + ' FROM ' + objectApi + ' WHERE Id =: loggedInUserId';
                }

                Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApi);
                Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
                Schema.DescribeFieldResult fieldResult = objectResult.fields.getMap().get(fieldApi).getDescribe();
                String fieldType = String.valueOf(fieldResult.getType());

                System.debug('fetchMetricsData Query: ' + query);
                SObject userWithMetricsData = Database.query(query); //NOPMD -- All string escaped.

                if (userWithMetricsData != null) {
                    Object metricData = userWithMetricsData.get(fieldApi);

                    UserDataWrapper wrapData = new UserDataWrapper(str, String.valueOf(metricData), fieldType);
                    dataWrapperList.add(wrapData);
                }
            }
        }
        // ******  end of  loop     ///
        if (dataWrapperList.size() != 0) {
            metricsData = JSON.serialize(dataWrapperList);
        }

        return metricsData;
    }
    public class UserDataWrapper {
        @AuraEnabled public String fieldType ;
        @AuraEnabled public String fieldMetricValue ;
        @AuraEnabled public String fieldApiName ;

        public UserDataWrapper(String fieldApiName, String fieldMetricValue, String fieldType) {
            this.fieldType = fieldType;
            this.fieldMetricValue = fieldMetricValue;
            this.fieldApiName = fieldApiName;
        }
    }
}