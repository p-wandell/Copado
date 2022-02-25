public with sharing class SS_CommunitySiteHomeController {

    @TestVisible private String startURL = '%2F';

	public String networkId {get; private set;}

	public String profileImageUrl { get; private set; }

	public SS_CommunitySiteHomeController() {
		networkId = Network.getNetworkId();
		profileImageUrl = [select SmallPhotoUrl from User where Id =: UserInfo.getUserId()].SmallPhotoUrl;
	}
	public PageReference forwardToCustomAuthPage() {
        // this should go back to MyCases since we don't have access to Id till the user is authenticated
        return SS_CommunitySiteUtil.forwardToCustomAuthPage(startURL);
    }
}