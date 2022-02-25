trigger x7sTimecardTrigger on pse__Timecard_Header__c (before insert, after insert, before update, after update, before delete, after undelete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Timecard_Header__c timecard :  Trigger.new) {
                if(!projectIds.contains(timecard.pse__Project__c)) { projectIds.add(timecard.pse__Project__c); }
            }
			System.debug('-------- projectIds: ' + projectIds);
            TimecardRollupHelper.calculate(projectIds);

        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Timecard_Header__c timecard :  Trigger.new) {
                if(!projectIds.contains(timecard.pse__Project__c)) { projectIds.add(timecard.pse__Project__c); }
            }

            TimecardRollupHelper.calculate(projectIds);
            
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Timecard_Header__c timecard :  Trigger.old) {
                if(!projectIds.contains(timecard.pse__Project__c)) { projectIds.add(timecard.pse__Project__c); }
            }

            TimecardRollupHelper.calculate(projectIds);

        }
        
        if(trigger.isAfter && trigger.isUnDelete && TriggerState.isAfterUnDelete) {
            
        }
        
        TriggerState.isRunning=true;
        
    }

}