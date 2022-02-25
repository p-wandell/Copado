/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public without sharing class x7sFilesShareController {

	private static final String VISIBILITY_SEPARATOR = '.';
	private static final String MULTI_LIST_SEPARATOR = ',';
	private static final String MULTI_LIST_SPLIT = ',\\s*';
	private static final String MULTI_LIST_DELIMITER = '\'';
	private static final String INCLUDES_PREFIX = '(';
	private static final String INCLUDES_POSTFIX = ')';
	private static final String USER_PREFIX = '005';

	@TestVisible
	private static final String X7S_ROW_CAUSE = Schema.X7S_File_Folder__Share.rowCause.X7s_Folder_Custom_Sharing__c;

	/**
	 * Get all folder settings
	 *
	 * @return Map of folder settings
	 */
	@AuraEnabled
	public static Map<String, String> getFolderSettings() {
		Map<String, String> filesSettings = new Map<String, String>();

		List<X7S_Files_Setting__mdt> allSettings = X7S_Files_Setting__mdt.getAll().values();
		allSettings.sort();

		for (X7S_Files_Setting__mdt setting : allSettings) {
			filesSettings.put(setting.Id.to15(), setting.Label);
		}

		return filesSettings;
	}

	/**
	 * Update the settings for the specified folder.
	 *
	 * @param folderId target folder Id
	 * @param settingId setting Id
	 *
	 * @return true if success
	 */
	@AuraEnabled
	public static Boolean updateFolderSetting(String folderId, String settingId) {
		Boolean result = false;

		if (X7S_File_Folder__c.SObjectType.getDescribe().isAccessible() &&
			X7S_File_Folder__c.SObjectType.getDescribe().isCreateable() &&
			X7S_File_Folder__c.SObjectType.getDescribe().isUpdateable()) {

			X7S_File_Folder__c updatedFolder = [SELECT Id, Sharing_Setting__c FROM X7S_File_Folder__c WHERE Id = :folderId WITH SECURITY_ENFORCED];

			if (updatedFolder != null) {
				updatedFolder.Sharing_Setting__c = settingId;
				upsert updatedFolder;
				result = true;
			}
		}
		return result;
	}

	/**
	 * Batch worker function to apply sharing for the specified folder.
	 *
	 * @param folder Folder to process
	 *
	 * @return true if successful
	 */
	public static Boolean applyFolderShare(X7S_File_Folder__c folder) {
		Boolean success = true;

		if (String.isNotBlank(folder.Sharing_Setting__c)) {
			success = shareFolder(folder);
		}
		else { removeExistingShares(folder, null); }

		return success;
	}

	/**
	 * Create share records for the folder for the LWC client
	 *
	 * @param folderId Folder Id
	 *
	 * @return Success
	 */
	@AuraEnabled
	public static Boolean shareCurrentFolder(String folderId) {
		Boolean success = true;

		X7S_File_Folder__c folder = [SELECT Id, Name, Description__c, Parent_Folder__c, Sharing_Setting__c FROM X7S_File_Folder__c WHERE Id = :folderId  WITH SECURITY_ENFORCED ];

		if (String.isNotBlank(folder.Sharing_Setting__c)) {
			success = shareFolder(folder);
		}
		else { removeExistingShares(folder, null); }

		return success;
	}

	public static Boolean shareFolder(X7S_File_Folder__c folder) {
//		System.debug('shareFolder: ' + folder.Name + ' ' + folder.Id);
		Boolean success = true;

		if (!X7S_File_Folder__c.SObjectType.getDescribe().isAccessible() || !X7S_File_Folder__Share.SObjectType.getDescribe().isCreateable()) {
//			System.debug('No access to X7S_File_Folder__c');
			return false;
		}

		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance(folder.Sharing_Setting__c);
		x7sFilesCriteriaListModel criteriaListModel = x7sFilesController.getCriteriaValues(folder.Sharing_Setting__c);

		// targeted users
		Set<String> userIds = new Set<String>();

		//order by logicId
		criteriaListModel.criteriaFieldList.sort();

		String accessLevel = setting.Share_Access_Level__c;
		String defaultLogic = criteriaListModel.defaultLogic.toLowerCase();
		String customLogic = criteriaListModel.customLogic;
		x7sFilesShareLogicController.Node root;

		if (defaultLogic == 'Custom' && String.isNotBlank(customLogic)) {
			root = setupCustomLogic(customLogic);
			if (root != null) {
				postOrderTraverse(criteriaListModel, root);
			}

			userIds = root.data;
		}
		else {
			Integer setCount = 0;
			for (x7sFilesCriteriaFieldModel criteriaModel : criteriaListModel.criteriaFieldList) {
//				System.debug('Criteria: (' + criteriaModel.logicId + ') ' + criteriaModel.fieldName);

				String objectName = getModelObject(criteriaModel).toLowerCase();

				switch on objectName {
					when 'account' {
						Set<String> contactUsers = new Set<String>();
						for (User contactEntry : getAccountUsers(getIdSet(criteriaModel))) {
							contactUsers.add(contactEntry.Id);
						}
						userIds = setCount == 0 ? contactUsers : addUserIds(userIds, contactUsers, defaultLogic);
					}
					when 'contact', 'user' {
						Set<String> contactUsers = new Set<String>();
						for (User contactEntry : getUsers(criteriaModel)) {
							contactUsers.add(contactEntry.Id);
						}
						userIds = setCount == 0 ? contactUsers : addUserIds(userIds,contactUsers , defaultLogic);
					}
					when else {
						// not sure what the user ID would be here
						Set<String> idSet = getIdSet(criteriaModel);
						userIds = setCount == 0 ? idSet : addUserIds(userIds, idSet, defaultLogic);
					}
				}
				setCount += 1;
			}
		}
//		System.debug('user Ids (' + userIds.size() + ') : ' + userIds);

		List<X7S_File_Folder__Share> newShares = new List<X7S_File_Folder__Share>();

		for (Id userId : userIds) {
//			System.debug('Creating share for user: ' + userId + ' Folder shared: ' + folder.Id);
			newShares.add(new X7S_File_Folder__Share(ParentId = folder.Id, UserOrGroupId = userId, RowCause = X7S_ROW_CAUSE, AccessLevel = accessLevel));
		}

		newShares = removeExistingShares(folder, newShares);

		//dumpShareList('New shares', newShares);

		try {
			insert newShares;
		}
		catch (Exception ex) { success = false; System.debug('ERROR: ' + ex.getMessage()); }

//		System.debug('shareFolder result: ' + success);
		return success;
	}

//	private static void dumpShareList(String message, List<X7S_File_Folder__Share> shareList) {
//		System.debug(message + ' : ' + shareList.size());
//		for (X7S_File_Folder__Share share : shareList) { System.debug(share); }
//	}

	private static List<X7S_File_Folder__Share> removeExistingShares(X7S_File_Folder__c folder, List<X7S_File_Folder__Share> newShares) {
//		System.debug('Remove existing shares');
		List<X7S_File_Folder__Share> insertShares = new List<X7S_File_Folder__Share>();
		List<X7S_File_Folder__Share> deleteShares = new List<X7S_File_Folder__Share>();

		if (X7S_File_Folder__Share.SObjectType.getDescribe().isDeletable()) {
			List<X7S_File_Folder__Share> existingShares = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM X7S_File_Folder__Share WHERE ParentId =:folder.Id AND RowCause = :X7S_ROW_CAUSE];
			//dumpShareList('Existing shares', existingShares);

			if (existingShares != null && existingShares.size() > 0) {

				if (newShares != null) {
					for (X7S_File_Folder__Share existing : existingShares) {
						if (!containsShare(newShares, existing)) { deleteShares.add(existing); }
					}
					for (X7S_File_Folder__Share newShare : newShares) {
						if (!containsShare(existingShares, newShare)) { insertShares.add(newShare); }
					}
				} else { deleteShares.addAll(existingShares); }

				//dumpShareList('deleting shares', deleteShares);

				if (deleteShares.size() > 0) { delete deleteShares; }

				return insertShares;
			}
		}

		return newShares;
	}

	@TestVisible
	private static Boolean containsShare(List<X7S_File_Folder__Share> shareList, X7S_File_Folder__Share shareItem) {
		for (X7S_File_Folder__Share share : shareList) {
			if (share.ParentId == shareItem.ParentId &&
				share.UserOrGroupId == shareItem.UserOrGroupId) {
				return true;
			}
		}
		return false;
	}

	@TestVisible
	private static x7sFilesShareLogicController.Node setupCustomLogic(String customLogic) {
//		System.debug('setupCustomLogic: ' + customLogic);

		x7sFilesShareLogicController logicController = new x7sFilesShareLogicController();
		x7sFilesShareLogicController.Node root = logicController.parseShareRule(customLogic);

//		System.debug(root.toArray());
//		root.dump('root');
//		root.left.dump('left');
//		root.right.dump('right');
//		System.debug('Root data : ' + root.data);

		return root;
	}

	private static void postOrderTraverse(x7sFilesCriteriaListModel model, x7sFilesShareLogicController.Node root) {
		if (root != null) {
			postOrderTraverse(model, root.left);
			postOrderTraverse(model, root.right);

			processParentNode(model, root);
		}
	}

	private static void processParentNode(x7sFilesCriteriaListModel criteriaListModel, x7sFilesShareLogicController.Node currentNode) {
//		currentNode.dump('processing Node');

		if (!currentNode.isLeaf() && String.isNotBlank(currentNode.operation)) {
//			System.debug('processing : ' + currentNode.operation);

			// process left
			if (currentNode.left.logicId != '0') {
				x7sFilesCriteriaFieldModel criteriaModel = criteriaListModel.findByLogicId(currentNode.left.logicId);
//				System.debug('left criteriaModel: ' + criteriaModel);
				addNodeUsers(criteriaModel, currentNode.left);
			}

			// process right
			if (currentNode.right.logicId != '0') {
				x7sFilesCriteriaFieldModel criteriaModel = criteriaListModel.findByLogicId(currentNode.right.logicId);
//				System.debug('right criteriaModel: ' + criteriaModel);
				addNodeUsers(criteriaModel, currentNode.right);
			}

			currentNode.data = addUserIds(currentNode.left.data, currentNode.right.data, currentNode.operation);
		}
	}

	private static void addNodeUsers(x7sFilesCriteriaFieldModel criteriaModel, x7sFilesShareLogicController.Node currentNode) {
		String objectName = getModelObject(criteriaModel);
//		System.debug('getting data for: ' + currentNode.logicId + ' from ' + objectName) ;

		if (objectName.equalsIgnoreCase('account')) {
			Set<String> contactUsers = new Set<String>();
			for (User contactEntry : getAccountUsers(getIdSet(criteriaModel))) { contactUsers.add(contactEntry.Id); }
			currentNode.data = contactUsers;
		}

		if (objectName.equalsIgnoreCase('contact')) {
			Set<String> contactUsers = new Set<String>();
			for (User contactEntry : getUsers(criteriaModel)) { contactUsers.add(contactEntry.Id); }
			currentNode.data = contactUsers;
		}

		if (objectName.equalsIgnoreCase('user')) {
			currentNode.data = getIdSet(criteriaModel);
		}
//		System.debug('Node data:' + currentNode.data);
	}

	@TestVisible
	private static Set<String> addUserIds(Set<String> set1, Set<String> set2, String logic) {
//		System.debug('addUserIds: ' + logic);
		String operator = logic == 'or' || logic == 'O' ? 'O' : 'A';

		Set<String> result = new Set<String>();

		switch on operator {
			when 'A' {
				if (set1.size() > 0 && set2.size() > 0) {
					for (String entry : set1) {
						if (entry.startsWithIgnoreCase(USER_PREFIX) && set2.contains(entry)) {
							result.add(entry);
						}
					}
				}
			}
			when 'O' {
				if (set1.size() > 0 || set2.size() > 0) {
					if (set1.size() == 0) {
						result.addAll(addUsers(set2));
					}
					else {
						if (set2.size() == 0) { result.addAll(addUsers(set1)); }
						else {
							result.addAll(addUsers(set1));
							result.addAll(addUsers(set2));
						}
					}
				}
			}
		}

//		System.debug('result: ' + result);
		return result;
	}

	private static Set<String> addUsers(Set<String> userSet) {
		Set<String> resultSet = new Set<String>();
		for(String item : userSet) {
			if (item.startsWithIgnoreCase(USER_PREFIX)) {
				resultSet.add(item);
			}
		}

		return resultSet;
	}

	private static String getModelObject(x7sFilesCriteriaFieldModel model) {
//		System.debug('getModelObject: ' + model);
		String objectName = model.fieldName.substringBefore(VISIBILITY_SEPARATOR);
		return objectName;
	}

	private static String getModelFieldName(x7sFilesCriteriaFieldModel model) {
		String fieldName = model.fieldName.substringAfter(VISIBILITY_SEPARATOR);
		return fieldName;
	}

	private static Set<String> getIdSet(x7sFilesCriteriaFieldModel model) {
		Set<String> idList = new Set<String>();
		String objectName = getModelObject(model);
		String fieldName = getModelFieldName(model);

		String query = 'SELECT Id, ' + fieldName;
		query += getCriteriaFromClause(objectName);
		query += getCriteriaWhereClause(fieldName, model.type, model.operator, model.fieldValue);
//		System.debug(objectName + ' query: ' + query);

		for (SObject entry : Database.query(query)) { //NOPMD
			idList.add((String) entry.get('Id'));
		}

		return idList;
	}

	private static List<User> getAccountUsers(Set<String> accountIds) {
		List<User> users = new List<User>();

		if (Account.SObjectType.getDescribe().isAccessible() &&
			User.SObjectType.getDescribe().isAccessible()) {
			List<Account> accounts = [SELECT Id, Name,
				(SELECT Id, Contact.Id, AccountId, UserRoleId, IsActive FROM Users WHERE UserRoleId != NULL AND IsActive = TRUE)
				FROM Account WHERE Id IN:accountIds WITH SECURITY_ENFORCED];

			for (Account accountEntry : accounts) { users.addAll(accountEntry.Users); }
		}
//		System.debug('account contacts: ' + users);
		return users;
	}

	private static List<User> getUsers(x7sFilesCriteriaFieldModel model) {
		Boolean addIsActive = !getModelFieldName(model).equalsIgnoreCase('IsActive');

		String query = 'SELECT Id, UserRoleId, ' + model.fieldName;
		if (addIsActive) { query += ', IsActive '; }
		query += getCriteriaFromClause('User');
		query += getCriteriaWhereClause(model.fieldName, model.type, model.operator, model.fieldValue);
		query += ' AND UserRoleId != NULL';
		if (addIsActive) { query += ' AND IsActive = TRUE'; }
//		System.debug('Contact user query: ' + query);

		List<User> users = Database.query(query); // NOPMD
		System.debug('Contact Users: ' + users);

		return users;
	}

	@TestVisible
	private static String getCriteriaFromClause(String objectName) {
		return ' FROM ' + objectName;
	}

	@TestVisible
	private static String getCriteriaWhereClause(String fieldName, String fieldType, String operator, String fieldValue) {
		List<String> whereParts = new List<String>();

		if (operator == 'NotContains') {
			whereParts.add(x7sFilesConstants.NOT_CONTAINS_OPERATOR);
		}

		whereParts.add(fieldName);

		switch on operator {
			when 'Equals' {
				whereParts.add(x7sFilesConstants.EQUALS_OPERATOR);
				if (String.isBlank(fieldValue)) {
					fieldValue = null;
				}
			}
			when 'NotEquals' {
				whereParts.add(x7sFilesConstants.NOT_EQUALS_OPERATOR);
				if (String.isBlank(fieldValue)) {
					fieldValue = null;
				}
			}
			when 'GreaterThan' {
				whereParts.add(x7sFilesConstants.GREATER_THAN_OPERATOR);
			}
			when 'GreaterEqual' {
				whereParts.add(x7sFilesConstants.GREATER_EQUAL_OPERATOR);
			}
			when 'LessThan' {
				whereParts.add(x7sFilesConstants.LESS_THAN_OPERATOR);
			}
			when 'LessEqual' {
				whereParts.add(x7sFilesConstants.LESS_EQUAL_OPERATOR);
			}
			when 'Includes' {
				whereParts.add(x7sFilesConstants.INCLUDES_OPERATOR);
			}
			when 'Excludes' {
				whereParts.add(x7sFilesConstants.EXCLUDES_OPERATOR);
			}
			when 'Contains', 'NotContains' {
				whereParts.add(x7sFilesConstants.CONTAINS_OPERATOR);
			}
		}

		String delimiter = fieldValue == null ? ''
			: ((fieldType == 'Date') || (fieldType == 'Checkbox') || (fieldType == 'multi-picklist') || (fieldType == 'number')) ? '' : '\'';

		// have to add quotes to multi picklist values
		if (fieldType == 'multi-picklist' && String.isNotBlank(fieldValue)) {
			List<String> multiParts = new List<String>();
			if (fieldValue.indexOf(MULTI_LIST_SEPARATOR) != -1) {
				multiParts = fieldValue.split(MULTI_LIST_SPLIT);
			} else {
				multiParts.add(fieldValue);
			}

			List<String> fieldValues = new List<String>();
			for (String entry : multiParts) {
				if (entry.startsWith(MULTI_LIST_DELIMITER)) {
					fieldValues.add(entry.trim());
				}
				else {
					fieldValues.add(MULTI_LIST_DELIMITER + entry.trim() + MULTI_LIST_DELIMITER);
				}
			}
			fieldValue = String.join(fieldValues, MULTI_LIST_SEPARATOR);
		}

		whereParts.add(operator == 'Includes' || operator == 'Excludes' ? INCLUDES_PREFIX : '');
		whereParts.add(delimiter);
		whereParts.add(String.isNotBlank(fieldValue) ? fieldValue : 'null');
		whereParts.add(delimiter);
		whereParts.add(operator == 'Includes' || operator == 'Excludes' ? INCLUDES_POSTFIX : '');

		String whereClause = whereParts.size() > 0 ? ' WHERE ' + String.join(whereParts, '') : '';

//		System.debug('Where clause: ' + whereClause);
		return whereClause;
	}
}