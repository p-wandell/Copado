/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpContentObjectHelperTest {

    @IsTest
    public static void testFormatFromString() {
        // Create a x7sExp Content Object from helper
        x7sExpContentObjectHelper contentObjectHelper = new x7sExpContentObjectHelper();
        x7sExpContentObject testObject = contentObjectHelper.formatFromString(x7sExpTestConstants.TEST_GROUPNAME);

        // Assert its name property was set
        System.assertEquals(testObject.title, x7sExpTestConstants.TEST_GROUPNAME);
    }
}