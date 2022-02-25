/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesFilterData {

	/**
	 * Get the FileType Values
	 *
	 * @return Map<String,ContentDocument> List of FileType
	 */

	@AuraEnabled
	public static Map<String, ContentDocument> getFileType() {
		List<ContentDocument> typeList = [SELECT FileType FROM ContentDocument WITH SECURITY_ENFORCED LIMIT :x7sFilesConstants.QueryLimit];

		Map<String, ContentDocument> ContentTypes = new Map<String, ContentDocument>();
		for (ContentDocument contentType : typeList) {
			ContentTypes.put(contentType.FileType, contentType);//This is map and hence it will always have unique values
		}

		return ContentTypes;
	}

	/**
	 * Get the Owner Values
	 *
	 * @return Map<String,String> List of Owners
	 */

	@AuraEnabled
	public static Map<String, String> getOwners() {
		Boolean isNickNameEnabled = isNicknameDisplayEnabled();
		List<User> ownerList = [SELECT Name, CommunityNickname FROM User WHERE Id IN (SELECT CreatedById FROM ContentDocument) WITH SECURITY_ENFORCED ];

		Map<String, String> Owners = new Map<String, String>();
		for (User singleUser : ownerList) {
			if (isNickNameEnabled) {
				Owners.put(singleUser.Id, singleUser.CommunityNickname);//This is map and hence it will always have unique values
			}
			else {
				Owners.put(singleUser.Id, singleUser.Name);//This is map and hence it will always have unique values
			}
		}

		return Owners;
	}

	/**
	 * Get the modifierUsers Values
	 *
	 * @return Map<String,String> List of modifierUsers
	 */

	@AuraEnabled
	public static Map<String, String> getModifierUsers() {
		Boolean isNickNameEnabled = isNicknameDisplayEnabled();
		List<User> modifierList = [SELECT Name, CommunityNickname FROM User WHERE Id IN (SELECT LastModifiedById FROM ContentDocument) WITH SECURITY_ENFORCED];

		Map<String, String> modifiers = new Map<String, String>();
		for (User singleUser : modifierList) {
			if (isNickNameEnabled) {
				modifiers.put(singleUser.Id, singleUser.CommunityNickname);//This is map and hence it will always have unique values
			}
			else {
				modifiers.put(singleUser.Id, singleUser.Name);//This is map and hence it will always have unique values
			}
		}
		return modifiers;
	}

	private static Boolean isNicknameDisplayEnabled() {
		Boolean isNicknameDisplayEnabled = false;

		try {
			Id networkId = System.Network.getNetworkId();
			Boolean display = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED LIMIT 1]?.OptionsNicknameDisplayEnabled;
			if (display != null) {
				isNicknameDisplayEnabled = display;
			}
		}
		catch (Exception e) {
			System.debug('Nickname option not found');
		}
		return isNicknameDisplayEnabled != null ? isNicknameDisplayEnabled : false;
	}
}