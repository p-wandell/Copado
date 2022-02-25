/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpMyStatsControllerTest {

    @IsTest
    public static void testStatsController() {

        // Assert simple static test
        System.assertEquals(x7sExpMyStatsController.getSampleStatApex().figure1, 2);

        Test.startTest();

        // Assert 1 closed opp found
        System.assert(x7sExpMyStatsController.getMyClosedWonOpps() != null);
        // Assert 1 open opp found
        System.assert(x7sExpMyStatsController.getMyNewOpps() != null);

        Test.stopTest();

    }

}