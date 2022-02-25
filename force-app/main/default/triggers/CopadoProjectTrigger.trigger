trigger CopadoProjectTrigger on copado__Project__c (before insert, after insert, before update, after update, before delete, after delete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));

    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            CopadoProjectTriggerHandler.OnBeforeInsert(trigger.new);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            CopadoProjectTriggerHandler.OnAfterInsert(trigger.new);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            CopadoProjectTriggerHandler.OnBeforeUpdate(trigger.oldMap, trigger.newMap);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            CopadoProjectTriggerHandler.OnAfterUpdate(trigger.oldMap, trigger.newMap);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            CopadoProjectTriggerHandler.OnBeforeDelete(trigger.new);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isDelete && TriggerState.isAfterDelete) {
            CopadoProjectTriggerHandler.OnBeforeDelete(trigger.new);
            CopadoProjectTriggerHandler.m_isExecuting = true;
        }
        
        TriggerState.isRunning=true;
    }
}