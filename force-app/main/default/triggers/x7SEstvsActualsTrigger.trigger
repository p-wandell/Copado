trigger x7SEstvsActualsTrigger on pse__Est_Vs_Actuals__c (before insert, after insert, before update, after update, before delete, after undelete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.isRunning) {
        
        
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Est_vs_Actuals__c est :  Trigger.new) {
                if(!projectIds.contains(est.pse__Project__c)) { projectIds.add(est.pse__Project__c); }
            }
            
            if(!EstVsActualsRollupHelper.isRunning) {
            	EstVsActualsRollupHelper.calculate(projectIds);
                EstVsActualsRollupHelper.isRunning=true;
            }
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Est_vs_Actuals__c est :  Trigger.new) {
                if(!projectIds.contains(est.pse__Project__c)) { projectIds.add(est.pse__Project__c); }
            }
            
            if(!EstVsActualsRollupHelper.isRunning) {
            	EstVsActualsRollupHelper.calculate(projectIds);
                EstVsActualsRollupHelper.isRunning=true;
            }
        }

        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Est_vs_Actuals__c est :  Trigger.old) {
                if(!projectIds.contains(est.pse__Project__c)) { projectIds.add(est.pse__Project__c); }
            }
            
            if(!EstVsActualsRollupHelper.isRunning) {
            	EstVsActualsRollupHelper.calculate(projectIds);
                EstVsActualsRollupHelper.isRunning=true;
            }
        }
        
        if(trigger.isAfter && trigger.isUnDelete && TriggerState.isAfterUnDelete) {

        }

        TriggerState.isRunning=true;

    }
}