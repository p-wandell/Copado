@IsTest(SeeAllData=false)
public class RiskAndIssuesStatusHandler_Test {
    private static Account svnAccount;
    private static Contact contact;
    private static Account custAccount;
    private static pse__Proj__c project;
    private static List<Risks_Issues__c> risks;
    
    @isTest static void testHandler() { 
        setup();

        Test.startTest();
        RiskAndIssuesStatusHandler.setProjectRecordStatus(risks);
  
        pse__Proj__c updatedProject = [SELECT Id, Sponsor_Engaged_Status__c, Risk_Level_Status__c, Forecast_Status__c, Quality_Status__c FROM pse__Proj__c WHERE Id =: project.Id];

        Test.stopTest();

    }

    @isTest static void testHighImpact() { 
        setup();

        Test.startTest();
        risks[0].Impact__c='High';
        risks[0].Probability__c='High';
        risks[0].Status__c='Draft';
        risks[1].Impact__c='High';
        risks[1].Probability__c='Medium';
        risks[1].Status__c='Draft';
        risks[2].Impact__c='High';
        risks[2].Probability__c='Low';
        risks[2].Status__c='Draft';
        risks[3].Impact__c='High';
        risks[3].Probability__c='High';
        risks[3].Status__c='Mitigated';
        risks[4].Impact__c='High';
        risks[4].Probability__c='Medium';
        risks[4].Status__c='Mitigated';
        risks[5].Impact__c='High';
        risks[5].Probability__c='High';
        risks[5].Status__c='Eradicated';
        risks[6].Impact__c='High';
        risks[6].Probability__c='Medium';
        risks[6].Status__c='Eradicated';
        risks[7].Impact__c='High';
        risks[7].Probability__c='Low';
        risks[7].Status__c='Eradicated';
        update risks;
        Test.stopTest();

    }
    
    @isTest static void testMediumImpact() { 
        setup();

        Test.startTest();
        risks[0].Impact__c='Medium';
        risks[0].Probability__c='High';
        risks[0].Status__c='Draft';
        risks[1].Impact__c='Medium';
        risks[1].Probability__c='Medium';
        risks[1].Status__c='Draft';
        risks[2].Impact__c='Medium';
        risks[2].Probability__c='Low';
        risks[2].Status__c='Draft';
        risks[3].Impact__c='Medium';
        risks[3].Probability__c='High';
        risks[3].Status__c='Mitigated';
        risks[4].Impact__c='Medium';
        risks[4].Probability__c='Medium';
        risks[4].Status__c='Mitigated';
        risks[5].Impact__c='Medium';
        risks[5].Probability__c='High';
        risks[5].Status__c='Eradicated';
        risks[6].Impact__c='Medium';
        risks[6].Probability__c='Medium';
        risks[6].Status__c='Eradicated';
        risks[7].Impact__c='Medium';
        risks[7].Probability__c='Low';
        risks[7].Status__c='Eradicated';
        update risks;

        Test.stopTest();

    }
    
    public static void setup() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true);
        insert permissionControl;
        
        RecordType contactRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='PSA Resource'];
        
        svnAccount = new Account(Name='7Summits', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        
        insert svnAccount;
        insert custAccount;
        
        contact=new Contact(FirstName='OpsPM', LastName='Contact', AccountId=svnAccount.Id, pse__Region__c=region.Id, RecordTypeId=contactRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', pse__Resource_Role__c='PM');
        insert contact;
        
        project = new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, 
                                   pse__Is_Active__c=true, pse__Stage__c='Planned', pse__Is_Billable__c=true, 
                                   pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', 
                                   pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30),
                                   Sponsor_Engaged_Status__c='', Risk_Level_Status__c='');
        
        insert project;
        
        risks=new List<Risks_Issues__c>();
        RecordType riskRt = [SELECT Id FROM RecordType WHERE SObjectType='Risks_Issues__c' AND Name='Risk'];
        
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Resource', Impact__c='Low', 
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id,
                                      Expected_Close_Date__c=System.today().addDays(30),
                                      Name__c='Risk 0', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Resource', Impact__c='Low', 
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id,
                                      Expected_Close_Date__c=System.today().addDays(30), 
                                      Mitigation_Steps__c='These are the steps', Status__c='In Progress',
                                      Name__c='Risk 1', Description__c='Description 2'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Budget', Impact__c='High', Probability__c='Medium',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30), Status__c='Draft',
                                      Name__c='Risk 2', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='DevOps', Impact__c='Low', Probability__c='Medium',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30), Status__c='Mitigated',
                                      Name__c='Risk 3', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Scope', Impact__c='Medium', Probability__c='Low',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30),
                                      Name__c='Risk 4', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='DevOps', Impact__c='Low', Probability__c='Medium',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30), Status__c='Mitigated',
                                      Name__c='Risk 5', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Scope', Impact__c='Medium', Probability__c='Low',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30),
                                      Name__c='Risk 6', Description__c='Description 1'));
        risks.add(new Risks_Issues__c(Project__c=project.Id, Type__c='Scope', Impact__c='Medium', Probability__c='Low',
                                      Owner__c=contact.Id, Date_Raised__c=System.today(), RecordTypeId=riskRT.Id, 
                                      Expected_Close_Date__c=System.today().addDays(30),
                                      Name__c='Risk 7', Description__c='Description 1'));
        insert risks;
        
    }
}