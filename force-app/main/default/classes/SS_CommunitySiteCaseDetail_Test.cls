@isTest
private class SS_CommunitySiteCaseDetail_Test {
	
    private static Case theCase;

    private static void setupData() {
        theCase = SS_TestUtils.initCase();
    }

	@isTest 
    private static void test_SS_CommunitySiteCaseDetailControllerExt() {
		setupData();

        ApexPages.StandardController std = new ApexPages.StandardController(theCase);
        SS_CommunitySiteCaseDetailControllerExt controller = new SS_CommunitySiteCaseDetailControllerExt(std);
        
        System.assertNotEquals(null, controller.myCase);
	}
    
    @isTest 
    private static void test_queryCase() {
        setupData();
        insert theCase;

        ApexPages.StandardController std = new ApexPages.StandardController(theCase);
        SS_CommunitySiteCaseDetailControllerExt controller = new SS_CommunitySiteCaseDetailControllerExt(std);
        
        controller.queryCase();

        System.assertNotEquals(null, controller.myCase);
    }
    
    @isTest 
    private static void test_forwardToCustomAuthPage() {
        setupData();

        ApexPages.StandardController std = new ApexPages.StandardController(theCase);
        SS_CommunitySiteCaseDetailControllerExt controller = new SS_CommunitySiteCaseDetailControllerExt(std);
        
        // Authenticated
        System.assertEquals(null, controller.forwardToCustomAuthPage());

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals('/Login?startURL=' + controller.startURL, controller.forwardToCustomAuthPage().getUrl());
        }
    }
    
    /*
    @isTest 
    private static void test_setToEdit() {
        setupData();

        ApexPages.StandardController std = new ApexPages.StandardController(theCase);
        SS_CommunitySiteCaseDetailControllerExt controller = new SS_CommunitySiteCaseDetailControllerExt(std);
        
        PageReference pr = controller.setToEdit();

        System.assert(controller.isEditorNew);
        System.assertEquals(null, pr);
    }
    
    @isTest 
    private static void test_saveCase() {
        setupData();

        ApexPages.StandardController std = new ApexPages.StandardController(theCase);
        SS_CommunitySiteCaseDetailControllerExt controller = new SS_CommunitySiteCaseDetailControllerExt(std);
        
        PageReference pr = controller.saveCase();

        Case myCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: controller.myCase.Id];
        System.assertEquals('/Cases/' + myCase.CaseNumber, pr.getUrl());
    }
	*/
}