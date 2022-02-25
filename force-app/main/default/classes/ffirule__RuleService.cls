/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RuleService {
    global RuleService() {

    }
    global static List<Id> clone(List<Id> ruleIds) {
        return null;
    }
    global static List<Id> createMappings(List<ffirule.RuleService.CreateMappingInfo> createMappingInfos) {
        return null;
    }
    global static Map<Schema.SObjectType,List<ffirule.RuleService.Action>> resolveActions(Map<Schema.SObjectType,List<String>> sourceObjectActions) {
        return null;
    }
    global static List<Id> run(List<Id> sourceRecordIds, Id ruleId) {
        return null;
    }
    global static List<Id> run(List<Id> sourceRecordIds, String actionName, Boolean updateFeed) {
        return null;
    }
global class Action {
    global String ActionMessage;
    global String ActionName;
    global String FeedLinkMessage;
    global String FeedLinkMessageTarget;
    global String FeedMessage;
    global String FeedMessageTarget;
    global Id RuleId;
    global Action() {

    }
}
global class CreateMappingInfo {
    global Id RuleId;
    global String SourceField;
    global String TargetField;
    global CreateMappingInfo() {

    }
}
}
