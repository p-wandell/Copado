/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpRecordsTest {

    /*
        Some test data to use
     */
    // Object
    private static final String objectType = 'Contact';

    // Fields
    private static final List<String> testFields = new List<String>{
            'Id', 'Email'
    };

    /*
        Test setup
     */
        
    @TestSetup
    static void testSetup() {
        x7sExpTestUtils.createTestContact();
//        User testUser = x7sExpTestUtils.createStandardUserNoContact();
//        insert testUser;
    }

    /*
        Test just the helpers
     */
    @IsTest
    public static void testQueryHelpers() {

        // Get test user ID for queries
        List<Contact> testContacts = [SELECT Id FROM Contact WHERE Email = :x7sExpTestConstants.STANDARD_EMAIL];
        Id testId = testContacts[0].Id;

//        List<User> testUsers = [SELECT Id FROM User WHERE Email = :x7sExpTestConstants.STANDARD_EMAIL];
//        User testUser = testUsers[0];

        // ID where clause
        String idWhereClause = x7sExpRecordQueryHelper.buildIdWhereClause(String.valueOf(testId));

        // Build query string and validate it's correct!
        String queryString = x7sExpRecordQueryHelper.buildQueryString(objectType, testFields, idWhereClause);
        System.assertEquals(queryString, 'Select Id, Email from Contact where Id = \'' + testId + '\'');

        // Now query
        List<SObject> testResults = x7sExpRecordQueryHelper.executeQuery(queryString);
        System.assertEquals(testResults.size(), 1); // assert the one record is found

        // And NOW, test
        List<x7sExpContentObject> pcoList = x7sExpRecordQueryHelper.formatRecordDetailWithLabels(objectType, testResults[0], testFields);
        System.assertEquals(pcoList.size(), 2); // assert that the two fields are found / formatted
    }

    /*
        Test the detail and
     */
    @IsTest
    public static void testControllers() {

        // Get test user ID for queries
        List<Contact> testContacts = [SELECT Id FROM Contact WHERE Email = :x7sExpTestConstants.STANDARD_EMAIL];
        Id testId = testContacts[0].Id;

        x7sExpResponse testResponse = new x7sExpResponse();

        /*
            Detail Controller Tests
         */
        String testFieldsString = x7sExpUtils.buildStringFromList(testFields);
        testFieldsString = testFieldsString.replaceAll(' ', '');

        // Get a successful detail
        testResponse = x7sExpRecordDetailController.getRecordDetail(String.valueOf(testId), objectType, testFieldsString);
        System.assertEquals(testResponse.success, true); // it worked!
        System.assertEquals(testResponse.results.size(), 1); // found one record!

        // Fail with bad object
        testResponse = x7sExpRecordDetailController.getRecordDetail(String.valueOf(testId), 'Not a Real Object', testFieldsString);
        System.assertEquals(testResponse.success, false); // did not work

        // with bad fields
        testResponse = x7sExpRecordDetailController.getRecordDetail(String.valueOf(testId), objectType, 'Bad Apple');
        System.assertEquals(testResponse.success, false); // did not work

        // with no match id
        testResponse = x7sExpRecordDetailController.getRecordDetail(x7sExpTestUtils.getFakeId(Contact.SObjectType), objectType, testFieldsString);
        System.assertEquals(testResponse.success, true); // not actually a failure
        System.assertEquals(testResponse.results.size(), 0); // but no results
    }
}