/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */

@IsTest(SeeAllData=true)
public with sharing class x7S_FeedItemTriggerHandlerTest {
    @IsTest
    public static void testFeedItemTrigger() {
        // Create contact
        Contact testContact = Peak_TestUtils.createTestContact();
        
        // Insert feed item
        FeedItem testFeed = new FeedItem(Body = 'Test Feed 1 Post', ParentId = testContact.Id, Type = 'ContentPost');
        insert testFeed;
    }
}