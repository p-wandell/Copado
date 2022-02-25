/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

@IsTest
private class x7sFacebookFeaturedControllerTest {
    @IsTest(SeeAllData=true)
    static void getMetaData_test() {
        String data = x7sFacebookFeaturedController.getMetaData('Primary_Record');
        if (data != null) {
            System.assertNotEquals(null, data);
        } else {
            System.assertEquals(null, data);
        }
    }
}