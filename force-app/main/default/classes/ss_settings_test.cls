/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/18/17.
 */

@IsTest
public with sharing class ss_settings_test {

	@IsTest
	static void testCommon() {
		ss_settings settings = new ss_settings();

		System.assertNotEquals(null, settings);
		System.assertNotEquals(null, settings.usePoints);
		System.assertNotEquals(null, settings.hideAddToCart);
		System.assertNotEquals(null, settings.hideImages);
		System.assertNotEquals(null, settings.hideUnitPrice);
		System.assertNotEquals(null, settings.enableDiscount);

		settings = new ss_settings('Default');
		settings = new ss_settings('UnKnown');
	}

	@IsTest
	static void testUsePoints() {
		ss_settings settings = new ss_settings(null, true, null);

		System.assertEquals(null,  settings.accountId);
		System.assertEquals(true,  settings.usePoints);
		System.assertEquals(null,  settings.pricebookId);
		System.assertEquals(false, settings.hideAddToCart);
		System.assertEquals(false, settings.hideImages);
		System.assertEquals(false, settings.hideUnitPrice);
	}
}