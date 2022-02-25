@isTest
public class OpportunityRollupHelper_Test {
    @testSetup static void setup() {
        ProjectRollupHelpers_Test.setupTestData(new List<String>{'Contact'});
    }

    @isTest static void testOpportunityTrigger() {
        Opportunity opp = [SELECT Id, Quota_Name__c, AccountId FROM Opportunity WHERE Name='test opp' LIMIT 1];
        System.debug('-------- opp: ' + opp);
        List<Opportunity> monthlyOpps = new List<Opportunity>();
        for(integer x=1;x<=12;x++) {
            Date closedDate=Date.newInstance(System.today().year(), x, 1);
            monthlyOpps.add(new Opportunity(Name='test opp-'+x, AccountId=opp.AccountId, Amount=100.0, StageName='Closed Won', CloseDate=closedDate, Description='Opportunity',
                                          Solution_Primary_Audience__c='Customer', Quota_Name__c=opp.Quota_Name__c, pse__Parent_Opportunity__c=opp.Id, Project_Type__c='Change Order',
                                           Team_Recognition__c='Amazing Job!'));
        }
        
        Test.startTest();
        insert monthlyOpps;
        Test.stopTest();
    }    
}