/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
 * Created by francois korb on 2/3/17.
 */

global with sharing class SVNSUMMITS_NewsBaseController
{

	public SVNSUMMITS_NewsBaseController()
	{
	}

	@AuraEnabled
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
			this.namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'SVNSUMMITS_NewsBaseController' LIMIT 1].NamespacePrefix;
			this.lexMode         = System.Network.getNetworkId() == null;
		}
	}
}