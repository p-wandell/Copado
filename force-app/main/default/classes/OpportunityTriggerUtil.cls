public with sharing class OpportunityTriggerUtil {
    public static void updateSolutionOfferings(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityMap) {
        Set<Id> opportunityIds = new Set<Id>();
        for(Opportunity opp : newOpportunities) {
            if(opp.StageName == App_Settings__c.getOrgDefaults().Closed_Field__c && 
                opp.StageName != oldOpportunityMap.get(opp.Id).StageName) {
                opportunityIds.add(opp.Id);
            }
        }
        List<Solution_Offering__c> solutionOfferingsToUpdate = [select Id from Solution_Offering__c where Opportunity__c in: 
            opportunityIds];
        for(Solution_Offering__c offering : solutionOfferingsToUpdate) {
            offering.Sold__c = true;
        }
        update solutionOfferingsToUpdate;
    }

    public static void createSolutionOfferingRecords() {
        List<Solution_Offering__c> solutionsToCreate = new List<Solution_Offering__c>();
        for(Account a : [select Id from Account]) {
            for(Solution_Offerring_Names__c son : Solution_Offerring_Names__c.getall().values()) {
                if(son.Use__c) {
                    solutionsToCreate.add(new Solution_Offering__c(Name = son.Name, Account__c = a.Id));
                }
            }
        }
        insert solutionsToCreate;
    }
}