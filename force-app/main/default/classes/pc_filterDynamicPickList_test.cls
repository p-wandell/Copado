/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/27/17.
 */

@IsTest
public with sharing class pc_filterDynamicPickList_test {

	private static final String pickListDefault = 'All';
	@IsTest
	public static void getDefaultValue() {
		pc_filterDynamicPickList pickList = new pc_filterDynamicPickList();
		VisualEditor.DataRow row = pickList.getDefaultValue();
		VisualEditor.DataRow expectedResult = new VisualEditor.DataRow(pickListDefault, pickListDefault);

		System.assertEquals(expectedResult.getLabel(), row.getLabel());
		System.assertEquals(expectedResult.getValue(), row.getValue());
		System.assertEquals(expectedResult.isSelected(), row.isSelected());
	}

	@IsTest
	public static void getValues() {
		pc_filterDynamicPickList pickList = new pc_filterDynamicPickList();

		VisualEditor.DynamicPickListRows rows = pickList.getValues();

		System.assert(rows.size() > 0);
		System.debug('Total Product2 family picklist values found: ' + rows.size());

		// check the default row
		VisualEditor.DataRow defaultRow = rows.get(0);
		VisualEditor.DataRow expectedResult = new VisualEditor.DataRow(pickListDefault, pickListDefault);

		System.assertEquals(defaultRow.getLabel(), expectedResult.getLabel());
		System.assertEquals(defaultRow.getValue(), expectedResult.getValue());
		System.assertEquals(defaultRow.isSelected(), expectedResult.isSelected());
	}
}