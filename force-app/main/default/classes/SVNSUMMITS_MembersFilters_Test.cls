/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 10/19/17.
 */

@IsTest
private class SVNSUMMITS_MembersFilters_Test
{
	@IsTest
	private static void testFilterGetFilter()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();
		System.assertNotEquals(null, filterSet);
		System.debug('Filter set : ' + filterSet);

		Members_Filter__mdt testFilter = filterSet.getFilterByName(filterSet.filters[0].DeveloperName);
		System.assertNotEquals(null, testFilter);

		testFilter = filterSet.getFilterByName('SHOULD_NOT_EXIST');
		System.assertEquals(null, testFilter);

		for(Members_Filter__mdt filter : filterSet.filters)
		{
			testFilter = filterSet.getFilterByFieldName(filter.Field_Name__c);
			System.assertNotEquals(null, testFilter);
		}

		testFilter = filterSet.getFilterByFieldName('SHOULD_NOT_EXIST');
		System.assertEquals(null, testFilter);

		test.stopTest();
	}

	@IsTest
	private static void testClearFilter()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();
		System.assertNotEquals(null, filterSet);

		MembersFilter__c clearFilter = filterSet.clearFilter(filterSet.filters[0].DeveloperName);
		System.assertNotEquals(null, clearFilter);

		Test.stopTest();
	}

	@IsTest
	private static void testGetRecords()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();
		System.assertNotEquals(null, filterSet);

		List<String> records = filterSet.getFieldRecords(filterSet.filters[0]);
		System.assertNotEquals(null, records);
		System.debug('Records: ' + records);

		Test.stopTest();
	}

	@IsTest
	private static void testGetFieldName()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();
		System.assertNotEquals(null, filterSet);

		String fieldName = filterSet.getFieldName(filterSet.filters[0]);
		System.assertNotEquals(null, fieldName);

		Test.stopTest();
	}

	@IsTest
	private static void testGetFilterEntries()
	{
		Test.startTest();

		SVNSUMMITS_MembersFilters filterSet = new SVNSUMMITS_MembersFilters();
		System.assertNotEquals(null, filterSet);

		List<MembersFilterEntry__c> entries = filterSet.getFilterEntries(filterSet.filters[0]);
		System.assertNotEquals(null, entries);

		Test.stopTest();
	}
}