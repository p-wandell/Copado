public with sharing class SS_CommunitySiteTemplateController {
	public SS_CommunitySiteTemplateController() {
		
	}



    public PageReference forwardToCustomAuthPage() {
    	return new PageReference(Site.getPrefix() + '/SS_CommunitySiteHome');
    	if(SS_CommunitySiteUtil.isPageAuthenticated()){
    	 		return null;
    	}else{
    			String startUrl = System.currentPageReference().getParameters().get('startURL');
    			if(startUrl == null){
    				return new PageReference(Site.getPrefix() + '/SS_CommunitySiteHome');
    			}else {
					return new PageReference(Site.getPrefix() + '/SS_CommunitySiteLogin?startURL='+ EncodingUtil.urlEncode(startURL, 'UTF-8'));
				}
    	}
		
	}


}