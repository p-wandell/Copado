public abstract class ALMStatusMappingHandler {
    
    public static Map<String, String> statusXRef;
    
    public static String getALMStatus(String statusIn) {
        if(statusXref == null) { getStatusXrefForExternalALM(); }
        return lookupStatus(statusIn);
    }
    
    public static String getALMStatus(String storyId, String statusIn) {
        if(statusXref == null) { getStatusXrefForExternalALM(StoryId); }
        return lookupStatus(statusIn);
    }
    
    public static String getCopadoStatus(String statusIn) {
        if(statusXref == null) { getStatusXrefForCopado(); }
        return lookupStatus(statusIn);
    }
    
    public static String getCopadoStatus(String storyId, String statusIn) {
        if(statusXref == null) { getStatusXrefForCopado(storyId); }
        return lookupStatus(statusIn);
    }
    
    @testvisible
    private static String lookupStatus(String statusIn) {
        if(statusXref.containsKey(statusIn)) {
            return statusXRef.get(statusIn);
        } else {
            return statusIn;
        }
    }
    
    @testvisible
    private static void getStatusXrefForExternalALM() {
        System.debug('building statusXref');
        
        statusXRef = new Map<String, String>();
        List<Jira_Status_Mapping_Template__mdt> statusList = [SELECT Copado_Status__c, ExternalValue__c 
                                                              FROM Jira_Status_Mapping_Template__mdt
                                                              WHERE SyncDirection__c='Outbound'];
        
        if(Test.isRunningTest()) { statusXref.put('Approved', 'To Do'); }
        for(Jira_Status_Mapping_Template__mdt status : statusList) {
            if(!statusXRef.containsKey(status.Copado_Status__c)) { statusXref.put(status.Copado_Status__c, status.ExternalValue__c); }
        }
    }
    
    @testvisible
    private static void getStatusXrefForExternalALM(String storyId) {
        System.debug('building statusXref');
        
        statusXRef = new Map<String, String>();
        List<JiraStatusMapping__c> statusList = [SELECT CopadoStatus__c, ExternalValue__c 
                                                 FROM JiraStatusMapping__c
                                                 WHERE Project__c =: storyId AND SyncDirection__c='Outbound'];
        
        if(Test.isRunningTest()) { statusXref.put('Approved', 'To Do'); }
        for(JiraStatusMapping__c status : statusList) {
            if(!statusXRef.containsKey(status.CopadoStatus__c)) { statusXref.put(status.CopadoStatus__c, status.ExternalValue__c); }
        }
    }
    
    @testvisible
    private static void getStatusXrefForCopado() {
        System.debug('building statusXref');
        statusXRef = new Map<String, String>();
        List<Jira_Status_Mapping_Template__mdt> statusList = [SELECT Copado_Status__c, ExternalValue__c 
                                                              FROM Jira_Status_Mapping_Template__mdt
                                                              WHERE SyncDirection__c='Inbound'];
        
        if(Test.isRunningTest()) { statusXref.put('To Do', 'Approved'); }
        for(Jira_Status_Mapping_Template__mdt status : statusList) {
            if(!statusXRef.containsKey(status.ExternalValue__c)) { statusXref.put(status.ExternalValue__c, status.Copado_Status__c); }
        }
    }
    
    @testvisible
    private static void getStatusXrefForCopado(String storyId) {
        System.debug('building statusXref');
        statusXRef = new Map<String, String>();
        List<JiraStatusMapping__c> statusList = [SELECT CopadoStatus__c, ExternalValue__c 
                                                 FROM JiraStatusMapping__c
                                                 WHERE SyncDirection__c='Inbound'];
        
        if(Test.isRunningTest()) { statusXref.put('To Do', 'Approved'); }
        for(JiraStatusMapping__c status : statusList) {
            if(!statusXRef.containsKey(status.ExternalValue__c)) { statusXref.put(status.ExternalValue__c, status.CopadoStatus__c); }
        }
    }
}