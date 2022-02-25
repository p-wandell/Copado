@isTest
private class SS_CommunitySiteUtil_Test {

    @isTest
    private static void test_forwardToCustomAuthPage() {
        String customURL = 'abc';

        // Authenticated
        System.assertEquals(null, SS_CommunitySiteUtil.forwardToCustomAuthPage(customURL));

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals('/Login?startURL=' + customURL, SS_CommunitySiteUtil.forwardToCustomAuthPage(customURL).getUrl());
        }
    }

    @isTest
    private static void test_isPageAuthenticated() {
        // Authenticated
        System.assertEquals(true, SS_CommunitySiteUtil.isPageAuthenticated());

        // Unauthenticated
        User guestUser = SS_TestUtils.initGuestUser();
        System.runAs(guestUser) {
            System.assertEquals(false, SS_CommunitySiteUtil.isPageAuthenticated());
        }
    }
}