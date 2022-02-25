@isTest
public class GetfeedbackAnswerTriggerTest {

    @testsetup static void setupData() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true);
        insert permissionControl;
        
        RecordType contactRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='Contact'];
        
        Account custAccount1 = new Account(Name='Customer Account-1', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        insert custAccount1;

        Account custAccount2 = new Account(Name='Sample Account-2', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        insert custAccount2;
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Test', LastName='Contact', email='test1@abc.com', AccountId=custAccount1.Id, RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Example', LastName='Contact', email='Example@abc.com', AccountId=custAccount1.Id,  RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Sample', LastName='Contact', email='Sample@abc.com', AccountId=custAccount1.Id, RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Mobile', LastName='Contact', email='Mobile@abc.com', AccountId=custAccount1.Id, RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Local', LastName='Contact', email='Local@abc.com', AccountId=custAccount2.Id, RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Work', LastName='Contact', email='Work@abc.com', AccountId=custAccount2.Id, RecordTypeId=contactRT.Id));
        contacts.add(new Contact(FirstName='Last', LastName='Contact', email='Last@abc.com', AccountId=custAccount2.Id, RecordTypeId=contactRT.Id));
        
        insert contacts;
        
        List<pse__Proj__c> projects = New List<pse__Proj__c>();
        projects.add(new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount1.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Define', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));
        projects.add(new pse__Proj__c(Name='Project 2', pse__Account__c=custAccount2.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Design', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));
        insert projects;        
        
        Decimal surveyId = Decimal.valueOf(Math.random()*100000);
        GetFeedback_Aut__Survey__c survey = new GetFeedback_Aut__Survey__c(Name='Test Survey', GetFeedback_Aut__GetFeedbackId__c=surveyId);
        insert survey;

        List<GetFeedback_Aut__Response__c> responses = new List<GetFeedback_Aut__Response__c>();
		List<ProjectSurveyContact__c> projectContacts = new List<ProjectSurveyContact__c>();
        for(pse__Proj__c project : projects) {
            List<Contact> contactList = [SELECT Id, AccountId FROM Contact WHERE AccountId =: project.pse__Account__c];
            for(Contact contact : contactList) {
                Decimal responseId = Decimal.valueOf(Math.random()*100000);
                responses.add(new GetFeedback_Aut__Response__c(GetFeedback_Aut__Survey__c=survey.Id, GetFeedback_Aut__GetFeedbackId__c=responseId,
                                                               GetFeedback_Aut__Account__c=project.pse__Account__c, GetFeedback_Aut__Contact__c=contact.Id, ProjectId__c=project.Id));
                projectContacts.add(new ProjectSurveyContact__c(Project__c=project.Id, Contact__c=contact.Id, Account__c=contact.AccountId));
            }
        }

        insert projectContacts;
        insert responses;
    }
    
    @isTest static void testTriggerAndHandler() {
        List<GetFeedback_Aut__Answer__c> answers = new List<GetFeedback_Aut__Answer__c>();

        List<GetFeedback_Aut__Response__c> responses = [SELECT Id FROM GetFeedback_Aut__Response__c];
        for(GetFeedback_Aut__Response__c response : responses) {
            Decimal answerId = Decimal.valueOf(Math.random()*100000);
            Decimal csat = Decimal.valueOf(Math.random()*10);
            answers.add(new GetFeedback_Aut__Answer__c(GetFeedback_Aut__Response__c=response.Id, GetFeedback_Aut__Number__c=csat, GetFeedback_Aut__QuestionTitle__c='My Question',
                                                       GetFeedback_Aut__GetFeedbackId__c=''+answerId, GetFeedback_Aut__QuestionType__c='NetPromoter'));
        }
        
        answers[0].GetFeedback_Aut__Number__c=10.0;
        answers[1].GetFeedback_Aut__Number__c=7.0;
        answers[2].GetFeedback_Aut__Number__c=3.0;
        
		insert answers;

        delete answers[0];
    }
}