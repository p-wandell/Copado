/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sAdventureContentObjectHelperTest
{

    @IsTest
    public static void testFormatContentObject() {
        // Create a Content Object from helper
        x7sAdventureContentObjectHelper contentObjectHelper = new x7sAdventureContentObjectHelper();
        System.assertNotEquals(null, contentObjectHelper);

        x7sAdventureContentObject testObject = x7sAdventureContentObjectHelper.formatContentObject(null,null,null);

        // Assert its name property was set
        System.assertEquals(testObject.adventure, null);
    }


}