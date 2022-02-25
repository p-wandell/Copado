@IsTest(SeeAllData=false)
public class x7S_PTODashboardController_Test {
    private static Account account;
    private static Contact contact;
    private static Contact manager;
    private static Contact director;
    private static Contact svp;
    private static Contact evp;
    private static pse__Proj__c PTO_Project;
    
    @isTest static void testController() {
        setup();
        
        Test.startTest();
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(contact);
        x7S_PTODashboardController controller = new x7S_PTODashboardController(standardController);
        
        PageReference pageRef = Page.x7S_PTODashboardContainer;
        pageRef.getParameters().put('id', String.valueOf(contact.Id));
        Test.setCurrentPageReference(pageRef);
        
        Test.stopTest();
        
    }
    
    @isTest static void testManager() {
        setup();
        
        Test.startTest();
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(manager);
        x7S_PTODashboardController controller = new x7S_PTODashboardController(standardController);
        
        PageReference pageRef = Page.x7S_PTODashboardContainer;
        pageRef.getParameters().put('id', String.valueOf(manager.Id));
        Test.setCurrentPageReference(pageRef);
        
        Test.stopTest();
        
    }
    
    @isTest static void testDirector() {
        setup();
        
        Test.startTest();
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(director);
        x7S_PTODashboardController controller = new x7S_PTODashboardController(standardController);
        
        PageReference pageRef = Page.x7S_PTODashboardContainer;
        pageRef.getParameters().put('id', String.valueOf(director.Id));
        Test.setCurrentPageReference(pageRef);
        
        Test.stopTest();
        
    }
    
    @isTest static void setup() {
        RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType='Contact' AND DeveloperName='PSA_Resource'];
        account = new Account(name='Test Account', Industry_Type__c = 'Other');
        insert account;
        
        evp = new Contact(FirstName='SVP', LastName='Contact', RecordTypeId=rt.Id, AccountId=account.Id, pse__Start_Date__c=System.today().addDays(-60));
        evp.Lead_Source__c=null;
        evp.pse__Is_Resource_Active__c = true;
        evp.pse__Is_Resource__c = true;
        evp.RecordTypeId=rt.Id;
        insert evp;
        
        svp =  new Contact(FirstName='SVP', LastName='Contact', RecordTypeId=rt.Id, AccountId=account.Id, pse__Start_Date__c=System.today());
        svp.pse__Is_Resource_Active__c = true;
        svp.pse__Is_Resource__c = true;
        svp.RecordTypeId=rt.Id;
        svp.ReportsToId=evp.Id;
        insert svp;
        
        director = new Contact(FirstName='Director', LastName='Contact', RecordTypeId=rt.Id, AccountId=account.Id, pse__Start_Date__c=System.today());
        director.pse__Is_Resource_Active__c = true;
        director.pse__Is_Resource__c = true;
        director.RecordTypeId=rt.Id;
        director.ReportsToId=svp.Id;
        insert director;
        
        Date jun1 = Date.newInstance(2021, 06, 01);
        manager = new Contact(FirstName='Manager', LastName='Contact', RecordTypeId=rt.Id, AccountId=account.Id, pse__Start_Date__c=jun1);
        manager.pse__Is_Resource_Active__c = true;
        manager.pse__Is_Resource__c = true;
        manager.ReportsToId=director.Id;
        insert manager;
        
		Date jan1 = Date.newInstance(2020, 01, 01);
        contact = new Contact(FirstName='Test', LastName='Contact', RecordTypeId=rt.Id, AccountId=account.Id, pse__Start_Date__c=jan1);
        contact.pse__Is_Resource_Active__c = true;
        contact.pse__Is_Resource__c = true;
        contact.RecordTypeId=rt.Id;
        contact.ReportsToId=manager.Id;
        insert contact;
        
        PTO_Project = new pse__Proj__c();
        PTO_Project.Name = '7S Internal : Vacation'; 
        insert PTO_Project;

    }
}