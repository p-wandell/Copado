trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, after update, before delete) {
    System.debug('************** TriggerState.isRunning ***************: ' + TriggerState.isRunning);
    
    String className=String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    if((trigger.new != null && TriggerState.isActive(trigger.new.getSObjectType(), className)) || (trigger.old != null && TriggerState.isActive(trigger.old.getSObjectType(), className)) && !TriggerState.isRunning) {

        if(trigger.isBefore && trigger.isInsert && TriggerState.isBeforeInsert) {
            
        }
        
        if(trigger.isAfter && trigger.isInsert && TriggerState.isAfterInsert) {
            Set<Id> projectIds = new Set<Id>();
            for(Opportunity opp :  Trigger.new) {
                if(!projectIds.contains(opp.pse__Primary_Project__c)) { projectIds.add(opp.pse__Primary_Project__c); }
            }
            
            OpportunityRollupHelper.calculate(trigger.newMap.values());
            OpportunityRollupHelper.calculate(projectIds);
            if(App_Settings__c.getOrgDefaults().Run_Opportunity_Trigger__c) { OpportunityTriggerUtil.updateSolutionOfferings(Trigger.new, Trigger.oldMap); }
        }
        
        if(trigger.isBefore && trigger.isUpdate && TriggerState.isBeforeUpdate) {
            
        }
        
        if(trigger.isAfter && trigger.isUpdate && TriggerState.isAfterUpdate) {
            Set<Id> projectIds = new Set<Id>();
            for(Opportunity opp :  Trigger.new) {
                if(!projectIds.contains(opp.pse__Primary_Project__c)) { projectIds.add(opp.pse__Primary_Project__c); }
            }
            
            for(Opportunity opp :  Trigger.oldMap.values()) {
                if(!projectIds.contains(opp.pse__Primary_Project__c)) { projectIds.add(opp.pse__Primary_Project__c); }
            }
            
            OpportunityRollupHelper.calculate(trigger.newMap.values());
            OpportunityRollupHelper.calculate(projectIds);
            if(App_Settings__c.getOrgDefaults().Run_Opportunity_Trigger__c) { OpportunityTriggerUtil.updateSolutionOfferings(Trigger.new, Trigger.oldMap); }
        }
        
        if(trigger.isBefore && trigger.isDelete && TriggerState.isBeforeDelete) {
            Set<Id> projectIds = new Set<Id>();
            for(Opportunity opp :  Trigger.old) {
                if(!projectIds.contains(opp.pse__Primary_Project__c)) { projectIds.add(opp.pse__Primary_Project__c); }
            }
            
            OpportunityRollupHelper.calculate(trigger.newMap.values());
            OpportunityRollupHelper.calculate(projectIds);
        }

        TriggerState.isRunning=true;

    }
}