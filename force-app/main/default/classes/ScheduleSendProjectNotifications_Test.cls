@isTest
public class ScheduleSendProjectNotifications_Test {

    @isTest static void testBatchClass() {
        Test.startTest();
        Id batchProcessId = Database.executeBatch( new SendProjectSurveyNotificationsBatch());
        Test.stopTest();
    }
    
    @isTest static void testScheduler() {
        Integer year = System.today().year();
        String cronExpr = '0 0 0 24 2 ? ' + (year+1);
        Test.startTest();
        String jobId = System.schedule('SendSurveyNotifications', cronExpr, new ScheduleSendProjectSurveyNotifications());
        Test.stopTest();
    }
    
    @isTest static void testSchedulerParameter() {
        Integer year = System.today().year();
        String cronExpr = '0 0 0 24 2 ? ' + (year+1);
        Test.startTest();
        String jobId = System.schedule('SendSurveyNotifications', cronExpr, new ScheduleSendProjectSurveyNotifications('Customer Success'));
        Test.stopTest();
    }
    
    @testSetup static void setup() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true);
        insert permissionControl;
        
        RecordType resourceRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='PSA Resource'];
        RecordType contactRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='Contact'];
        
        Account svnAccount = new Account(Name='7Summits', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        Account custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        
        insert svnAccount;
        insert custAccount;
        
        Contact x7sContact = new Contact(FirstName='7S', LastName='Contact', Title='Test Title', email='test1@7s.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=resourceRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM');
        insert x7sContact;
        
		Contact custContact = new Contact(FirstName='Cust', LastName='Contact', Title='Test Title', email='test1@customer.com', AccountId=custAccount.Id, RecordTypeId=contactRT.Id);
        insert custContact;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity', StageName='2 Qualified', Amount=10000.0, CloseDate=System.today().addDays(90), Project_Type__c='New Project');
        insert opp;
        
        GetFeedback_Setting__mdt gfSetting = [SELECT ProjectStages__c FROM GetFeedback_Setting__mdt WHERE DeveloperName='Project_Survey'];
        List<String> stages = gfSetting.ProjectStages__c.split(',');
        
        pse__Proj__c project = new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c=stages[0], pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), pse__Project_Manager__c=x7sContact.Id, pse__Opportunity__c=opp.Id);
        insert project;
        
        insert new ProjectSurveyContact__c(project__c=project.Id, Account__c=custAccount.Id, Contact__c=custContact.Id, SendSurvey__c=true);
    }
}