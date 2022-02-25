/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sMembersFilters_Test {
    @IsTest
    private static void testFilterGetFilter() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();
        System.assertNotEquals(null, filterSet);
        System.debug('Filter set : ' + filterSet);

        X7S_Members_Filter_Item__mdt testFilter = filterSet.getFilterByName(filterSet.filters[0].DeveloperName);
        System.assertNotEquals(null, testFilter);

        testFilter = filterSet.getFilterByName('SHOULD_NOT_EXIST');
        System.assertEquals(null, testFilter);

        for (X7S_Members_Filter_Item__mdt filter : filterSet.filters) {
            testFilter = filterSet.getFilterByFieldName(filter.Field_Name__c);
            System.assertNotEquals(null, testFilter);
        }

        testFilter = filterSet.getFilterByFieldName('SHOULD_NOT_EXIST');
        System.assertEquals(null, testFilter);

        Test.stopTest();
    }

    @IsTest
    private static void testClearFilter() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();
        System.assertNotEquals(null, filterSet);

        X7S_Members_Filter__c clearFilter = filterSet.clearFilter(filterSet.filters[0].DeveloperName);
        System.assertNotEquals(null, clearFilter);

        Test.stopTest();
    }

    @IsTest
    private static void testGetRecords() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();
        System.assertNotEquals(null, filterSet);

        List<String> records = filterSet.getFieldRecords(filterSet.filters[0]);
        System.assertNotEquals(null, records);
        System.debug('Records: ' + records);

        Test.stopTest();
    }

    @IsTest
    private static void testGetFieldName() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();
        System.assertNotEquals(null, filterSet);

        String fieldName = filterSet.getFieldName(filterSet.filters[0]);
        System.assertNotEquals(null, fieldName);

        Test.stopTest();
    }

    @IsTest
    private static void testGetFilterEntries() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();
        System.assertNotEquals(null, filterSet);

        List<X7S_Members_Filter_Entry__c> entries = filterSet.getFilterEntries(filterSet.filters[0]);
        System.assertNotEquals(null, entries);

        Test.stopTest();
    }
}