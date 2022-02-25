/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
public class x7sFilesTestUtilTest {

    @IsTest
    static void testGetMetadataRecord() {
        List<SObject> metdataCoverageRecords;

        Test.startTest();
            x7sFilesTestUtil testUtil = new x7sFilesTestUtil();
            metdataCoverageRecords = testUtil.getMetadataRecord('SELECT MasterLabel FROM X7S_Files_Setting__mdt');
        Test.stopTest();

        System.assertEquals( [SELECT MasterLabel FROM X7S_Files_Setting__mdt].size() , metdataCoverageRecords.size() , 'Both Sizes must match');
    }

    //Utility Method
    public static void setMetadata (String query, List<SObject> records) {
        x7sFilesTestUtil.MetadataCoverageRecordMap.put( query , records);
    }
}