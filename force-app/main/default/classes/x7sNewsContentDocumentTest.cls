@isTest
public class x7sNewsContentDocumentTest {
	public static String strNetId {
		get {
			return [SELECT Id FROM Network LIMIT 1][0].Id;
		}
	}    
    
    @isTest static void testMethods() {
        X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        System.debug('----- cv: ' + cv);
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = newsObj.Id;
        cdl.ShareType = 'V';
        insert cdl;
        
        List<Id> listIds = new List<Id>();
        listIds.add(cv.Id);
        
        List<ContentDocumentLink> documentList = x7sNewsContentDocument.getContentDocumentLinks(listIds);
        x7sNewsContentDocument.containsEntityId(documentList, newsObj.Id);
        
        System.debug(documentList);
        
    }
}