@isTest
public class EstVsActualsRollupHelper_Test {
    @testSetup static void setup() {
        ProjectRollupHelpers_Test.setupTestData(new List<String>{'Contact', 'pse__Assignment__c'});
    }

    @isTest static void testEstvsActualsTriggers() {
        pse__Est_vs_Actuals__c est = [SELECT Id FROM pse__Est_vs_Actuals__c LIMIT 1];
        Test.startTest();
        delete est;
        Test.stopTest();
    }
}