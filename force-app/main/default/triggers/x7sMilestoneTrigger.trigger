trigger x7sMilestoneTrigger on pse__Milestone__c (before insert, after insert, before update, after update, before delete, after undelete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Milestone__c milestone :  Trigger.new) {
                if(!projectIds.contains(milestone.pse__Project__c)) { projectIds.add(milestone.pse__Project__c); }
            }
            
            
            MilestoneRollupHelper.calculate(projectIds);

        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Milestone__c milestone :  Trigger.new) {
                if(!projectIds.contains(milestone.pse__Project__c)) { projectIds.add(milestone.pse__Project__c); }
            }
            
            
            MilestoneRollupHelper.calculate(projectIds);
            
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Milestone__c milestone :  Trigger.old) {
                if(!projectIds.contains(milestone.pse__Project__c)) { projectIds.add(milestone.pse__Project__c); }
            }
            
            
            MilestoneRollupHelper.calculate(projectIds);

        }
        
        if(trigger.isAfter && trigger.isUnDelete && TriggerState.isAfterUnDelete) {
            
        }
        
        TriggerState.isRunning=true;
        
    }

}