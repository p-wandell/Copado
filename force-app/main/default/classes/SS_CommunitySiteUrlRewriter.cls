global class SS_CommunitySiteUrlRewriter implements Site.UrlRewriter {
	// These two are from FriendlyURLs (from CMSForce)
	global static String CMSFORCE_PAGE = '/cms/';
  	global static String CMSFORCE_VISUALFORCE_PAGE = '/page?pageid=';

	global static String ID_PAGE = '/?id=';

	global static String EXCEPTION_PAGE = '/Error';
	global static String EXCEPTION_VISUALFORCE_PAGE = '/SS_CommunitySiteException';

	global static String SS_509_PAGE = '/509';
	global static String SS_509_VISUALFORCE_PAGE = '/SS_CommunitySiteBandwidthExceeded';

	global static String SELF_REG_CONFIRM_PAGE = '/RegisterConfirm';
	global static String SELF_REG_CONFIRM_VISUALFORCE_PAGE = '/SS_CommunitySiteSelfRegConfirm';

	global static String SELF_REG_PAGE = '/Register';
	global static String SELF_REG_VISUALFORCE_PAGE = '/SS_CommunitySiteSelfReg';

	global static String FORGOT_PASSWORD_PAGE = '/ForgotPassword';
	global static String FORGOT_PASSWORD_VISUALFORCE_PAGE = '/SS_CommunitySiteForgotPassword';

	global static String FORGOT_PASSWORD_CONFIRM_PAGE = '/ForgotPasswordConfirm';
	global static String FORGOT_PASSWORD_CONFIRM_VISUALFORCE_PAGE = '/SS_CommunitySiteForgotPasswordConfirm';

	global static String LOGIN_PAGE = '/Login';
	global static String LOGIN_VISUALFORCE_PAGE = '/SS_CommunitySiteLogin';

	global static String LOGOUT_PAGE = '/Logout';
	global static String LOGOUT_VISUALFORCE_PAGE = '/SSTab_CommunitySiteLogout';

	global static String SS_404_PAGE = '/404';
	global static String SS_404_VISUALFORCE_PAGE = '/SS_CommunitySite404';

	global static String PROFILE_PAGE = '/MyProfile';
	global static String PROFILE_VISUALFORCE_PAGE = '/SS_CommunitySiteMyProfile';
	//global static String PROFILE_VISUALFORCE_PAGE = '/_ui/core/userprofile/UserProfilePage?tab=sfdc.ProfilePlatformFeed';

	global static String CASE_PAGE = '/Cases';
	global static String CASE_VISUALFORCE_PAGE = '/SSTab_CommunitySiteMyCases';

	global static String GROUP_PAGE = '/Groups';
	global static String GROUP_VISUALFORCE_PAGE = '/SS_CommunitySiteGroups';
	//global static String GROUP_VISUALFORCE_PAGE = '/_ui/core/chatter/groups/GroupProfilePage?g=0F9S00000004FRj&isdtp=vw';

	global static String ANSWER_PAGE = '/Answers';
	global static String ANSWER_VISUALFORCE_PAGE = '/SSTab_CommunitySiteChatterAnswer';

	global static String HOME_PAGE = '/';
	global static String HOME_VISUALFORCE_PAGE = '/SSTab_CommunitySiteHome';

	global static String CASE_DETAIL_PAGE = '/Cases/';
	global static String CASE_DETAIL_VISUALFORCE_PAGE = '/SSTab_CommunitySiteCaseDetail?id=';

	global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
		System.debug('mapRequestUrl: ' + myFriendlyUrl);
		String url = myFriendlyUrl.getUrl();
/*
		if(url.startsWith(CMSFORCE_PAGE)) { // This is from FriendlyURLs (from CMSForce)
	     	try {
	        	String friendly = url.substring(CMSFORCE_PAGE.length(), url.length());
	        
		        //Select the ID of the (first) page that matches
		        //the name from the URL
		        Page__c p = [select Id, Name from Page__c where FriendlyUrl__c = :friendly LIMIT 1];
	        
	        	return new PageReference(CMSFORCE_VISUALFORCE_PAGE + p.id);
	      	}
	      	catch(Exception ex) {
	        	return null;
	      	}
	    }
*/
		if (url.startsWithIgnoreCase(ID_PAGE)) {
			String id = url.substring(ID_PAGE.length());

			// TODO - Determine what type of ID this is and whether to redirect it

			return new PageReference(CASE_DETAIL_VISUALFORCE_PAGE + id);
		}
		else if (url.startsWithIgnoreCase(CASE_DETAIL_PAGE)) {
			String caseNumber = url.substring(CASE_DETAIL_PAGE.length());
			
			String id = '';
			for (Case c : [SELECT Id, CaseNumber FROM Case WHERE CaseNumber =: caseNumber])
			{
				id = c.Id;
			}

			// Since the standard controller doesn't seem to let us give a nice error page, let's catch bad case URLs
			// and redirect them back to My Cases
			if (String.isBlank(id)) {
				return new PageReference(CASE_VISUALFORCE_PAGE + '?invalidCase=1');
			} else {
				return new PageReference(CASE_DETAIL_VISUALFORCE_PAGE + id);
			}
		}
		else if (url.startsWithIgnoreCase(CASE_PAGE)) { // has to come after individual case due to same prefix
			String params = url.substring(CASE_PAGE.length());
			return new PageReference(CASE_VISUALFORCE_PAGE + params);
		}
		else if (url.startsWithIgnoreCase(LOGIN_PAGE) && !url.startsWithIgnoreCase(LOGIN_PAGE + '?c=')) { // don't intercept password resets
			String params = url.substring(LOGIN_PAGE.length());
			// Getting around any links to just /Login without a redirect
			if (String.isBlank(params)) {
				params = '?startURL=%2F';
			}
			return new PageReference(LOGIN_VISUALFORCE_PAGE + params);
		}
		else if (url.startsWithIgnoreCase(LOGOUT_PAGE)) {
			return new PageReference(LOGOUT_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(GROUP_PAGE)) {
			return new PageReference(GROUP_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(PROFILE_PAGE)) {
			return new PageReference(PROFILE_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(ANSWER_PAGE)) {
			return new PageReference(ANSWER_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(SELF_REG_CONFIRM_PAGE)) { // has to come before self reg due to same prefix
			return new PageReference(SELF_REG_CONFIRM_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(SELF_REG_PAGE)) {
			return new PageReference(SELF_REG_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(FORGOT_PASSWORD_CONFIRM_PAGE)) { // has to come before forgot password due to same prefix
			return new PageReference(FORGOT_PASSWORD_CONFIRM_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(FORGOT_PASSWORD_PAGE)) {
			return new PageReference(FORGOT_PASSWORD_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(SS_404_PAGE)) {
			return new PageReference(SS_404_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(EXCEPTION_PAGE)) {
			return new PageReference(EXCEPTION_VISUALFORCE_PAGE);
		}
		else if (url.startsWithIgnoreCase(SS_509_PAGE)) {
			return new PageReference(SS_509_VISUALFORCE_PAGE);
		}
		else if (url.equalsIgnoreCase(HOME_PAGE)) { // has to come last because it is just a single "/"
			return new PageReference(HOME_VISUALFORCE_PAGE);
		}

		return null;
	}
	
	global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
		System.debug('generateUrlFor: ' + mySalesforceUrls);
		List<PageReference> myFriendlyUrls = new List<PageReference>();

		List<String> caseIds = new List<String>();

		for (PageReference mySalesforceUrl : mySalesforceUrls) {
			String url = mySalesforceUrl.getUrl();

			if (url.startsWithIgnoreCase(CASE_DETAIL_VISUALFORCE_PAGE)) {
				String caseId = url.substring(CASE_DETAIL_VISUALFORCE_PAGE.length());
				caseIds.add(caseId);
			}
		}

		Map<String, Case> caseMap = new Map<String, Case>();
		if (!caseIds.isEmpty()) {
			caseMap = new Map<String, Case>([SELECT Id, CaseNumber FROM Case WHERE Id =: caseIds]);
		}

		for (PageReference mySalesforceUrl : mySalesforceUrls) {
			String url = mySalesforceUrl.getUrl();

			if (url.startsWithIgnoreCase(CASE_DETAIL_VISUALFORCE_PAGE)) {
				String caseId = url.substring(CASE_DETAIL_VISUALFORCE_PAGE.length());
				
				String caseNumber = '';
				if (caseMap.containsKey(caseId))
				{
					caseNumber = caseMap.get(caseId).CaseNumber;
					myFriendlyUrls.add(new PageReference(CASE_DETAIL_PAGE + caseNumber));
				}
				else
				{
					// TODO - show an error that the caseNumber doesn't exist (or show no access)
					myFriendlyUrls.add(new PageReference(CASE_PAGE));
				}
			}
			else if (url.startsWithIgnoreCase(CASE_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(CASE_PAGE));
			}
			else if (url.startsWithIgnoreCase(LOGIN_VISUALFORCE_PAGE)) {
				String params = url.substring(LOGIN_VISUALFORCE_PAGE.length());
				// Getting around any links to just /Login without a redirect
				if (String.isBlank(params)) {
					params = '?startURL=%2F';
				}
				myFriendlyUrls.add(new PageReference(LOGIN_PAGE + params));
			}
			else if (url.startsWithIgnoreCase(LOGOUT_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(LOGOUT_PAGE));
			}
			else if (url.startsWithIgnoreCase(GROUP_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(GROUP_PAGE));
			}
			else if (url.startsWithIgnoreCase(PROFILE_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(PROFILE_PAGE));
			}
			else if (url.startsWithIgnoreCase(ANSWER_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(ANSWER_PAGE));
			}
			else if (url.startsWithIgnoreCase(SELF_REG_CONFIRM_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(SELF_REG_CONFIRM_PAGE));
			}
			else if (url.startsWithIgnoreCase(SELF_REG_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(SELF_REG_PAGE));
			}
			else if (url.startsWithIgnoreCase(FORGOT_PASSWORD_CONFIRM_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(FORGOT_PASSWORD_CONFIRM_PAGE));
			}
			else if (url.startsWithIgnoreCase(FORGOT_PASSWORD_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(FORGOT_PASSWORD_PAGE));
			}
			else if (url.startsWithIgnoreCase(SS_404_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(SS_404_PAGE));
			}
			else if (url.startsWithIgnoreCase(EXCEPTION_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(EXCEPTION_PAGE));
			}
			else if (url.startsWithIgnoreCase(SS_509_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(SS_509_PAGE));
			}
			else if (url.startsWithIgnoreCase(HOME_VISUALFORCE_PAGE)) {
				myFriendlyUrls.add(new PageReference(HOME_PAGE));
			}
			else
			{
				myFriendlyUrls.add(mySalesforceUrl);
			}
		}

		return myFriendlyUrls;
	}
	
}