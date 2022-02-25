/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
public with sharing class x7sFilesCMTDynamicPicklistTest {
    @IsTest(SeeAllData=true)
    public static void getDefaultValue() {

        x7sFilesCMTDynamicPicklist topicList = new x7sFilesCMTDynamicPicklist();

        VisualEditor.DataRow row = topicList.getDefaultValue();

        VisualEditor.DataRow expectedResult = new VisualEditor.DataRow('Default', '');

        System.assertEquals(expectedResult.getLabel(), row.getLabel());
        System.assertNotEquals(null, expectedResult.getValue());
        System.assertEquals(expectedResult.isSelected(), row.isSelected());
    }

    @IsTest(SeeAllData=true)
    public static void getValues() {
        x7sFilesCMTDynamicPicklist settingList = new x7sFilesCMTDynamicPicklist();

        VisualEditor.DynamicPickListRows rows = settingList.getValues();

        // check the default row
        VisualEditor.DataRow defaultRow = rows.get(0);
        VisualEditor.DataRow expectedResult = new VisualEditor.DataRow('Default', '');
        System.assertNotEquals(null, defaultRow);
        System.assertNotEquals(null, expectedResult);
    }
}