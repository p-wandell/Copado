@isTest
public class CreateContactRoleTest {
   
    public static testmethod void testSingleOpportunity(){
    	//create data 
    	Account newAccount = new Account();
        newAccount.Industry_Type__c='Retail';
        newAccount.Name = 'Test Account';
        insert newAccount;
        
        Contact testContact = new Contact();
        testContact.AccountId=newAccount.Id;
        testContact.FirstName = 'Bob';
        testContact.LastName = 'LastName';
        testContact.Industry_Type__c = 'Government';
        testContact.Lead_Source__c = 'Sales Prospecting';
        insert testContact;
        
        Campaign campaign = new Campaign(Name='Test Campaign');
        insert campaign;
        
    	//do whatever you need to test
    	Test.startTest();
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Lead_Source__c='Sales Prospecting';
        newOpportunity.Name ='New Opp';
        newOpportunity.StageName = '1 Prospect';
        newOpportunity.CloseDate = System.today() +1;
        insert newOpportunity;
        
        Test.stopTest();
        
        //check results
    }
}