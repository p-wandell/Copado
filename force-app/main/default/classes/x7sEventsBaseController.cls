/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sEventsBaseController {
	@AuraEnabled
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	public static BaseModel getModel() {
		return new BaseModel();
	}

	public with sharing class BaseModel {
		@AuraEnabled
		public String namespacePrefix { get; set; }

		public BaseModel() {
			//try {
				//this.namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'x7sEventsBaseController' LIMIT 1].NamespacePrefix;
				this.namespacePrefix = '';
//			} catch (QueryException e) {
//				System.debug('x7sEventsBaseController - Failed to get Events namespace prefix');
//			}
		}
	}
	
	public static String getCommunityUrl()
	{
		String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm();

		try
		{
			String url = Network.getLoginUrl(Network.getNetworkId());
			String communityUrl = url.substring(0, url.lastIndexOf('/s/'));
			return communityUrl;
		} catch (Exception e)
		{
			System.debug('No community found');
			return baseUrl;
		}
	}
}