trigger x7S_ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.thisTriggerIsRunning(className)) {
        
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            AssignmentRollupHelper.isRunning=true;
            EstVsActualsRollupHelper.isRunning=true;
            x7S_ContactTriggerHelper.handleContactInsertUpdate(Trigger.newMap, Trigger.oldMap);
            x7S_ContactTriggerHelper.insertInternalAssignments(Trigger.newMap);
        }
    }
}