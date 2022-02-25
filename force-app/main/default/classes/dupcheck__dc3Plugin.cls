/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3Plugin {
    global dc3Plugin() {

    }
global class DefaultConvert implements dupcheck.dc3Plugin.InterfaceConvert {
    global DefaultConvert() {

    }
    global void afterConvert(Database.LeadConvertResult leadConvertResult, Task taskData) {

    }
    global void beforeConvert(Database.LeadConvert leadConvertData) {

    }
    global void convertFailed(Database.LeadConvert leadConvertData, dupcheck.dc3Exception.ConvertException exceptionData) {

    }
}
global class DefaultMerge implements dupcheck.dc3Plugin.InterfaceMerge {
    global DefaultMerge() {

    }
    global void afterMerge(String objectPrefix, SObject masterRecord, Set<Id> mergedRecordIds) {

    }
    global void beforeMerge(String objectPrefix, SObject masterRecord, List<SObject> mergedRecordList) {

    }
    global void mergeFailed(String objectPrefix, SObject masterRecord, Set<Id> mergedRecordsIds, dupcheck.dc3Exception.MergeException exceptionData) {

    }
}
global class DefaultPrevention implements dupcheck.dc3Plugin.InterfacePrevention {
    global DefaultPrevention() {

    }
    global void processStatus(Set<Id> recordIdSet, dupcheck.dc3Plugin.PreventionStatus status) {

    }
}
global class DefaultSearch implements dupcheck.dc3Plugin.InterfaceSearch {
    global DefaultSearch() {

    }
    global void processResults(String methodName, Id sourceId, Map<String,List<dupcheck.dc3SearchResult>> searchResults) {

    }
}
global interface InterfaceConvert {
    void afterConvert(Database.LeadConvertResult param0, Task param1);
    void beforeConvert(Database.LeadConvert param0);
    void convertFailed(Database.LeadConvert param0, dupcheck.dc3Exception.ConvertException param1);
}
global interface InterfaceMerge {
    void afterMerge(String param0, SObject param1, Set<Id> param2);
    void beforeMerge(String param0, SObject param1, List<SObject> param2);
    void mergeFailed(String param0, SObject param1, Set<Id> param2, dupcheck.dc3Exception.MergeException param3);
}
global interface InterfacePrevention {
    void processStatus(Set<Id> param0, dupcheck.dc3Plugin.PreventionStatus param1);
}
global interface InterfaceSearch {
    void processResults(String param0, Id param1, Map<String,List<dupcheck.dc3SearchResult>> param2);
}
global enum PluginEventType {CACHE_GET, CACHE_PUT, DIRECT_PROCESS_BEFORE, MERGE_SET_FIELD, MERGE_SET_MASTER, SEARCH_AFTER, SEARCH_BEFORE}
global enum PreventionStatus {DELTA, DIRECT, DUPLICATE, OVERRIDDEN, UNIQUE, WEB2LEAD}
}
