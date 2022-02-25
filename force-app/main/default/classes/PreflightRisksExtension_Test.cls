@isTest
public class PreflightRisksExtension_Test {

    @istest static void testExtension(){
        pse__Proj__c project = [SELECT Id FROM pse__Proj__c LIMIT 1];
        PageReference pageRef = Page.PreflightRisks;
        pageRef.getParameters().put('id', project.Id);
        
		Test.setCurrentPage(pageRef);
        
        Apexpages.StandardController sc = new Apexpages.StandardController(project);
        PreFlightRisksExtension ext = new PreFlightRisksExtension(sc);
        
        List<Risks_Issues__c> risks = ext.getPreflightRisks();
        ext.save();
    }
    
    @testsetup static void setup() {
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
        
        Contact x7sContact = new Contact(FirstName='7S', LastName='Contact', email='test1@7s.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=resourceRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM');
        insert x7sContact;
        
        Contact custContact = new Contact(FirstName='Cust', LastName='Contact', email='test1@customer.com', AccountId=custAccount.Id, RecordTypeId=contactRT.Id);
        insert custContact;
        
        GetFeedback_Setting__mdt gfSetting = [SELECT ProjectStages__c FROM GetFeedback_Setting__mdt WHERE DeveloperName='Project_Survey'];
        List<String> stages = gfSetting.ProjectStages__c.split(',');
        
        pse__Proj__c project = new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c=stages[0], pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), pse__Project_Manager__c=x7sContact.Id);
        insert project;

        List<RiskIssueTemplate__c> templates = new List<RiskIssueTemplate__c>();
        templates.add(new RiskIssueTemplate__c(Description__c='Test-1', Type__c='Resource'));
        templates.add(new RiskIssueTemplate__c(Description__c='Test-2', Type__c='Client-Specific'));
		insert templates;
        
        RiskIssueTemplate__c newTemplate = [SELECT Name FROM RiskIssueTemplate__c LIMIT 1];
        
        RecordType riRT = [SELECT Id FROM RecordType WHERE SObjectType='Risks_Issues__c' AND DeveloperName='Risk'];
		Risks_Issues__c risk = new Risks_Issues__c(RecordTypeId=riRT.Id, Name__c='Things', Impact__c='High', 
                                                   TemplateId__c=newTemplate.Name, Type__c='Resource', Project__c=project.Id);
        insert risk;
        
        System.debug('-------- risk: ' + risk);
    }
    
}