public class CopadoProjectTriggerHandler {
    public static boolean m_isExecuting = false; 
    public static List<Field_Mapping_Template__mdt> fieldMappings;
    public static List<Jira_Status_Mapping_Template__mdt> statusMappings;
    public static List<ALMRecordTypeMapping__mdt> recordTypeMappings;
    
    //-------------------------------------------------------------------------  
    // On before insert trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeInsert(List<copado__Project__c> newList) {

    } 
    
    //-------------------------------------------------------------------------
    // On after insert trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterInsert(List<copado__Project__c> newList) {
        System.debug('****** On After Insert *****');
        System.debug('****** newList: ' + newList);
        List<copado__Project__c> newJiraProjects = new List<copado__Project__c>();
        
        for(copado__Project__c project : newList) {
            if(project.InternalJira__c ==true) {
                newJiraProjects.add(project);
            }
        }
        
        if(!newJiraProjects.isEmpty()) { setProjectToUse7SJira(newJiraProjects); }
    }
    
    //-------------------------------------------------------------------------
    // On before update trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeUpdate(Map<Id, copado__Project__c> oldMap, Map<Id, copado__Project__c> newMap) {
        for(copado__Project__c project : newMap.values()) {
            if(project.InternalJira__c != oldMap.get(project.Id).InternalJira__c) {
                if(project.InternalJira__c==false) {
                    project.copadoccmint__Copado_Integration_Setting__c = null;
                    project.copadoccmint__JQL_Extended_Filter__c = null;
                } else {
                    if(!Test.isRunningTest()) { 
                        project.copadoccmint__Copado_Integration_Setting__c = System.Label.Jira_Integration_Setting;
                        project.copadoccmint__JQL_Extended_Filter__c = System.Label.X7S_Copado_Default_JQL;
                    }
                }
            }
        }
    }
    
    //-------------------------------------------------------------------------
    // On after update trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterUpdate (Map<Id, copado__Project__c> oldMap, Map<Id, copado__Project__c> newMap) {
        List<copado__Project__c> newJiraProjects = new List<copado__Project__c>();
        List<copado__Project__c> cancelledJiraProjects = new List<copado__Project__c>();
        
        for(copado__Project__c project : newMap.values()) {
            System.debug('------ new value: ' + project.InternalJira__c + ' ------- old value: ' + oldMap.get(project.Id).InternalJira__c);
            if(project.InternalJira__c != oldMap.get(project.Id).InternalJira__c) {
                if(project.InternalJira__c==true) {
                    newJiraProjects.add(project);
                } else {
                    cancelledJiraProjects.add(project);
                }
            }
        }
        
        System.debug('------ canceledJiraProjects: ' + cancelledJiraProjects);
        if(!newJiraProjects.isEmpty()) { setProjectToUse7SJira(newJiraProjects); }
        if(!cancelledJiraProjects.isEmpty()) { removeProjectFromJira(cancelledJiraProjects); }
    }
    
    //-------------------------------------------------------------------------
    // On before delete trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeDelete (List<copado__Project__c> newList) {    
        
    }
    
    //-------------------------------------------------------------------------
    // On after delete trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterDelete (List<copado__Project__c> newList) {    
        
    }
    
    //-------------------------------------------------------------------------
    // Setup project to use 7S Jira
    //-------------------------------------------------------------------------
    private static void setProjectToUse7SJira(List<copado__Project__c> projects) {
        System.debug('****** setProjectToUse7SJira *****');
        List<copadoccmint__Field_Mapping__c> jiraMapping = new List<copadoccmint__Field_Mapping__c>();
        List<JiraStatusMapping__c> statusMapping = new List<JiraStatusMapping__c>();
        List<copadoccmint__Record_Type_Mapping__c> recordTypeMapping = new List<copadoccmint__Record_Type_Mapping__c>();
        
        for(copado__Project__c project : projects) {
            System.debug('****** System.Label.Jira_Integration_Setting: ' + System.Label.Jira_Integration_Setting);
            if(project.InternalJira__c) {
                
                createFieldMappings(project.Id, jiraMapping);
                createStatusMappings(project.Id, statusMapping);
                createRecordTypeMappings(project.Id, recordTypeMapping);
            }
        }
        
        if(!jiraMapping.isEmpty()) { insert jiraMapping; }
        if(!statusMapping.isEmpty()) { insert statusMapping; }
        if(!recordTypeMapping.isEmpty()) { insert recordTypeMapping; }
    }
    
    //-------------------------------------------------------------------------
    // Create field mappings for Jira
    //-------------------------------------------------------------------------
    private static void createFieldMappings(Id projectId, List<copadoccmint__Field_Mapping__c> jiraMapping) {       
        if(fieldMappings==null) { getFieldMappings(); }

        for(Field_Mapping_Template__mdt fieldMap : fieldMappings) {
            jiraMapping.add(new copadoccmint__Field_Mapping__c(copadoccmint__Project__c=projectId, copadoccmint__Exclude_from_su__c=fieldMap.Exclude_from_su__c, 
                                                               copadoccmint__Exclude_from_tpu__c=fieldMap.Exclude_from_tpu__c, copadoccmint__Salesforce_Field_Name__c=fieldMap.Salesforce_Field_Name__c, 
                                                               copadoccmint__Target_Field_Type__c=fieldMap.Target_Field_Type__c, copadoccmint__Third_Party_Field_Name__c=fieldMap.Third_Party_Field_Name__c));
        }
        
    }
    
    //-------------------------------------------------------------------------
    // Create status mappings for Jira
    //-------------------------------------------------------------------------
    private static void createStatusMappings(Id projectId, List<JiraStatusMapping__c> statusMapping) {       
        if(statusMappings==null) { getStatusMappings(); }

        for(Jira_Status_Mapping_Template__mdt fieldMap : statusMappings) {
            statusMapping.add(new JiraStatusMapping__c(Project__c=projectId, CopadoStatus__c=fieldMap.Copado_Status__c, ExternalValue__c=fieldMap.ExternalValue__c,
                                                 SyncDirection__c=fieldMap.SyncDirection__c));
        }
        
    }

    //-------------------------------------------------------------------------
    // Create record type mappings for Jira
    //-------------------------------------------------------------------------
    private static void createRecordTypeMappings(Id projectId, List<copadoccmint__Record_Type_Mapping__c> recordTypeMapping) {       
        if(recordTypeMappings==null) { getRecordTypeMappings(); }

        for(ALMRecordTypeMapping__mdt fieldMap : recordTypeMappings) {
            recordTypeMapping.add(new copadoccmint__Record_Type_Mapping__c(copadoccmint__Project__c=projectId, 
                                                                           copadoccmint__Salesforce_Record_Type_Name__c=fieldMap.SalesforceRecordType__c, 
                                                                           copadoccmint__Third_Party_Record_Type_Name__c=fieldMap.ThirdPartyRecordType__c));
        }
        
    }
    
    
    //-------------------------------------------------------------------------
    // Remove field mappings for Jira
    //-------------------------------------------------------------------------
    private static void removeProjectFromJira(List<copado__Project__c> projects) {
        Set<Id> copadoProjectIds = new Set<Id>();
        for(copado__Project__c project : projects) {
			copadoProjectIds.add(project.Id);
        }
        
        System.debug('******* Removing Field and Status Mappings ********');
        System.debug('-------- copadoProjectIds: ' + copadoProjectIds);
        List<copadoccmint__Field_Mapping__c> f = [SELECT Id FROM copadoccmint__Field_Mapping__c WHERE copadoccmint__Project__c IN : copadoProjectIds];
        List<JiraStatusMapping__c> s = [SELECT Id FROM JiraStatusMapping__c WHERE Project__c IN : copadoProjectIds];
        
        if(!f.isEmpty()) { delete f; }
        if(!s.isEmpty()) { delete s; }
    }
    
    //-------------------------------------------------------------------------
    // Get template field mappings from custom metadata 
    //-------------------------------------------------------------------------
    private static void getFieldMappings() {
        if(Test.isRunningTest()) {
            fieldMappings = new List<Field_Mapping_Template__mdt>();
            fieldMappings.add(new Field_Mapping_Template__mdt(MasterLabel='7S-Test', Salesforce_Field_Name__c='A', Third_Party_Field_Name__c = 'B'));
        } else {
            fieldMappings = [SELECT Exclude_from_su__c, Exclude_from_tpu__c, Salesforce_Field_Name__c, Target_Field_Type__c, Third_Party_Field_Name__c
                             FROM Field_Mapping_Template__mdt
                             WHERE MasterLabel LIKE '7S-%'];
        }
    }
    
    //-------------------------------------------------------------------------
    // Get template status mappings from custom metadata 
    //-------------------------------------------------------------------------
    private static void getStatusMappings() {
        if(Test.isRunningTest()) {
            statusMappings = new List<Jira_Status_Mapping_Template__mdt>();
            statusMappings.add(new Jira_Status_Mapping_Template__mdt(MasterLabel='7S-Test',  Copado_Status__c='Draft', ExternalValue__c = 'B', SyncDirection__c='Inbound'));
        } else {
            statusMappings = [SELECT Copado_Status__c, ExternalValue__c, SyncDirection__c
                             FROM Jira_Status_Mapping_Template__mdt
                             WHERE MasterLabel LIKE '7S-%'];
        }
    }
    
    //-------------------------------------------------------------------------
    // Get template record type mappings from custom metadata 
    //-------------------------------------------------------------------------
    private static void getRecordTypeMappings() {
        if(Test.isRunningTest()) {
            recordTypeMappings = new List<ALMRecordTypeMapping__mdt>();
            recordTypeMappings.add(new ALMRecordTypeMapping__mdt(MasterLabel='7S-Test', SalesforceRecordType__c='A', ThirdPartyRecordType__c = 'B'));
        } else {
            recordTypeMappings = [SELECT SalesforceRecordType__c, ThirdPartyRecordType__c
                                  FROM ALMRecordTypeMapping__mdt];
        }
    }
}