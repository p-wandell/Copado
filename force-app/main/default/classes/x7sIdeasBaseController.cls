/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasBaseController {
	public x7sIdeasBaseController() {
	}

	@AuraEnabled(Cacheable=true)
	public static BaseModel getModel() {
		return new BaseModel();
	}

	public with sharing class BaseModel {
		@AuraEnabled
		public String namespacePrefix { get; set; }

		@AuraEnabled
		public Boolean lexMode { get; set; }

		public BaseModel() {
			this.namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'x7sIdeasBaseController' LIMIT 1].NamespacePrefix;
			this.lexMode = System.Network.getNetworkId() == null;
		}
	}
}