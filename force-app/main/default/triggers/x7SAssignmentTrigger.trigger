trigger x7SAssignmentTrigger on pse__Assignment__c  (before insert, after insert, before update, after update, before delete, after undelete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    System.debug('==============> ' + className + ' IsRunning=' + TriggerState.thisTriggerIsRunning(className));
    System.debug('==============> ' + trigger.new);
    System.debug('==============> ' + trigger.old);
    
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        System.debug('--------------- WTF ---------------');
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            List<Id> projects = new List<Id>();
            for(pse__Assignment__c assignment :  Trigger.new) {
                if(!projectIds.contains(assignment.pse__Project__c)) { projectIds.add(assignment.pse__Project__c); }
                if(!projects.contains(assignment.pse__Project__c)) { projects.add(assignment.pse__Project__c); }
            }
            
            
            AssignmentRollupHelper.calculate(projectIds);
            
            
            if(CoverageAssignmentHandler.isFirstTime) {
                CoverageAssignmentHandler.isFirstTime=false;
                CoverageAssignmentHandler.makeAssignments(projects);
            }
            
            TriggerState.isRunning=true;
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            System.debug('==================== IN ASSIGNMENT TRIGGER AFTER UPDATE ===================');
            Set<Id> projectIds = new Set<Id>();
            List<Id> projects = new List<Id>();
            for(pse__Assignment__c assignment :  Trigger.new) {
                if(!projectIds.contains(assignment.pse__Project__c)) { projectIds.add(assignment.pse__Project__c); }
                if(!projects.contains(assignment.pse__Project__c)) { projects.add(assignment.pse__Project__c); }
            }
            
            
            AssignmentRollupHelper.calculate(projectIds);
            
            
            if(CoverageAssignmentHandler.isFirstTime) {
                CoverageAssignmentHandler.isFirstTime=false;
                CoverageAssignmentHandler.makeAssignments(projects);
            }
            
            
            if(!EstVsActualsRollupHelper.isRunning) { EstVsActualsRollupHelper.calculate(projectIds); }
            
            TriggerState.isRunning=true;
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            List<Id> projects = new List<Id>();
            for(pse__Assignment__c assignment :  Trigger.old) {
                if(!projectIds.contains(assignment.pse__Project__c)) { projectIds.add(assignment.pse__Project__c); }
                if(!projects.contains(assignment.pse__Project__c)) { projects.add(assignment.pse__Project__c); }
            }
            
            
            AssignmentRollupHelper.calculate(projectIds);
            
            
            if(CoverageAssignmentHandler.isFirstTime) {
                CoverageAssignmentHandler.isFirstTime=false;
                CoverageAssignmentHandler.makeAssignments(projects);
            }
            
            
            if(!EstVsActualsRollupHelper.isRunning) { EstVsActualsRollupHelper.calculate(projectIds); }
            
            TriggerState.isRunning=true;
        }
        
        if(trigger.isAfter && trigger.isUnDelete && TriggerState.isAfterUnDelete) {
            
        }        
        
    }
}