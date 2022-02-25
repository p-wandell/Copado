/* Copyright ©2016-2018 7Summits Inc. All rights reserved. */

/**
 * Created by francois korb on 6/5/17.
 */

global with sharing class SVNSUMMITS_EventBaseController {
	public SVNSUMMITS_EventBaseController() {
	}

	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	global static BaseModel getModel() {
		return new BaseModel();
	}

	global with sharing class BaseModel {
		@AuraEnabled
		global String namespacePrefix { get; set; }

		global BaseModel() {
			try {
				this.namespacePrefix = [
						SELECT NamespacePrefix
						FROM ApexClass
						WHERE Name = 'SVNSUMMITS_EventBaseController' LIMIT 1
				].NamespacePrefix;
			} catch (QueryException e) {
				System.debug('SVNSUMMITS_EventBaseController - Failed to get Events namespace prefix');
			}
		}
	}
}