/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

global with sharing class x7sNewsBaseController
{

	@AuraEnabled(Cacheable=true)
	global static BaseModel getModel()
	{
		return new BaseModel();
	}

	global class BaseModel
	{
		@AuraEnabled
		global String namespacePrefix { get; set; }

		@AuraEnabled
		global Boolean lexMode { get; set; }

		global BaseModel()
		{
			// Uncomment for managed package
			//this.namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'x7sNewsBaseController' LIMIT 1].NamespacePrefix;
			this.namespacePrefix = '';
			this.lexMode         = System.Network.getNetworkId() == null;
		}
	}

	global static String getCommunityUrl()
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