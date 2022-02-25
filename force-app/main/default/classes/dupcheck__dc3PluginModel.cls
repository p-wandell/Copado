/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3PluginModel {
    global dc3PluginModel() {

    }
global class DirectProcessBeforeInput {
    global Boolean doConvert;
    global Boolean doMerge;
    global String feature;
    global SObject objectData;
    global String objectPrefix;
    global Map<String,List<dupcheck.dc3SearchResult>> searchResults;
    global DirectProcessBeforeInput(Boolean c, Boolean m, SObject o, String p, Map<String,List<dupcheck.dc3SearchResult>> r, String f) {

    }
}
global class DirectProcessBeforeOutput {
    global Boolean doConvert;
    global Boolean doMerge;
    global Map<String,List<dupcheck.dc3SearchResult>> searchResults;
    global Boolean storeAsJob;
    global DirectProcessBeforeOutput(dupcheck.dc3PluginModel.DirectProcessBeforeInput input) {

    }
}
global class MergeSetFieldInput {
    global Map<String,Object> customValueMap;
    global Map<String,String> fieldSourceMap;
    global String masterRecordId;
    global List<SObject> objectDataList;
    global String objectPrefix;
    global MergeSetFieldInput(String p, Id mr, Map<String,String> mf, List<SObject> d) {

    }
    global MergeSetFieldInput(String p, Id mr, Map<String,String> mf, List<SObject> d, Map<String,Object> cvm) {

    }
}
global class MergeSetFieldOutput {
    global Map<String,Object> customValueMap;
    global Map<String,String> fieldSourceMap;
    global MergeSetFieldOutput(dupcheck.dc3PluginModel.MergeSetFieldInput input) {

    }
}
global class MergeSetMasterInput {
    global Id masterRecordId;
    global List<SObject> objectDataList;
    global String objectPrefix;
    global MergeSetMasterInput(String p, Id m, List<SObject> o) {

    }
}
global class MergeSetMasterOutput {
    global Id masterRecordId;
    global MergeSetMasterOutput(dupcheck.dc3PluginModel.MergeSetMasterInput input) {

    }
}
global class SearchBeforeInput {
    global Boolean crossObjectSearch;
    global List<String> feature;
    global String filter;
    global Map<String,Object> objectData;
    global String objectPrefix;
    global List<dupcheck.dc3Config.Scenario> scenarioList;
    global SearchBeforeInput(String p, Map<String,Object> o, List<dupcheck.dc3Config.Scenario> s, Boolean c, String f, List<String> t) {

    }
}
global class SearchBeforeOutput {
    global Boolean crossObjectSearch;
    global String filter;
    global Map<String,Object> objectData;
    global Set<Id> scenarioIdSet;
    global SearchBeforeOutput(dupcheck.dc3PluginModel.SearchBeforeInput input) {

    }
}
}
