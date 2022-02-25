/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sLinkedInFeaturedControllerTest {
    @IsTest(SeeAllData=true)
    static void test_getMetaData() {
        String data = x7sLinkedInFeaturedController.getMetaData('Primary_Record');
        System.assertNotEquals(null, data);
    }
}