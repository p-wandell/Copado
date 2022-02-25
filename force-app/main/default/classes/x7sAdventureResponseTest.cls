/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sAdventureResponseTest {

    @IsTest
    public static void testAdventureResponse() {
        x7sAdventureResponse response = new x7sAdventureResponse();

        // Test success flag
        System.assertEquals(response.success, true);

        // Test messages
        response.messages.add(x7sAdventureTestConstants.TEST_MESSAGE);
        System.assertEquals(response.messages[0], x7sAdventureTestConstants.TEST_MESSAGE);

        // Test object list
        Account account = x7sAdventureTestUtils.createTestAccount();
        response.results.add(account);
        System.assertEquals(account, response.results[0]);
    }
}