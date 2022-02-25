/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/6/18.
 */

@IsTest
private class SS_VG_Controller_Test
{
	@IsTest
	static void testBehavior()
	{
		//lets check if the field exist on account or not
		Schema.DescribeSObjectResult objDescribe = Account.SObjectType.getDescribe();
		Boolean doesGalleryFieldExist = objDescribe.fields.getMap().keySet().contains(SS_VG_Controller.LIST_FIELD_NAME);

		Account newAccount = new Account();
		newAccount.Name = 'test Account';

		insert newAccount;

		SS_VG_Response response = SS_VG_Controller.getInitialData(newAccount.Id);
		if (doesGalleryFieldExist)
		{
			System.assert(response.success == true);
			System.debug(response.results.size());
			System.assert(response.results.size() == 0);
		} else
		{
			System.assert(response.success == false);
			System.assert(response.messages[0] == 'The Video List custom field has not yet been created for this object.');
		}

		//now update the gallery list field

		if (doesGalleryFieldExist)
		{
			newAccount.put(SS_VG_Controller.LIST_FIELD_NAME, '111122221,32323232321');
		}

		update newAccount;
		response = SS_VG_Controller.getInitialData(newAccount.Id);
		if (doesGalleryFieldExist)
		{
			System.assert(response.success = true);
			System.assert(response.results.size() == 2);
		} else
		{
			System.assert(response.success == false);
			System.assert(response.messages[0] == 'The Video List custom field has not yet been created for this object.');
		}

		//lets try on some odd object where possibility of having this field is very less
		Topic newTopic = new Topic();
		newTopic.Name = 'xyz';
		insert newTopic;

		doesGalleryFieldExist = Topic.SObjectType.getDescribe().fields.getMap().keySet().contains(SS_VG_Controller.LIST_FIELD_NAME);
		response = SS_VG_Controller.getInitialData(newTopic.Id);
		if (doesGalleryFieldExist)
		{
			System.assert(response.success == true);
			System.debug(response.results.size());
			System.assert(response.results.size() == 0);
		} else
		{
			System.assert(response.success == false);
			System.assert(response.messages[0] == 'The Video List custom field has not yet been created for this object.');
		}


	}
}