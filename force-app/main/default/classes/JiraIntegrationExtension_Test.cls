@isTest (SeeAllData=false)
public class JiraIntegrationExtension_Test {

    @testsetup static void setup() {
        copado__Project__c project = new copado__Project__c(Name='Test Project', copadoccmint__Project_External_Id__c='TEST');
        insert project;
    }
    
    @isTest static void testSchedule() {
        copado__Project__c project = [SELECT Id FROM copado__Project__c LIMIT 1];
        
        PageReference pageRef = Page.ScheduleJiraSync;
        pageRef.getParameters().put('pid', String.valueOf(project.Id));
        Test.setCurrentPageReference(pageRef);
        
        JiraInterationExtension.scheduleJob();
        JiraInterationExtension.cancelCurrentJob();
    }
}