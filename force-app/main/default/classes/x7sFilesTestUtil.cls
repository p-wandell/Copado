/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesTestUtil {
    @TestVisible static private Map<String, List<SObject>> MetadataCoverageRecordMap = new Map<String, List<SObject>>();

    public List<SObject> getMetadataRecord (String query) {
        if(!MetadataCoverageRecordMap.containsKey( query )) {
            MetadataCoverageRecordMap.put(query , Database.query( query ));
        }
        return MetadataCoverageRecordMap.get(query);
    }
}