public with sharing class SS_CommunitySiteChatterAnswerController {

    @TestVisible private String startURL = '%2FAnswers';

	public String getCommunityId() {
		return SS_CommunitySiteConstants.getCommunityId();
	}

	public PageReference forwardToCustomAuthPage() {
        // this should go back to MyCases since we don't have access to Id till the user is authenticated
         return SS_CommunitySiteUtil.forwardToCustomAuthPage(startURL);
                
    }
}