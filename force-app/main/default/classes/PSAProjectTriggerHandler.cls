public class PSAProjectTriggerHandler {
    public static boolean m_isExecuting = false;  
    
    //-------------------------------------------------------------------------  
    // On before insert trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeInsert(List<pse__Proj__c> newList) {
        
    } 
    
    //-------------------------------------------------------------------------
    // On after insert trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterInsert(List<pse__Proj__c> newList) {   
        createCopadoProjects(newList);
    }
    
    //-------------------------------------------------------------------------
    // On before update trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeUpdate(Map<Id, pse__Proj__c> oldMap, Map<Id, pse__Proj__c> newMap) {
        
    }
    
    //-------------------------------------------------------------------------
    // On after update trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterUpdate (Map<Id, pse__Proj__c> oldMap, Map<Id, pse__Proj__c> newMap) {
        List<pse__Proj__c> projects = new List<pse__Proj__c>();
        for(pse__Proj__c project : newMap.values()) {
            if(project.Copado_Project__c != oldMap.get(project.Id).Copado_Project__c) { projects.add(project); }
        }
        
        if(!projects.isEmpty()) { createCopadoProjects(projects); }
    }
    
    //-------------------------------------------------------------------------
    // On before delete trigger method
    //-------------------------------------------------------------------------
    public static void OnBeforeDelete (List<pse__Proj__c> newList) {    
        
    }
    
    //-------------------------------------------------------------------------
    // Sync Copado projects with PSA Projects
    //-------------------------------------------------------------------------
    private static void createCopadoProjects(List<pse__Proj__c> projects) {
        Set<Id> projectIds = new Set<Id>();
        List<copado__Project__c> copadoProjects = new List<copado__Project__c>();
        
        for(pse__Proj__c project : projects) {
            if(!projectIds.contains(project.Id)) { projectIds.add(project.Id); }
        }
        
        Map<Id, copado__Project__c> copadoProjectMap = new Map<Id, copado__Project__c>();
        List<copado__Project__c> currnetCopadoProjects = [SELECT Id, Name, PSAProject__c, copado__Start_Date__c, copado__End_Date__c FROM copado__Project__c WHERE PSAProject__c IN : projectIds];
        for(copado__Project__c currnetCopadoProject : currnetCopadoProjects) {
            copadoProjectMap.put(currnetCopadoProject.PSAProject__c, currnetCopadoProject);
        }
        
        for(pse__Proj__c project : projects) {
            if(project.Copado_Project__c) {
                copado__Project__c p;
                
                if(copadoProjectMap.containsKey(project.Id)) {
                    p=copadoProjectMap.get(project.Id);
                } else {
                	p = new copado__Project__c(Name=project.Name, PSAProject__c=project.Id, copado__Start_Date__c=project.pse__Start_Date__c, 

                                               copado__End_Date__c=project.pse__End_Date__c, Opps_Staffing_Stage__c=project.Ops_Staffing_Stage__c);

                }
                
                if(project.pse__Stage__c == 'Planned' || project.pse__Stage__c == 'Prepare' || project.pse__Stage__c == 'Define' || project.pse__Stage__c == 'Design') {
                    p.copado__Status__c='Planned';
                } else if (project.pse__Stage__c == 'Build' || project.pse__Stage__c == 'Verify' || project.pse__Stage__c == 'Launch') {
                    p.copado__Status__c='In Progress';
                } else {
                    p.copado__Status__c = 'Completed';
                }
                copadoProjects.add(p);
            }
        }
        
        if(!copadoProjects.isEmpty()) { upsert copadoProjects; }
    }
    
}