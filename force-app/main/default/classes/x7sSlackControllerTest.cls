@IsTest
public with sharing class x7sSlackControllerTest {
    /*
       Mock callout
    */
    private class mockCallout implements HttpCalloutMock {
        public HttpResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = 'test body';
            res.setBody(body);
            return res;
        }
    }

    static testMethod void testGetSLACKFeed() {
        // Set mock
        Test.setMock(HttpCalloutMock.class, new mockCallout());

        Test.startTest();

        // Get it!
        x7sSlackController.ResponseWrapper testResponseWrapper = x7sSlackController.getChannelFeed('CUV9876Y',10);

        // Assert that the two test feed items are found!
        System.assertEquals(testResponseWrapper.responseCode,200);
        System.assertNotEquals(testResponseWrapper.errorMessage, 'Bad Request');

        x7sSlackController.ResponseWrapper testResponseWrapper1 = x7sSlackController.getUsersList();
        System.assertEquals(testResponseWrapper1.responseCode,200);
        System.assertNotEquals(testResponseWrapper1.errorMessage, 'Bad Request');

        x7sSlackController.ResponseWrapper testResponseWrapper2 = x7sSlackController.postToSlack('test post','CUV9876Y');
        System.assertEquals(testResponseWrapper2.responseCode,200);
        System.assertNotEquals(testResponseWrapper2.errorMessage, 'Bad Request');

        Test.stopTest();
    }
    
    static testMethod void testSlackImage() {
        // Set mock
        Test.setMock(HttpCalloutMock.class, new mockCallout());

        Test.startTest();
        x7sSlackController.ResponseWrapper testResponseWrapper = x7sSlackController.slackImage('testimage');
        Test.stopTest();
    }
}