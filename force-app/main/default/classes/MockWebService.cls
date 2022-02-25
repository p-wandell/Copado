/**
 * Created by jasondaluga on 6/28/18.
 */

@IsTest
global class MockWebService implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Send a mock response for a specific endpoint and method.
        String endpointUrl = req.getEndpoint();
        System.assertEquals(endpointUrl, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}