@isTest
private class SS_CommunitySiteUrlRewriter_Test {
	
    private static Case theCase;

    private static void setupData() {
        theCase = SS_TestUtils.initCase();
        insert theCase;
        theCase = [SELECT Id, CaseNumber FROM Case WHERE Id =: theCase.Id];
    }

    private static Boolean mapRequestUrl_match(String input, String output) {
        SS_CommunitySiteUrlRewriter rw = new SS_CommunitySiteUrlRewriter();

        PageReference pr = rw.mapRequestUrl(new PageReference(input));

        System.debug('Input: ' + input);
        System.debug('Expected Output: ' + output);

        if (pr == null) {
            System.debug('Actual Output: ' + null);
            return (output == null);
        } else {
            System.debug('Actual Output: ' + pr.getUrl());
            return (output == pr.getUrl());
        }
    }

	@isTest 
    private static void test_mapRequestUrl() {
        setupData();

        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.CASE_DETAIL_PAGE + theCase.CaseNumber, SS_CommunitySiteUrlRewriter.CASE_DETAIL_VISUALFORCE_PAGE + theCase.Id));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.CASE_PAGE, SS_CommunitySiteUrlRewriter.CASE_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.LOGIN_PAGE + '?startURL=test', SS_CommunitySiteUrlRewriter.LOGIN_VISUALFORCE_PAGE + '?startURL=test'));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.GROUP_PAGE, SS_CommunitySiteUrlRewriter.GROUP_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.PROFILE_PAGE, SS_CommunitySiteUrlRewriter.PROFILE_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.ANSWER_PAGE, SS_CommunitySiteUrlRewriter.ANSWER_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.SELF_REG_CONFIRM_PAGE, SS_CommunitySiteUrlRewriter.SELF_REG_CONFIRM_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.SELF_REG_PAGE, SS_CommunitySiteUrlRewriter.SELF_REG_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_CONFIRM_PAGE, SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_CONFIRM_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_PAGE, SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.SS_404_PAGE, SS_CommunitySiteUrlRewriter.SS_404_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.EXCEPTION_PAGE, SS_CommunitySiteUrlRewriter.EXCEPTION_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.SS_509_PAGE, SS_CommunitySiteUrlRewriter.SS_509_VISUALFORCE_PAGE));
        System.assert(mapRequestUrl_match(SS_CommunitySiteUrlRewriter.HOME_PAGE, SS_CommunitySiteUrlRewriter.HOME_VISUALFORCE_PAGE));
	}
	
	@isTest 
    private static void test_generateUrlFor() {
        setupData();

        List<PageReference> inputPrs = new List<PageReference>();
        List<PageReference> outputPrs = new List<PageReference>();

        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.CASE_DETAIL_PAGE + theCase.CaseNumber));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.CASE_DETAIL_VISUALFORCE_PAGE + theCase.Id));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.CASE_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.CASE_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.LOGIN_PAGE + '?startURL=test'));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.LOGIN_VISUALFORCE_PAGE + '?startURL=test'));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.GROUP_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.GROUP_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.PROFILE_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.PROFILE_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.ANSWER_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.ANSWER_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SELF_REG_CONFIRM_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SELF_REG_CONFIRM_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SELF_REG_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SELF_REG_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_CONFIRM_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_CONFIRM_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.FORGOT_PASSWORD_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SS_404_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SS_404_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.EXCEPTION_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.EXCEPTION_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SS_509_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.SS_509_VISUALFORCE_PAGE));
        outputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.HOME_PAGE));
        inputPrs.add(new PageReference(SS_CommunitySiteUrlRewriter.HOME_VISUALFORCE_PAGE));

        SS_CommunitySiteUrlRewriter rw = new SS_CommunitySiteUrlRewriter();

        List<PageReference> actualOutputPrs = rw.generateUrlFor(inputPrs);
        for (Integer i = 0; i < inputPrs.size(); i++) {
            System.assertEquals(outputPrs[i].getUrl(), actualOutputPrs[i].getUrl());
        }
	}
/*	
    // From FriendlyURLs.cls
    private static testMethod void t1() {
        Site site = [select Id from Site limit 1];
        String siteid = site.Id;    
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        PageTemplate__c pt = new PageTemplate__c(Name = 'TestTemplatexyz', VisualForce_Page_Name__c = 'TestTemplate', ContentBlockNames__c = 'a,b,c', Folder__c = templatefolder.Id);
        insert pt;

        Page__c p = new Page__c(Name = 'testpagexyz', FriendlyUrl__c='testpagexyz', PageTemplate__c = pt.Id, Folder__c = pagefolder.Id);
        insert p;

        FriendlyURLs fu = new FriendlyURLs();
        PageReference pr = new Pagereference('/cms/testpagexyz');
        PageReference origurl = fu.mapRequestUrl(pr);
        //System.debug(origurl.getUrl());
        System.assertEquals('/page?pageid='+p.Id, origurl.getUrl());

        PageReference pr2 = new Pagereference('thiswontbefoundxyz');
        PageReference origurl2 = fu.mapRequestUrl(pr2);
        System.assertEquals(null, origurl2);
    }
*/
}