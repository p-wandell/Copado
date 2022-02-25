@isTest (SeeAllData=false)
public class ProjectRollupHelpers_Test {
    private static Account svnAccount;
    private static Account custAccount;
    private static List<Contact> contacts;
    private static List<pse__Proj__c> projects;
    private static List<pse__Assignment__c> assignments;
    private static List<pse__Schedule__c> schedules;
    private static List<pse__Assignment__c> setupAssignments;
    private static List<pse__Schedule__c> setupSchedules;
    
    @testSetup static void setup() {
        setupTestData(new List<String>{'Contact'});
    }
 
    public static void setupTestData(List<String> triggers) {
        List<TriggerSettings__c> ts = new List<TriggerSettings__c>();    
        Integer x=0;
        for(String tt : triggers) {
            TriggerSettings__c t = new TriggerSettings__c();
            t.Name = 'TS-' + x;
            t.ObjectName__c = tt;
            t.TriggerName__c = null;
            t.isActive__c = false;
            t.isTestMode__c = false;
            t.isBeforeInsert__c = true;
            t.isAfterInsert__c = true;
            t.isBeforeUpdate__c = true;
            t.isAfterUpdate__c = true;
            t.isBeforeDelete__c = true;
            t.isAfterDelete__c = true;
            t.isAfterUnDelete__c = true;
            
            x++;
            ts.add(t);
        }
        
        CoverageAssignmentHandler.isFirstTime=false;
        if(!ts.isEmpty()) { insert ts; }
        
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true,
                                                                                      pse__Timecard_Ops_Edit__c=true,  pse__Timecard_Entry__c=true);
        insert permissionControl;
        
        RecordType contactRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='PSA Resource'];
        
        Account svnAccount = new Account(Name='7Summits', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        Account custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        
        insert svnAccount;
        insert custAccount;
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Manager', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TA'));
        contacts.add(new Contact(FirstName='Dev1', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=False, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TL'));
        contacts.add(new Contact(FirstName='OpsManager', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='OpsPM', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='Dev2', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Technology & Accelerators', Coverage_Participant__c=False, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='TA'));
        contacts.add(new Contact(FirstName='BizMgr', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Business Consulting', Coverage_Participant__c=true, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        contacts.add(new Contact(FirstName='BA', LastName='Contact', email='test1@abc.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Business Consulting', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM'));
        
        insert contacts;
        
        System.debug(contacts[1]);
        
        Quota_Detail__c qd = new Quota_Detail__c(Name='Test Quota');
        insert qd;
        
        Opportunity opp = new Opportunity(Name='test opp', AccountId=custAccount.Id, Amount=100.0, StageName='Closed Won', CloseDate=System.today(), Description='Opportunity',
                                          Solution_Primary_Audience__c='Customer', Quota_Name__c=qd.Id, Project_Type__c='New Project', Team_Recognition__c='Amazing Job!');
        insert opp;        

        
        Opportunity csOpp = new Opportunity(Name='test cs opp', AccountId=custAccount.Id, Amount=100.0, StageName='Closed Won', CloseDate=System.today(), Description='Opportunity',
                                          Solution_Primary_Audience__c='Customer', Project_Type__c='Customer Success');
        insert csOpp;
        
        List<pse__Proj__c> projects = new List<pse__Proj__c>();
        projects.add(new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Define', 
                                      pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, InitiateCoverage__c=true, pse__Opportunity__c=opp.Id, pse__project_type__c='Customer Project',
                                      Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));

        projects.add(new pse__Proj__c(Name='Project 2', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Define',
                                      pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, InitiateCoverage__c=true, pse__Opportunity__c=csOpp.Id, pse__project_type__c='Customer Project',
                                      Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));
        
        projects.add(new pse__Proj__c(Name='Project 3', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Completed', 
                                      pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, InitiateCoverage__c=true, pse__Opportunity__c=opp.Id, pse__project_type__c='Customer Project',
                                      Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30)));
        
        insert projects;
        
        opp.pse__Primary_Project__c = projects[0].Id;
        update opp;
        
        csOpp.pse__Primary_Project__c = projects[1].Id;
        update csOpp;
        

        List<pse__Milestone__c> milestones = new List<pse__Milestone__c>();
        milestones.add(new pse__Milestone__c(pse__Project__c=projects[0].Id, pse__Milestone_Amount__c=10000, pse__Target_Date__c=System.today().addDays(30)));
        milestones.add(new pse__Milestone__c(pse__Project__c=projects[1].Id, pse__Milestone_Amount__c=10000, pse__Target_Date__c=System.today().addDays(30)));
        milestones.add(new pse__Milestone__c(pse__Project__c=projects[1].Id, pse__Milestone_Amount__c=10000, pse__Target_Date__c=System.today().addDays(-30)));
        insert milestones;

        
        pse__Schedule__c baSchedule = new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=0);
        pse__Schedule__c baMgrSchedule = new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=0);
        List<pse__Schedule__c> setupSchedules = new List<pse__Schedule__c>();
        setupSchedules.add(baSchedule);
        setupSchedules.add(baMgrSchedule);
        insert setupSchedules;
        
        List<pse__Assignment__c> assignments = new List<pse__Assignment__c>();
        pse__Assignment__c baAssignment = new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[6].Id, pse__Schedule__c=baSchedule.Id, pse__Role__c='BA', 
                                                                 pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00);
        pse__Assignment__c baMgrAssignment = new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[5].Id, pse__Schedule__c=baMgrSchedule.Id, pse__Role__c='Coverage', 
                                                                    pse__Is_Billable__c=false, pse__Bill_Rate__c=0.00);
        pse__Assignment__c taAssignment = new pse__Assignment__c(pse__Project__c=projects[2].Id, pse__Resource__c=contacts[1].Id, pse__Schedule__c=baMgrSchedule.Id, pse__Role__c='Coverage', 
                                                                    pse__Is_Billable__c=false, pse__Bill_Rate__c=0.00);
        assignments.add(baAssignment);
        assignments.add(baMgrAssignment);
        
        List<pse__Schedule__c> schedules = new List<pse__Schedule__c>();
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        schedules.add(new pse__Schedule__c(pse__Start_Date__c=projects[0].pse__Start_Date__c, pse__End_Date__c=projects[0].pse__End_Date__c, pse__Friday_Hours__c=8));
        insert schedules;
        
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[1].Id, pse__Schedule__c=schedules[0].Id, pse__Role__c='SFDC Dev', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[4].Id, pse__Schedule__c=schedules[1].Id, pse__Role__c='TA', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[3].Id, pse__Schedule__c=schedules[2].Id, pse__Role__c='PM', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[3].Id, pse__Schedule__c=schedules[2].Id, pse__Role__c='Coverage', pse__Is_Billable__c=false, pse__Bill_Rate__c=0.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[0].Id, pse__Resource__c=contacts[3].Id, pse__Schedule__c=schedules[2].Id, pse__Role__c='Coverage', pse__Is_Billable__c=false, pse__Bill_Rate__c=0.00));
        assignments.add(new pse__Assignment__c(pse__Project__c=projects[2].Id, pse__Resource__c=contacts[3].Id, pse__Schedule__c=schedules[2].Id, pse__Role__c='TA', pse__Is_Billable__c=true, pse__Bill_Rate__c=200.00));
        
        insert assignments;
        
        pse__Budget_Header__c bh = new pse__Budget_Header__c(Name='Test', pse__Account__c=custAccount.Id, pse__Active__c=true, pse__Amount__c=100.0, pse__Project__c=projects[0].Id);
        insert bh;
        
        pse__Budget__c budget = new pse__Budget__c(Name='Test-1', pse__Budget_Header__c=bh.Id, pse__Project__c=projects[0].Id, pse__Amount__c=100.0, pse__Account__c=custAccount.Id, pse__Effective_Date__c=System.today());
        insert budget;
        
        List<pse__Est_vs_Actuals__c> est = new List<pse__Est_vs_Actuals__c>();
        est.add(new pse__Est_vs_Actuals__c(Name='Test',pse__Project__c=projects[0].Id,pse__Resource__c=contacts[1].Id, pse__Time_Period_Type__c='Week', 
                                           pse__Assignment__c=assignments[0].Id, pse__Actual_Hours__c=40, pse__End_Date__c=System.today().addDays(7), 
                                           pse__Estimated_Hours__c=40.0, pse__Start_Date__c=System.today()));
        est.add(new pse__Est_vs_Actuals__c(Name='Test',pse__Project__c=projects[0].Id,pse__Resource__c=contacts[3].Id, pse__Time_Period_Type__c='Week', 
                                           pse__Assignment__c=assignments[0].Id, pse__Actual_Hours__c=40, pse__End_Date__c=System.today().addDays(7), 
                                           pse__Estimated_Hours__c=40.0, pse__Start_Date__c=System.today()));
        insert est;

    }
}