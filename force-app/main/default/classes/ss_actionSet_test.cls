/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/17/18.
 */

@IsTest
private class ss_actionSet_test
{
	static testMethod void test_actionModel()
	{
		ss_actionModel model = new ss_actionModel();
		System.assertNotEquals(null, model);
		model.Dump('Test Model');
	}

	static testMethod void test_actionSet()
	{
		ss_actionSet actionSet = new ss_actionSet();
		System.assertNotEquals(null, actionSet);

		ss_actionModel model = new ss_actionModel();
		model.name       = 'testModel1';
		model.label      = 'testLabel1';
		model.actionType = 'Flow';
		actionSet.items.add(model);

		model = new ss_actionModel();
		model.name       = 'testModel2';
		model.label      = 'testLabel2';
		model.actionType = 'URL';
		actionSet.items.add(model);

		actionSet.Dump('Test Set');
	}

	@IsTest
	static void testMetaDataBuildQuery()
	{
		String query = ss_util_metadata.buildQuery('SS_Product_Settings__mdt', '');
		System.debug('SS_Product_Settings__mdt query: ' + query);
		System.assert(query.length() > 0);
	}

	@IsTest
	static void testMetadataBuildSubQuery()
	{
		String query = ss_util_metadata.buildQuery('SS_Product_Action__mdt', '');
		System.debug('Action query: ' + query);

		List<String> subQueryParts = new List<String>();

		for (Integer i = 1; i <= 5; i++)
		{
			String subQuery = ss_util_metadata.buildSubQuery('Action_'+ i + '__r', query);
			System.debug('Action sub query: ' + subQuery);
			System.assert(subQuery.length() > 0);
			subQueryParts.add(subQuery);
		}

		query = ss_util_metadata.buildQuery('SS_Product_Settings__mdt', String.join(subQueryParts, ','));
		System.debug('SS_Product_Settings__mdt query: ' + query);
		System.assert(query.length() > 0);
	}
}