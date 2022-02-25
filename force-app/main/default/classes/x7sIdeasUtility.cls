/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasUtility {
	@TestVisible
	private static String getNameSpacePrefix() {
		String namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'x7sIdeasUtility' LIMIT 1].NamespacePrefix;

		return String.isNotBlank(namespacePrefix) ? namespacePrefix + '__' : '';
	}

	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	public static String getZoneId(String nameValue) {
		String zoneId = '';

		try {
			if (!String.isEmpty(nameValue)) {
				List<Community> currCommunity = [SELECT Id FROM Community WHERE Name = :nameValue WITH SECURITY_ENFORCED];

				if (currCommunity != null && currCommunity.size() > 0) {
					zoneId = currCommunity[0].Id;
				}
			}
			return zoneId;
		} catch (Exception ex) {
            System.debug('getZoneId() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());
            return null;
        }
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return !Auth.CommunitiesUtil.isGuestUser();
	}

	/**
	 * Check if the user nickname should be displayed.
	 * This is a community preference but we use a CMT setting for LEX
	 * @return true if display nickname is enabled
	 */
	@AuraEnabled (Cacheable=true)
	public static Boolean isNicknameDisplayEnabled() {
		Id networkId = System.Network.getNetworkId();
		Boolean isNicknameDisplayEnabled = false;

		try {
			// get initial option from CMT in case we are in LEX
			isNicknameDisplayEnabled =  [SELECT Id, LEX_Nickname_Display__c FROM X7S_Ideas_Setting__mdt WHERE DeveloperName = 'Default']?.LEX_Nickname_Display__c;

			// this will throw in LEX
			Boolean display = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED LIMIT 1]?.OptionsNicknameDisplayEnabled;
			if (display != null) { isNicknameDisplayEnabled = display;}
		}
		catch (Exception e) { System.debug('Nickname option not found - possibly in LEX mode');}

		return isNicknameDisplayEnabled != null ? isNicknameDisplayEnabled : false;
	}

	public static Boolean emailTurnedOn() {
		Boolean emailsTurnedOn = false;

		try {
			Messaging.reserveSingleEmailCapacity(0);
			emailsTurnedOn = true;
		}
		catch (System.NoAccessException e) {
			System.debug('emailsTurnedOn check failed: ' + e.getMessage());
		}

		return emailsTurnedOn;
	}

	public static String getOrgWideSenderEmailId(String returnEmail) {
		String emailId = '';
		System.debug('Getting org wide sender email address');
		try {
			OrgWideEmailAddress orgWideEmail = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address LIKE :returnEmail WITH SECURITY_ENFORCED LIMIT 1];
			if (orgWideEmail != null) {
				emailId = orgWideEmail.Id;
			}
		}
		catch (System.QueryException ex) {
			System.debug('QueryException - Failed to query OrgWideEmailAddress - users cannot be notified: ' + ex.getMessage());
		}
		catch (DmlException ex) {
			System.debug('DmlException - Failed to query OrgWideEmailAddress - users cannot be notified: ' + ex.getMessage());
		}

		return emailId;
	}

	public static Boolean permissionSetMember(String userId, String permissionSetList) {
		Boolean isMember = false;

		if (String.isNotBlank(permissionSetList)) {
			List<String> permissionSets = permissionSetList.split(',\\s*');

			isMember = [
				SELECT COUNT()
				FROM PermissionSetAssignment
				WHERE AssigneeId = :userId AND PermissionSet.Name IN :permissionSets
			] > 0;
		}

		return isMember;
	}

	public static Boolean profileMember(String userId, String profileNameList) {
		Boolean isMember = false;
		String networkId = System.Network.getNetworkId();
		System.debug('profileMember: NetworkId: ' + networkId);

		Network network;

		if (Test.isRunningTest()) {
			try {
				X7S_Ideas_Setting__mdt setting = [SELECT Id, Default_Test_Community_ID__c FROM X7S_Ideas_Setting__mdt WHERE DeveloperName = 'Default' WITH SECURITY_ENFORCED LIMIT 1];
				if (setting != null) {
					networkId = setting.Default_Test_Community_ID__c;
					System.debug('Network ID from CMT Default: ' + networkId);
				}
			}
			catch (QueryException ex) {
				System.debug('Test - profileMember exception: ' + ex.getMessage());
			}

			if (networkId == null) {
				network = [SELECT Id, Name, OptionsGuestChatterEnabled FROM Network WHERE Status IN ('Live', 'UnderConstruction') WITH SECURITY_ENFORCED LIMIT 1];
				networkId = network.Id;
				System.debug('Network Id from Query: ' + networkId);
			}
		}

		if (String.isNotBlank(profileNameList)) {
			List<String> profileNames = profileNameList.split(',\\s*');
			try {
				User currentUser = [SELECT Id, Profile.Name, UserType FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
				network = [SELECT Id, Name, OptionsGuestChatterEnabled FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED];

				if (currentUser != null) {
					List<NetworkMember> member = [SELECT MemberId, NetworkId FROM NetworkMember WHERE NetworkId = :networkId AND MemberId = :userId WITH SECURITY_ENFORCED LIMIT 1];
					if (member.size() > 0) {
						isMember = profileNames.contains(currentUser.Profile.Name);
					}
					else {
						// check to see if network allows guest chatter access
						if (currentUser.UserType == 'Guest' && network.OptionsGuestChatterEnabled == true) { isMember = true;}
					}
				}
			}
			catch (Exception ex) {
				System.debug('profileMember exception: ' + ex.getMessage());
			}
		}

		return isMember;
	}

	// Parse a field value string and return as a map
	//      field1:value,field2:value2
	public static Map<String, String> parseFieldValueString(String fieldValueString) {
		Map<String, String> userFieldValues = null;

		if (String.isNotBlank(fieldValueString)) {
			userFieldValues = new Map<String, String>();

			List<String> fieldValuePairs = fieldValueString.trim().split(',');
			for (String fieldValue : fieldValuePairs) {
				String[] entries = fieldValue.trim().split(':');
				if (String.isNotBlank(entries[0])) {
					userFieldValues.put(entries[0], entries[1]);
				}
			}
		}
		return userFieldValues;
	}

	public static User setCustomUserFields(User newUser) {
		try {
			X7S_Ideas_Setting__mdt setting = [SELECT Id, User_Custom_FieldValues__c FROM X7S_Ideas_Setting__mdt WHERE DeveloperName = 'Default' WITH SECURITY_ENFORCED LIMIT 1];
		
			if (setting != null && String.isNotBlank(setting.User_Custom_FieldValues__c)) {
				Map<String, String> customFields = x7sIdeasUtility.parseFieldValueString(setting.User_Custom_FieldValues__c);

				if (customFields != null && customFields.size() > 0) {
					for (String fieldName : customFields.keySet()) { newUser.put(fieldName, customFields.get(fieldName));}
				}
			}
			return newUser;

		} catch (Exception ex) { System.debug('setCustomUserFields() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber()); return null;}
	}

	public static Boolean isIdeaObjectCreateable() {
		Boolean isCreateEnabled = false;

		if (Idea.SObjectType.getDescribe().isCreateable()) {
			isCreateEnabled = true;
		}
		return isCreateEnabled;
	}

	public static List<String> getIdeaStatusValues() {
		List<String> options = new List<String>();

		Schema.SObjectType objType = Schema.getGlobalDescribe().get('Idea');
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		List<Schema.PicklistEntry> values = fieldMap.get('Status').getDescribe().getPicklistValues();

		for (Schema.PicklistEntry a : values) {
			if (a.active) {
				options.add(a.getLabel());
			}
		}

		return options;
	}

	@AuraEnabled
	public static List<String> getIdeaCategoryValues() {
		List<String> options = new List<String>();

		Schema.SObjectType objType = Schema.getGlobalDescribe().get('Idea');
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		List<Schema.PicklistEntry> values = fieldMap.get('Categories').getDescribe().getPicklistValues();

		for (Schema.PicklistEntry a : values) {
			if (a.active) {
				options.add(a.getLabel());
			}
		}

		options.sort();

		return options;
	}
}