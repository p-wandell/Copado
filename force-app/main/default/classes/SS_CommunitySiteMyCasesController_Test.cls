@isTest
private class SS_CommunitySiteMyCasesController_Test {
	
    private static List<Case> cases;

    private static void setupData() {
        cases = SS_TestUtils.initCases(4);
        insert cases;
    }

	@isTest 
    private static void test_saveCase() {
        setupData();

		ApexPages.StandardSetController stdSet = new ApexPages.StandardSetController(cases);
        SS_CommunitySiteMyCasesControllerExt controller = new SS_CommunitySiteMyCasesControllerExt(stdSet);

        PageReference pr = controller.saveCase();

        Case myCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: controller.myCase.Id];
        System.assertEquals('/Cases/' + myCase.CaseNumber, pr.getUrl());
	}
	
	@isTest 
    private static void test_goToDetail() {
        setupData();

        ApexPages.StandardSetController stdSet = new ApexPages.StandardSetController(cases);
        SS_CommunitySiteMyCasesControllerExt controller = new SS_CommunitySiteMyCasesControllerExt(stdSet);

        controller.CaseNumber = '123';
        PageReference pr = controller.goToDetail();

        System.assertEquals('/Cases/' + controller.CaseNumber, pr.getUrl());
	}
	
    @isTest 
    private static void test_forwardToCustomAuthPage() {
        setupData();

        ApexPages.StandardSetController stdSet = new ApexPages.StandardSetController(cases);
        SS_CommunitySiteMyCasesControllerExt controller = new SS_CommunitySiteMyCasesControllerExt(stdSet);

        // Authenticated
        System.assertEquals(null, controller.forwardToCustomAuthPage());

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals('/Login?startURL=' + controller.startURL, controller.forwardToCustomAuthPage().getUrl());
        }
    }
    
    @isTest 
    private static void test_newCasePage() {
        setupData();

        ApexPages.StandardSetController stdSet = new ApexPages.StandardSetController(cases);
        SS_CommunitySiteMyCasesControllerExt controller = new SS_CommunitySiteMyCasesControllerExt(stdSet);

        PageReference pr = controller.newCasePage();

        System.assertEquals('/SS_CommunitySiteNewCase', pr.getUrl());
    }
}