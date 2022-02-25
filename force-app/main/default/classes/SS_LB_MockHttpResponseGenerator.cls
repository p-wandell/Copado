/**
 * Created by francoiskorb on 8/22/17.
 */

@isTest
global class SS_LB_MockHttpResponseGenerator implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		// Send a mock response for a specific endpoint and method.
//		String httpUrl = System.URL.getSalesforceBaseUrl().toExternalForm().toLowerCase();
//		String endpointUrl = httpUrl + '/services/data/v40.0/connect/communities/null/chatter/users/batch/';
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