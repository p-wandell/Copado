/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 10/19/17.
 */

@IsTest
private class SVNSUMMITS_MembersFilterBatch_Test
{

	// Can only be called once
	@IsTest
	public static void testFilterBatch()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();

		SVNSUMMITS_MembersFilterBatch filterBatch = new SVNSUMMITS_MembersFilterBatch(filterSet.filters[0].DeveloperName);
		System.debug('testFilterBatch with ' + filterBatch.fieldName);

		Id batchProcessId = Database.executeBatch(filterBatch);
		System.assertNotEquals(null, batchProcessId);

		Test.stopTest();
	}
}