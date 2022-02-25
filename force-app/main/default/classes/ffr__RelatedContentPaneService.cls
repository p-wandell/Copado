/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RelatedContentPaneService {
    global RelatedContentPaneService() {

    }
    global static List<ffr.RelatedContentPaneService.Component> getComponents(Set<Id> componentIds) {
        return null;
    }
    global static ffr.RelatedContentPaneService.RcpData getRcpData(Id rcpId, Id dataId) {
        return null;
    }
    global static List<ffr.RelatedContentPaneService.RCPSummary> getRcpIdentities() {
        return null;
    }
    global static List<ffr.RelatedContentPaneService.Pane> load(Set<Id> relatedContentPaneIds) {
        return null;
    }
    global static Object rcpPaletteCommand(ffr.RelatedContentPaneService.RcpPaletteCommandRequest request) {
        return null;
    }
    global static Object rcpServerCommand(ffr.RelatedContentPaneService.RcpServerCommandRequest request) {
        return null;
    }
    global static ffr.RelatedContentPaneService.SaveRcpDataResponse saveRcpData(ffr.RelatedContentPaneService.SaveRcpDataRequest request) {
        return null;
    }
    global static List<ffr.RelatedContentPaneService.Pane> save(List<ffr.RelatedContentPaneService.Pane> relatedContentPaneDTOs) {
        return null;
    }
global class Component {
    global String ApexClass {
        get;
        set;
    }
    global String Config {
        get;
        set;
    }
    global Integer Height {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String RuntimeClass {
        get;
        set;
    }
    global Integer Width {
        get;
        set;
    }
    global Component() {

    }
    global Component(ffr__RelatedContentPaneComponent__c sObj) {

    }
    global Component(ffr__RelatedContentPaneComponent__c sObj, String runtimeClass) {

    }
    global ffr__RelatedContentPaneComponent__c createSObject() {
        return null;
    }
}
global class Pane {
    global String DrivingEntity {
        get;
        set;
    }
    global String DrivingEntityLabel {
        get;
    }
    global Id Id {
        get;
        set;
    }
    global Datetime LastModifiedDate {
        get;
    }
    global String Name {
        get;
        set;
    }
    global String PaneWidth {
        get;
        set;
    }
    global List<ffr.RelatedContentPaneService.Tab> Tabs {
        get;
        set;
    }
    global List<String> TemplateNamesInUse {
        get;
        set;
    }
    global Pane() {

    }
    global Pane(ffr__RelatedContentPane__c sObj) {

    }
    global ffr__RelatedContentPane__c createSObject() {
        return null;
    }
}
global class RCPSummary {
    global String DrivingEntity {
        get;
    }
    global Id Id {
        get;
    }
    global String Name {
        get;
    }
    global RCPSummary(Id theId, String theName, String theDrivingEntity) {

    }
}
global class RcpData {
    global SObject Data {
        get;
        set;
    }
    global Map<String,Object> ExtraData {
        get;
        set;
    }
    global ffr.RelatedContentPaneService.RcpMetadata Metadata {
        get;
        set;
    }
    global Map<String,ffr.PaletteSectionService.Component> PaletteData {
        get;
        set;
    }
    global ffr.RelatedContentPaneService.Pane Rcp {
        get;
        set;
    }
    global RcpData() {

    }
}
global class RcpMetadata {
    global Map<String,ffr.CommonService.Field> Fields {
        get;
        set;
    }
    global Map<String,ffr.RelatedContentPaneService.RcpMetadata> Lookups {
        get;
        set;
    }
    global String RelationshipName {
        get;
        set;
    }
    global Map<String,ffr.RelatedContentPaneService.RcpMetadata> Relationships {
        get;
        set;
    }
    global RcpMetadata() {

    }
}
global class RcpPaletteCommandRequest {
    global String apexClass {
        get;
        set;
    }
    global String arg {
        get;
        set;
    }
    global String command {
        get;
        set;
    }
    global String drivingEntity {
        get;
        set;
    }
    global RcpPaletteCommandRequest() {

    }
}
global class RcpServerCommandRequest {
    global String apexClass {
        get;
        set;
    }
    global String arg {
        get;
        set;
    }
    global String command {
        get;
        set;
    }
    global Id componentId {
        get;
        set;
    }
    global Id dataId {
        get;
        set;
    }
    global Id rcpId {
        get;
        set;
    }
    global RcpServerCommandRequest() {

    }
}
global class SaveRcpDataRequest {
    global Id RcpId {
        get;
        set;
    }
    global List<ffr.RelatedContentPaneService.SaveRecordRequest> Records {
        get;
        set;
    }
    global SaveRcpDataRequest() {

    }
}
global class SaveRcpDataResponse {
    global SaveRcpDataResponse() {

    }
}
global class SaveRecordRequest {
    global Id Id {
        get;
        set;
    }
    global List<String> Path {
        get;
        set;
    }
    global Map<String,Object> Values {
        get;
        set;
    }
    global SaveRecordRequest() {

    }
    global SObject constructRecord() {
        return null;
    }
    global Set<Schema.SObjectField> getAffectedFields() {
        return null;
    }
    global Schema.SObjectType getSObjectType() {
        return null;
    }
}
global class Tab {
    global List<ffr.RelatedContentPaneService.Component> Components {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global Tab() {

    }
    global Tab(ffr__RelatedContentPaneTab__c sObj) {

    }
    global ffr__RelatedContentPaneTab__c createSObject() {
        return null;
    }
}
}
