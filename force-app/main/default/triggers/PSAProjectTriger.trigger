trigger PSAProjectTriger on pse__Proj__c (before insert, after insert, before update, after update, before delete, after delete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            PSAProjectTriggerHandler.OnBeforeInsert(trigger.new);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            PSAProjectTriggerHandler.OnAfterInsert(trigger.new);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            PSAProjectTriggerHandler.OnBeforeUpdate(trigger.oldMap, trigger.newMap);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            PSAProjectTriggerHandler.OnAfterUpdate(trigger.oldMap, trigger.newMap);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            PSAProjectTriggerHandler.OnBeforeDelete(trigger.new);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        if(trigger.isAfter && trigger.isDelete && TriggerState.isAfterDelete) {
            PSAProjectTriggerHandler.OnBeforeDelete(trigger.new);
            PSAProjectTriggerHandler.m_isExecuting = true;
        }
        
        TriggerState.isRunning=true;
    }
}