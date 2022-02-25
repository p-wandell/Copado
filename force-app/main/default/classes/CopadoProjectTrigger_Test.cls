@isTest (SeeAllData=false)
public class CopadoProjectTrigger_Test {
    public static List<copado__Project__c> projects;
    
    @isTest static void testJiraProject() {
        setup();
        
        Test.startTest();        
        
        projects[0].InternalJira__c = true;
        projects[1].InternalJira__c = false;
        update projects;
        
        List<copadoccmint__Field_Mapping__c> m = [SELECT Id FROM copadoccmint__Field_Mapping__c];
        System.assertEquals(1, m.size());
        
        delete m;
        
        delete projects[0];
        test.stopTest();
    }
    
    @isTest static void setup() {
        projects = new List<copado__Project__c>();
        projects.add(new copado__Project__c(Name='Test-1'));
        projects.add(new copado__Project__c(Name='Test-2', InternalJira__c = true));
        insert projects;
    }
}