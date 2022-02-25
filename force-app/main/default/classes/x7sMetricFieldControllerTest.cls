/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public class x7sMetricFieldControllerTest {
	//  Creating setup data
	@TestSetup
	static void metricFieldTestData() {
		Set<String> customerUserTypes = new Set<String>{'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess', 'CustomerSuccess', 'CspLitePortal'};

		Account acc = new Account (
			Name = 'x7snewAcc1'
		);
		insert acc;

		Contact con = new Contact (
			AccountId = acc.Id,
			LastName = 'x7sPortalTestUser'
		);
		insert con;

		Profile profileRec = [SELECT Id,Name FROM Profile WHERE UserType IN :customerUserTypes LIMIT 1];

		User newUser = new User(
			ProfileId = profileRec.Id,
			Username = 'x7sNewUser@7summits.com',
			Email = 'x7s_pb@ff.com',
			EmailEncodingKey = 'UTF-8',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			TimeZoneSidKey = 'America/Los_Angeles',
			Alias = 'nuser',
			LastName = 'x7sLastname',
			ContactId = con.Id
		);
		insert newUser;
	}

	@IsTest
	static void metricContactFieldTest() {
		List<String> fieldNames = new List<String>{'Name', 'Contact.LastName', 'Contact.Account.Name', 'Email'};
		String contactData = x7sMetricFieldController.fetchMetricsData(fieldNames);
		System.assertNotEquals(null, contactData);
	}
}