@IsTest
private class x7S_CommunityAssetsControllerTest {
    @testSetup
    static void testSetup() {
        User testUser = Peak_TestUtils.createStandardUserNoContact();
        Account testAccount = Peak_TestUtils.createTestAccount();
        insert testUser;
    }
    @IsTest
    static void testGetObjectAPIName() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email = :Peak_TestConstants.STANDARD_EMAIL AND Username = :Peak_TestConstants.STANDARD_USERNAME];
        Test.startTest();
        String testResponse = x7S_CommunityAssetsController.getObjectAPIName(testUsers[0].Id);
        String actualResponse = testUsers[0].Id.getSObjectType().getDescribe().getName();
        System.assertEquals(testResponse, actualResponse);
        Test.stopTest();
    }
    @IsTest
    static void testGetFieldLabels() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email = :Peak_TestConstants.STANDARD_EMAIL AND Username = :Peak_TestConstants.STANDARD_USERNAME];
        System.runAs(testUsers[0]){
            Test.startTest();
            x7S_AssetResponse testResponse = x7S_CommunityAssetsController.getFieldLabels(new List<String>{'Name'}, false);
            String testLabel = Schema.getGlobalDescribe().get('Community_Asset__c').getDescribe().fields.getMap().get('Name').getDescribe().getLabel();
            System.assertEquals(testResponse.labels[0],testLabel);
            System.assertEquals(testResponse.success,true);
            Test.stopTest();
        }
    }
    @IsTest
    static void testGetFieldLabelsException() {
        List<User> testUsers = [SELECT Id FROM User WHERE Email = :Peak_TestConstants.STANDARD_EMAIL AND Username = :Peak_TestConstants.STANDARD_USERNAME];
        System.runAs(testUsers[0]){
            Test.startTest();
            x7S_AssetResponse testResponse = x7S_CommunityAssetsController.getFieldLabels(new List<String>{'Name'}, true);
            System.assertEquals(testResponse.success,false);
            Test.stopTest();
        }
    }
    @IsTest
    static void testGetAssets() {
        List<Account> testAccounts = [SELECT Id FROM Account WHERE Name = :Peak_TestConstants.ACCOUNT_NAME];
        Community_Asset__c newAsset = new Community_Asset__c();
        newAsset.Name = 'Test Asset';
        newAsset.Client__c = testAccounts[0].Id;
        newAsset.Link__c = 'www.google.com';
        newAsset.Asset_Owner__c=UserInfo.getUserId();
        insert newAsset;
        Test.startTest();
        Peak_Response testResponse = x7S_CommunityAssetsController.getAssets(testAccounts[0].Id, false);
        Community_Asset__c returnedAsset = (Community_Asset__c)testResponse.results[0];
        System.assertEquals(testResponse.success,true);
        System.assertEquals(returnedAsset.Id,newAsset.Id);
        System.assertEquals(returnedAsset.Client__c, testAccounts[0].Id);
        Test.stopTest();
    }
    @IsTest
    static void testGetAssetsException() {
        List<Account> testAccounts = [SELECT Id FROM Account WHERE Name = :Peak_TestConstants.ACCOUNT_NAME];
        Community_Asset__c newAsset = new Community_Asset__c();
        newAsset.Name = 'Test Asset';
        newAsset.Client__c = testAccounts[0].Id;
        newAsset.Link__c = 'www.google.com';
        newAsset.Asset_Owner__c=UserInfo.getUserId();
        insert newAsset;
        Test.startTest();
        Peak_Response testResponse = x7S_CommunityAssetsController.getAssets(testAccounts[0].Id, true);
        System.assertEquals(testResponse.success,false);
        Test.stopTest();
    }
}