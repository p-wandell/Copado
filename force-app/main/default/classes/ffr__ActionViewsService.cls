/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ActionViewsService {
    global static ffr.ActionViewsService.ValidationResult Validate(Id dataviewId, Id actionId, ffr.SelectionService.Result selectedData) {
        return null;
    }
    global static void deletePersonalSetting(Id templateId) {

    }
    global static ffr.SelectionService.Result getData(ffr.InquiryTemplateService.InquiryTemplate template) {
        return null;
    }
    global static ffr.SelectionService.Result getData(Id dataviewId, String basePeriod, List<Id> fieldList, List<ffr.InquiryTemplateService.InquiryTemplateFilter> filterList) {
        return null;
    }
    global static ffr.SelectionService.Result getData(Id dataviewId, String basePeriod, List<Id> fieldList, List<ffr.InquiryTemplateService.InquiryTemplateFilter> filterList, Map<Id,List<ffr.DataViewService.DataViewJoinFilter>> joinFilterMap) {
        return null;
    }
    global static ffr.ActionViewsService.DrillData getDrillData(Id sourceTemplateID, Id destinationTemplateID, String basePeriod, List<ffr.InquiryTemplateService.InquiryTemplateFilter> currentfilterList, List<ffr.InquiryTemplateService.InquiryTemplateFilter> columnFilters, List<ffr.InquiryTemplateService.InquiryTemplateFilter> summarizationTemplateFilterList, Map<String,String> drillContext) {
        return null;
    }
    global static ffr.ActionViewsService.ActionViewsPersonalSetting getPersonalSettingsForTemplateAndUser(Id templateId) {
        return null;
    }
    global static Boolean hasPrompts(ffr.InquiryTemplateService.InquiryTemplate template) {
        return null;
    }
    global static ffr.ActionViewsService.ActionResult invokeAction(Id dataviewId, Id actionId, ffr.SelectionService.Result selectedData, Map<String,String> promptValues) {
        return null;
    }
    global static ffr.ActionViewsService.ActionViewsPersonalSetting savePersonalSettings(ffr.ActionViewsService.ActionViewsPersonalSetting settingsDTO) {
        return null;
    }
global class ActionResult {
    global Boolean RequiresRefresh {
        get;
        set;
    }
    global ffr.ActionViewsService.MessageLevel StatusCategory {
        get;
        set;
    }
    global String StatusMessage {
        get;
        set;
    }
    global ActionResult() {

    }
}
global class ActionViewsPersonalSetting {
    global Id Id {
        get;
        set;
    }
    global Id InquiryTemplateId {
        get;
        set;
    }
    global List<ffr.ActionViewsService.ActionViewsSetting> Settings {
        get;
        set;
    }
    global ActionViewsPersonalSetting() {

    }
    global ActionViewsPersonalSetting(ffr__ActionViewsPersonalSetting__c sObj, List<ffr.ActionViewsService.ActionViewsSetting> settingsList) {

    }
    global ffr__ActionViewsPersonalSetting__c createSObject(String settingResult) {
        return null;
    }
}
global class ActionViewsSetting {
    global String Key {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global ActionViewsSetting() {

    }
}
global class DrillData {
    global List<ffr.InquiryTemplateService.InquiryTemplateFilter> FilterUsed;
    global ffr.SelectionService.Result Result;
    global ffr.InquiryTemplateService.InquiryTemplate Template;
    global DrillData() {

    }
}
global enum MessageLevel {ERROR, SUCCESS, WARNING}
global class ValidationResult {
    global List<ffr.DataViewService.ParameterMetadataType> parameterMetaData {
        get;
        set;
    }
    global ffr.ActionViewsService.MessageLevel StatusCategory {
        get;
        set;
    }
    global String StatusMessage {
        get;
        set;
    }
    global ValidationResult() {

    }
}
}
