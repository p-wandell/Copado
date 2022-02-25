@isTest
public class BudgetRollupHelper_Test {
    @testSetup static void setup() {
    	ProjectRollupHelpers_Test.setupTestData(new List<String>{'pse__Assignment__c', 'pse__Proj__c', 'Contact', 'Opportunity', 'Account', 'pse__Milestone__c', 'pse__Est_vs_Actuals__c'});
    }

    @isTest static void testBudgetTriggers() {
        pse__Budget__c budget = [SELECT Id FROM pse__Budget__c LIMIT 1];
        Test.startTest();
        delete budget;
        Test.stopTest();
    }
}