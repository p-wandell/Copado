/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/21/17.
 */

@IsTest
public with sharing class pc_filterController_test {

	@IsTest
	static void testGetPicklistValues() {
		List<String> values = pc_filterController.getPicklistValues('Product2', 'Family');
		System.assertNotEquals(null, values);
	}
}