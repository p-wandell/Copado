/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
global class x7sExpMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HttpResponse respond(HttpRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals(System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v40.0/connect/communities/null/chatter/users/batch/', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}