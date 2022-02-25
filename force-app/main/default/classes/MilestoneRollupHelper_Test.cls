@isTest
public class MilestoneRollupHelper_Test {
    @testSetup static void setup() {
        ProjectRollupHelpers_Test.setupTestData(new List<String>{'Contact'});
    }
    
    @isTest static void testMilestoneTriggers() { 
        pse__Proj__c project = [SELECT Id, Name FROM pse__Proj__c WHERE opp_Project_Type__c='Customer Success'];
        pse__Milestone__c milestone = [SELECT Id, pse__target_date__c FROM pse__Milestone__c WHERE pse__Project__c =: project.Id LIMIT 1];
        
        System.debug('------------- project: ' + project);
        Test.startTest();
        project.pse__Stage__c='Build';
        update project;
        milestone.pse__target_date__c=System.today().addDays(-30); // Testing Build milestone in the past
        update milestone;
        milestone.pse__target_date__c=System.today().addDays(30); // Testing Build milestone in the future
        update milestone;
        project.pse__Stage__c='Completed';
        update project;
        milestone.pse__target_date__c=System.today().addDays(-30); // Testing Completed milestone in the past
        update milestone;
        delete milestone;
        Test.stopTest();
    }
}