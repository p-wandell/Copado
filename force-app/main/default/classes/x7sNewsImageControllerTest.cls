@isTest
public class x7sNewsImageControllerTest {
    
    private static final Integer BULK_TEST_QTY = 10;
	public static String strNetId {
		get {
			return [SELECT Id FROM Network WHERE Name='7Summits Support Community' LIMIT 1][0].Id;
		}
	}
    
    @isTest static void testGetImageURL() {
        //set NetworkId variables of the Class with hardcoded value.
        x7sNewsController.networkId = Id.valueOf(strNetId);
        x7sNewsController.strNetworkId = strNetId;
        
        List<X7S_News__c> newsList = new List<X7S_News__c>();
        
        X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId, 'Static Resource');
        X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId, 'External URL');
        X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId, 'Related File');
        X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId, 'CMS Content');
        
        newsList.add(newsObj);
        newsList.add(newsObj1);
        newsList.add(newsObj2);
        newsList.add(newsObj3);

        x7sNewsImageController.getImageURL(newsList);

    }
}