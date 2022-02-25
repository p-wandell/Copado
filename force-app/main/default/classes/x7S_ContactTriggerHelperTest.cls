@IsTest
private class x7S_ContactTriggerHelperTest {
    private static final List<String> lastNames = new List<String>{'New Manager', 'Old Manager', 'Updated User'};
        
    @TestSetup
    static void testSetup() {
        pse__Region__c region = new pse__Region__c(Name='Test Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), pse__Region__c=region.Id, pse__Staffing__c=true);
        insert permissionControl;        
        
        List<User> testUsers = x7S_AdditionalTestUtils.createManyUserNoContact(3, lastNames);
        List<Contact> testContacts = x7S_AdditionalTestUtils.createManyTestContacts(3, lastNames, region.Id);

        pse__Proj__c project = new pse__Proj__c(Name='Test Internal Project', pse__Account__c=testContacts[0].AccountId, pse__Region__c=region.id, pse__Is_Active__c=true, pse__Stage__c='Planned', 
                                      			pse__Is_Billable__c=false, pse__Allow_Self_Staffing__c=true, InitiateCoverage__c=false, Ops_Staffing_Stage__c='Not Staffed', 
                                                pse__Start_Date__c=System.today(), pse__End_Date__c=System.today().addDays(30), AutomaticallyCreateAssignment__c=true);
        
        insert project;

        Map<String, Id> userMap = new Map<String, Id>();
        insert testUsers;
        for(User currentUser : testUsers){
            userMap.put(currentUser.LastName, currentUser.Id);
        }
        for(Contact currentContact : testContacts){
            currentContact.pse__Salesforce_User__c = userMap.get(currentContact.LastName);
            if(currentContact.LastName == 'Updated User'){
                currentContact.ReportsToId = testContacts[1].Id;
            }
        }
        update testContacts;
    }
    
    @IsTest
    static void testManagerSync() {
        Contact testOldContact = [SELECT Id, ReportsToId, pse__Salesforce_User__c, FirstName, LastName, Email, Competency_Group__c, pse__Start_Date__c, AccountId FROM Contact WHERE LastName = :lastNames[2] LIMIT 1];
        Contact testNewManagerContact = [SELECT Id, Name, pse__Salesforce_User__c FROM Contact WHERE LastName = :lastNames[0] LIMIT 1];
        Contact testNewContact = testOldContact;
        testNewContact.ReportsToId = testNewManagerContact.Id;
        update testNewContact;
        Test.startTest();
        x7S_ContactTriggerHelper.handleContactInsertUpdate(new Map<Id, Contact>{testNewContact.Id => testNewContact},new Map<Id, Contact>{testOldContact.Id => testOldContact});
        User testUpdatedUser = [SELECT Id, Name, ManagerId FROM User WHERE LastName = :lastNames[2] LIMIT 1];
        User testNewManagerUser = [SELECT Id, Name FROM User WHERE LastName = :lastNames[0] LIMIT 1];
        System.assertEquals(testUpdatedUser.ManagerId,testNewManagerUser.Id);
        Test.stopTest();
    }
    
    @IsTest
    static void testNameSync() {
        String testLastName = 'Changed Last Name';
        String testFirstName = 'Changed First Name';
        Contact testOldContact = [SELECT Id, ReportsToId, pse__Salesforce_User__c, FirstName, LastName, Email, Competency_Group__c, pse__Start_Date__c, AccountId FROM Contact WHERE LastName = :lastNames[2] LIMIT 1];
        Contact testNewContact = testOldContact;
        testNewContact.LastName = testLastName;
        testNewContact.FirstName = testFirstName;
        update testNewContact;
        Test.startTest();
        x7S_ContactTriggerHelper.handleContactInsertUpdate(new Map<Id, Contact>{testNewContact.Id => testNewContact},new Map<Id, Contact>{testOldContact.Id => testOldContact});
        User testUpdatedUser = [SELECT Id, Name FROM User WHERE LastName = :testLastName LIMIT 1];
        System.assertEquals(testUpdatedUser.Name,testFirstName + ' ' + testLastName);
        Test.stopTest();
    }
    
    @IsTest
    static void testOtherSync() {
        String testComp = Peak_Utils.getPicklistValues('Contact', 'Competency_Group__c')[0];
        Date testStart = Date.newInstance(2016, 5, 31);
        String testEmail = 'changedEmail@test.com';
        Contact testOldContact = [SELECT Id, ReportsToId, pse__Salesforce_User__c, FirstName, LastName, Email, Competency_Group__c, pse__Start_Date__c, AccountId FROM Contact WHERE LastName = :lastNames[2] LIMIT 1];
        Contact testNewContact = testOldContact;
        testNewContact.Competency_Group__c = testComp;
        testNewContact.pse__Start_Date__c = testStart;
        testNewContact.Email = testEmail;
        update testNewContact;
        Test.startTest();
        x7S_ContactTriggerHelper.handleContactInsertUpdate(new Map<Id, Contact>{testNewContact.Id => testNewContact},new Map<Id, Contact>{testOldContact.Id => testOldContact});
        User testUpdatedUser = [SELECT Id, Competency_Group__c, Start_Date__c, Email FROM User WHERE LastName = :lastNames[2] LIMIT 1];
        System.assertEquals(testUpdatedUser.Competency_Group__c,testComp);
        System.assertEquals(testUpdatedUser.Start_Date__c,testStart);
        Test.stopTest();
    }
    
    @IsTest
    static void testInsertNewResource() { 
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType='Contact' AND Name='PSA Resource' LIMIT 1];
        Account a = [SELECT Id FROM Account LIMIT 1];
        pse__Region__c region = [SELECT Id FROM pse__Region__c];
		Contact newContact = new Contact(FirstName=Peak_TestConstants.FIRSTNAME + 'NC', LastName='TESTNEW', Email=Peak_TestConstants.STANDARD_EMAIL + 'NC',
                                         AccountId = a.Id, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, RecordtypeId=rt.Id, pse__Region__c=region.Id);
        insert newContact;
    }
}