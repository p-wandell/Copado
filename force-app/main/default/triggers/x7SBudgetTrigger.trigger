trigger x7SBudgetTrigger on pse__Budget__c (after delete, after insert, after undelete, after update, before delete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.isRunning) {
        
        
        
        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Budget__c budget :  Trigger.new) {
                if(!projectIds.contains(budget.pse__Project__c)) { projectIds.add(budget.pse__Project__c); }
            }
            
            BudgetRollupHelper.calculate(projectIds);
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Budget__c budget :  Trigger.new) {
                if(!projectIds.contains(budget.pse__Project__c)) { projectIds.add(budget.pse__Project__c); }
            }
            
            BudgetRollupHelper.calculate(projectIds);
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            for(pse__Budget__c budget :  Trigger.old) {
                if(!projectIds.contains(budget.pse__Project__c)) { projectIds.add(budget.pse__Project__c); }
            }
            
            BudgetRollupHelper.calculate(projectIds);
        }

        TriggerState.isRunning=true;

    }
}