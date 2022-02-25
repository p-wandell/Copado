@isTest
private class SS_CommunitySiteTermsController_Test {

    @isTest
    private static void test_getHideTerms() {
        User u = SS_TestUtils.initAdminUser();
        insert u;

        System.assertEquals(false, [SELECT Id, Hide_Terms_Conditions__c FROM User WHERE Id =: UserInfo.getUserId()].Hide_Terms_Conditions__c);

        Test.startTest();

        System.runAs(u) {
            SS_CommunitySiteTermsController ctrl = new SS_CommunitySiteTermsController();
            System.assertEquals(true, ctrl.getHideTerms());
        }

        Test.stopTest();        
    }

    @isTest
    private static void test_hideTerms() {
        User u = SS_TestUtils.initAdminUser();
        insert u;

        Test.startTest();

        System.runAs(u) {
            SS_CommunitySiteTermsController.hideTerms();
        }

        System.assertEquals(true, [SELECT Hide_Terms_Conditions__c FROM User WHERE Id =: u.Id].Hide_Terms_Conditions__c);
        
        Test.stopTest();    
    }
}