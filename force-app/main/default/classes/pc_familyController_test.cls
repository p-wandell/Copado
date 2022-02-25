/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francoiskorb on 11/28/17.
 */

@IsTest
public with sharing class pc_familyController_test
{
	@IsTest
	static void testFamily()
	{
		pc_family family = new pc_family('family1', 'familyUrl');
		System.assertEquals('family1', family.name);
	}

	@IsTest
	static void testFamilyController()
	{
		List<pc_family> familyList = pc_familyController.getProductFamilyList('');
		System.assertNotEquals(null, familyList);
	}
}