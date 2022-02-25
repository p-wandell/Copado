/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sIdeasCommonTest {

	@IsTest
	static void test_X7s_Ideas_Common() {
		x7sIdeasCommon common = new x7sIdeasCommon('', true);

		// custom settings
		System.assertNotEquals(null, common);
		System.assertNotEquals(null, common.allowDownVoting);
		System.assertNotEquals(null, common.showAlternateCTA);
		//System.assertNotEquals(null, common.voteDisableStatus);
		//System.assertNotEquals(null, common.emailIdeaStatusTemplate);
		//System.assertNotEquals(null, common.chatterProfiles);
		System.assertNotEquals(null, common.customFields);

		System.assertNotEquals(null, common.debugMode);
		System.assertNotEquals(null, common.nicknameEnabled);
		System.assertNotEquals(null, common.isAuthenticated);
		System.assertNotEquals(null, common.zoneId);

		x7sIdeasCommon.dumpSettings('Test', common);
		x7sIdeasCommon.dumpFieldSet('Field set', common.customFields);

		x7sIdeasCommon common2 = new x7sIdeasCommon('');
		System.assertNotEquals(null, common2);
	}

	@IsTest
	static void testGetCustomQuery() {
		x7sIdeasCommon common = new x7sIdeasCommon('', true);

		System.assertNotEquals(null, common.getCustomFieldQuery());
		System.assertNotEquals(null, common.getCustomFieldSetQuery());
	}

	@IsTest
	static void testCustomFields() {
		x7sIdeasCommon common = new x7sIdeasCommon('', true);
		System.assertNotEquals(null, common);
		List<x7sIdeasCustomField> customFields = common.getCustomFields('default');
		System.debug('CustomFields: ' + customFields);
	}

	@IsTest
	static void testParseFieldSets() {
		x7sIdeasCommon common = new x7sIdeasCommon('', true);
		X7S_Ideas_Field_Set__mdt fieldSet = new X7S_Ideas_Field_Set__mdt();
		List<x7sIdeasCustomField> customFields = common.parseFieldSet(fieldSet);
		System.assertNotEquals(null, customFields);
	}
}