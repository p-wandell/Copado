/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sMembersFilterBatch_Test {

    // Can only be called once
    @IsTest
    public static void testFilterBatch() {
        Test.startTest();

        x7sMembersFilters filterSet = new x7sMembersFilters();

        x7sMembersFilterBatch filterBatch = new x7sMembersFilterBatch(filterSet.filters[0].DeveloperName);
        System.debug('testFilterBatch with ' + filterBatch.fieldName);

        Id batchProcessId = Database.executeBatch(filterBatch);
        System.assertNotEquals(null, batchProcessId);

        Test.stopTest();
    }
}