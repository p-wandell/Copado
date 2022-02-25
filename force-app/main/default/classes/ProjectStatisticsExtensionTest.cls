@isTest
public class ProjectStatisticsExtensionTest {

    private static Account svnAccount;
    private static Account custAccount;
    private static List<Contact> contacts;
    private static List<pse__Proj__c> projects;
    private static List<pse__Assignment__c> assignments;
    private static List<pse__Schedule__c> schedules;
    private static List<pse__Assignment__c> setupAssignments;
    private static List<pse__Schedule__c> setupSchedules;
    
    @istest static void testExtension() {
        pse__Proj__c project = [SELECT Id FROM pse__Proj__c LIMIT 1];
        ApexPages.StandardController ctrl = new ApexPages.StandardController(project);
        ProjectStatisticsExtension ext = new ProjectStatisticsExtension(ctrl);
        
        ext.getPhaseSummary();
    }
    
    @testsetup static void setup() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true);
        insert permissionControl;
        
        RecordType contactRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='PSA Resource'];
        
        svnAccount = new Account(Name='7Summits', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        
        insert svnAccount;
        insert custAccount;
        
        contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Manager', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TA'));
        contacts.add(new Contact(FirstName='Dev1', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=False, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TL'));
        contacts.add(new Contact(FirstName='OpsManager', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='OpsPM', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='Dev2', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=False, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TA'));
        contacts.add(new Contact(FirstName='BizMgr', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Business Consulting', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='BA', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Business Consulting', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        
        insert contacts;
        
        contacts[1].ReportsToId=contacts[0].Id;
        contacts[3].ReportsToId=contacts[2].Id;
        contacts[4].ReportsToId=contacts[0].Id;
        contacts[6].ReportsToId=contacts[5].Id;
        
        update contacts;
        
        System.debug(contacts[1]);
        
        projects = new List<pse__Proj__c>();
        projects.add(new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Planned', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));
        
        insert projects;
        
        pse__Milestone__c milestone = new pse__Milestone__c(pse__Project__c=projects[0].Id, Name='Prepare', pse__Target_Date__c=System.today());
        insert milestone;
        
        pse__Schedule__c baSchedule = new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=0);
        pse__Schedule__c baMgrSchedule = new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=0);
        setupSchedules = new List<pse__Schedule__c>();
        setupSchedules.add(baSchedule);
        setupSchedules.add(baMgrSchedule);
        insert setupSchedules;
        
        assignments = new List<pse__Assignment__c>();
        pse__Assignment__c baAssignment = new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[6].Id, pse__Schedule__c=baSchedule.Id, pse__Role__c='BA', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00);
        pse__Assignment__c baMgrAssignment = new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[5].Id, pse__Schedule__c=baMgrSchedule.Id, pse__Role__c='Coverage', pse__Is_Billable__c=false, pse__Bill_Rate__c=0);
        assignments.add(baAssignment);
        assignments.add(baMgrAssignment);
        
        schedules = new List<pse__Schedule__c>();
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        insert schedules;
        
        
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[1].Id, pse__Schedule__c=schedules[0].Id, pse__Role__c='SFDC Dev', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[4].Id, pse__Schedule__c=schedules[1].Id, pse__Role__c='TA', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[3].Id, pse__Schedule__c=schedules[2].Id, pse__Role__c='PM', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        
        insert assignments;
        
        pse__Est_vs_Actuals__c est = new pse__Est_vs_Actuals__c(Name='test', pse__Assignment__c=assignments[0].Id, pse__Project__c=projects[0].Id, pse__Resource__c=contacts[6].id, pse__Actual_Hours__c=10.0, pse__Estimated_Hours__c=0.0, pse__Start_Date__c=System.today(), pse__End_Date__c=System.today());
        insert est;
    }
}