/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpJSONFeedControllerTest {
    /*
       Mock callout
    */
    private class mockCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = 'test body';
            res.setBody(body);
            return res;
        }
    }

    @IsTest
    static void testGetJSONFeed() {
        // Set mock
        Test.setMock(HttpCalloutMock.class, new mockCallout());

        Test.startTest();

        // Get it!
        x7sExpJSONFeedController.ResponseWrapper testResponseWrapper = x7sExpJSONFeedController.getJSONFeed('endpoint does not matter, mock will be used', 'feed type does not matter, default will be used');

        // Assert that the two test feed items are found!
        System.assertEquals(testResponseWrapper.responseCode, 200);

        // Test debug/test mode
        testResponseWrapper = x7sExpJSONFeedController.getJSONFeed('endpoint does not matter, mock will be used', x7sExpJSONFeedController.FEED_TYPE_TEST);
        System.assertEquals(testResponseWrapper.responseCode, 200);

        Test.stopTest();
    }
}