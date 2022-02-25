@isTest (SeeAllData=false)
public class PSAProjectTrigger_Test {

    private static Account svnAccount;
    private static Account custAccount;
    private static List<Contact> contacts;
    private static List<pse__Proj__c> projects;
    
    @isTest static void testTrigger() {
        setup();
        
        List<copado__Project__c> noCP = [SELECT Id FROM copado__Project__c];
        

        System.assertEquals(0, noCP.size());
        

        projects[0].Copado_Project__c = true;
        projects[1].Copado_Project__c = true;
        projects[2].Copado_Project__c = true;
        update projects;

        
        List<copado__Project__c> cp = [SELECT Id FROM copado__Project__c];
        System.assertEquals(3, cp.size());

    }
    
    @isTest static void testDelete() {
        setup();
        System.debug('********* About to delete *********');
        delete projects;
    }
    
    @IsTest static void setup() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');

        insert custAccount;
        
        projects = new List<pse__Proj__c>();
        projects.add(new pse__Proj__c(Name='Project 1', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Planned', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), Copado_Project__c=false));
        projects.add(new pse__Proj__c(Name='Project 2', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Build', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), Copado_Project__c=false));
		projects.add(new pse__Proj__c(Name='Project 3', pse__Account__c=custAccount.Id, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Completed', pse__Is_Billable__c=true, pse__Allow_Self_Staffing__c=true, Ops_Staffing_Stage__c='Not Staffed', pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), Copado_Project__c=false));
        insert projects;
    }    
}