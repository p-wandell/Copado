@IsTest
public class ResourceRequestExtension_Test {
    
    @istest static void testPage() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.x7s_ResourceRequest;
        pageRef.getParameters().put('id', testOpp.Id);
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        ResourceRequestExtension ext = new ResourceRequestExtension(ctrl);
        
        ext.resourceRequests[0].pse__Notes__c='test';
        ext.resourceRequests[0].pse__Start_Date__c=System.today();
        ext.resourceRequests[0].pse__End_Date__c=System.today().addDays(90);
        ext.resourceRequests[0].pse__Resource_Role__c='PM';
        ext.resourceRequests[0].Hours_per_Week__c='20';
        ext.resourceRequests[0].Deal_Comments__c='Testing deal comments';
        
        ext.resourceRequests[1].pse__Resource_Role__c='BA';
        ext.resourceRequests[1].Deal_Comments__c='Testing deal comments';
        
        ext.resourceRequests[2].Hours_per_Week__c='20';
        ext.resourceRequests[2].Deal_Comments__c='Testing deal comments';
        
        ext.save();
        
        ext.resourceRequests[0].pse__Notes__c='test';
        ext.resourceRequests[0].pse__Start_Date__c=System.today();
        ext.resourceRequests[0].pse__End_Date__c=System.today().addDays(90);
        ext.resourceRequests[0].pse__Resource_Role__c='PM';
        ext.resourceRequests[0].Hours_per_Week__c='20';
        ext.resourceRequests[0].Deal_Comments__c='Testing deal comments';
        
        ext.resourceRequests[1].Hours_per_Week__c='20';
        ext.resourceRequests[1].pse__Resource_Role__c='PM';
        ext.resourceRequests[1].Deal_Comments__c='Testing deal comments';
        
        ext.resourceRequests[2].pse__Resource_Role__c='PM';
        ext.resourceRequests[2].Hours_per_Week__c='20';
        ext.resourceRequests[2].Deal_Comments__c='Testing deal comments';
        
        ext.save();
    }
    
    @isTest static void testFull() {
        Opportunity testOpp = [SELECT Id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.x7s_ResourceRequest;
        pageRef.getParameters().put('id', testOpp.Id);
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(testOpp);
        ResourceRequestExtension ext = new ResourceRequestExtension(ctrl);
        
        ext.resourceRequests[0].pse__Notes__c='test';
        ext.resourceRequests[0].pse__Start_Date__c=System.today();
        ext.resourceRequests[0].pse__End_Date__c=System.today().addDays(90);
        ext.resourceRequests[0].pse__Resource_Role__c='PM';
        ext.resourceRequests[0].Hours_per_Week__c='20';
        ext.resourceRequests[0].Deal_Comments__c='Testing deal comments';
        
        ext.save();
    }
    
    @testsetup static void setup() {
        pse__Region__c region = new pse__Region__c(Name='Global Region');
        insert region;
        
        pse__Permission_Control__c permissionControl = new pse__Permission_Control__c(pse__User__c=UserINfo.getUserId(), 
                                                                                      pse__Region__c=region.Id, pse__Staffing__c=true,
                                                                                      pse__Resource_Request_Entry__c=true);
        insert permissionControl;
        
        RecordType resourceRT = [SELECT ID FROM RecordType WHERE SObjectType='Contact' AND Name='PSA Resource'];
        
        Account svnAccount = new Account(Name='7Summits', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        insert svnAccount;
        
        Contact x7sContact = new Contact(FirstName='7S', LastName='Contact', email='test1@7s.com', AccountId=svnAccount.Id, pse__Region__c=region.Id, 
                                         RecordTypeId=resourceRT.Id, Competency_Group__c='Delivery Operations', Coverage_Participant__c=false, 
                                         Active__c=true, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, Resource_Type__c='Internal', 
                                         pse__Resource_Role__c='PM', Generic_Resource__c=true);
        insert x7sContact;
        
        Account custAccount = new Account(Name='Customer Account', Industry_Type__c='Business Services', Record_Type__c='Vintage - Salesforce');
        insert custAccount;
        
        Opportunity opp = new Opportunity(Name='Test Opp', AccountId=custAccount.Id, StageName='Prospecting', Amount=0.0, CloseDate=System.today());
        insert opp;
    }
}