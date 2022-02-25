/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasListController {
	@AuraEnabled
	public static Id getUserId() {
		return UserInfo.getUserId();
	}

	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return !Auth.CommunitiesUtil.isGuestUser();
	}

	@AuraEnabled (Cacheable=true)
	public static Boolean isNicknameDisplayEnabled() {
		Id networkId = System.Network.getNetworkId();
		Boolean isNicknameDisplayEnabled = true;
		try {
			Network currNetwork = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED LIMIT 1];
			isNicknameDisplayEnabled = currNetwork.OptionsNicknameDisplayEnabled;
		}
		catch (Exception e) {
			isNicknameDisplayEnabled = true;
		}

		return isNicknameDisplayEnabled;
	}

	@AuraEnabled (Cacheable=true)
	public static String getZoneId(String nameValue) {
		if (!String.isEmpty(nameValue)) {
			try {
				List<Community> currCommunity = [SELECT Id FROM Community WHERE Name = :nameValue WITH SECURITY_ENFORCED];
				if (currCommunity != null && currCommunity.size() > 0) {
					return currCommunity[0].Id;
				}
			} catch (Exception ex) {
				System.debug('getZoneId() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());
			}
		}
		return '';
	}

	@AuraEnabled (Cacheable=true)
	public static x7sIdeasCommon getCommonSettings(String zoneName) {
		x7sIdeasCommon settings = new x7sIdeasCommon('', false);
		if (String.isNotBlank(zoneName)) {
			settings.zoneId = getZoneId(zoneName);
		}
		return settings;
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getIdeas() {
		System.debug('getIdeas >>>');
		return getIdeas(50, null, null, 'Popular Ideas', false, false, null, false, null, false, false, 'My Ideas', '', '', '', '', false, false, '', false, '', false, '', false, '', false, '', false, '', false, '');
	}


	@AuraEnabled
	public static x7sIdeasViewController.VotingDetails getVotingDetails(String ideaId) {
		return x7sIdeasViewController.getVotingLimitsForAccount(ideaId);
	}

	@AuraEnabled
	public static Integer getIdeasAttributeCount(String zoneId, String type, String userId) {
		if (type == 'Voted On Ideas' && Vote.SObjectType.getDescribe().isAccessible()) {
			List<Vote> voteList = [SELECT ParentId FROM Vote WHERE CreatedById = :userId AND Parent.Type = 'Idea'];
			List<String> votedOnIdList = new List<String>();
			for (Vote v : voteList) {
				votedOnIdList.add(v.ParentId);
			}

			return [SELECT COUNT() FROM Idea WHERE CommunityId = :zoneId AND Id IN :votedOnIdList AND CreatedById != :userId];
		}
		else {
			return [SELECT COUNT() FROM Idea WHERE CreatedById = :userId AND CommunityId = :zoneId];
		}
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getFeaturedIdeas(String zoneId, String recordId1, String recordId2, String recordId3) {
		Set<Id> ideasIds = new Set<Id>();
		Integer listSize = 0;

		if (String.isNotBlank(recordId1)) {
			ideasIds.add(recordId1);
			listSize += 1;
		}

		if (String.isNotBlank(recordId2)) {
			ideasIds.add(recordId2);
			listSize += 1;
		}

		if (String.isNotBlank(recordId3)) {
			ideasIds.add(recordId3);
			listSize += 1;
		}

		// if ID's were not specified, use the record flag
		if (listSize == 0) {
			String featuredQuery = 'SELECT Id, VoteTotal FROM Idea WHERE Featured__c = TRUE';
			if (String.isBlank(zoneId)) { featuredQuery += ' AND CommunityId != null';}
			else { featuredQuery += ' AND CommunityId = \'' + String.escapeSingleQuotes(zoneId) + '\'';}

			featuredQuery += ' ORDER BY VoteTotal DESC LIMIT 3';

			//PMD : False positive, All variables are checked
			List<Idea> ideaList = (List<Idea>) Database.query(featuredQuery); //NOPMD

			for (Idea featuredId : ideaList) {
				ideasIds.add(featuredId.Id);
				listSize += 1;
			}
		}

		System.debug('getFeatured - IDs: ' + ideasIds);

		String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.Id, Related_Topic_Name__c,';
		QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,';
		QUERY += ' (SELECT Type, CreatedById, CreatedBy.CommunityNickname FROM Votes WHERE CreatedById = \'' + UserInfo.getUserId() + '\'' + ')';
		QUERY += ' FROM Idea';
		QUERY += ' WHERE Id IN :ideasIds ';

		x7sIdeasListWrapper wrapper = new x7sIdeasListWrapper(QUERY, listSize, ideasIds);
		return wrapper;
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getIdeas(
		Integer listSize,
		String categories,
		String zoneId,
		String sortBy,
		Boolean limitVoteToEmailDomain,
		Boolean filterByTopic,
		String topicNameAndFeatureList,
		Boolean filterBySearchTerm,
		String searchTerm,
		Boolean filterOnUserOwned,
		Boolean filterOnUserVoted,
		String searchMyIdeas,
		String searchByCategories,
		String searchByTopics,
		String searchByStatus,
		String searchByThemes,
		Boolean filterByMergeIdea,
		Boolean filterByMyVotedIdeas,
		String searchByMyVotedIdeas,
		Boolean filterMyCommentedIdeas,
		String searchMyCommentedIdeas,
		Boolean filterMySubscribedIdeas,
		String searchMySubscribedIdeas,
		Boolean filterMyCompanyIdeas,
		String searchMyCompanyIdeas,
		Boolean filterMyCompanyVotedIdeas,
		String searchMyCompanyVotedIdeas,
		Boolean filterMyCompanyCommentedIdeas,
		String searchMyCompanyCommentedIdeas,
		Boolean filterMyCompanySubscribedIdeas,
		String searchMyCompanySubscribedIdeas) {
		List<String> featureids = new List<String>();
		String topicName = '';
		if (string.isNotBlank(topicNameAndFeatureList) && string.isNotBlank(topicNameAndFeatureList)) {
			Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(topicNameAndFeatureList);

			topicName = (String) m.get('topicName');
			List<Object> lsstr = (List<Object>) m.get('featureids');

			for (Object a : lsstr) { featureids.add(String.valueOf(a));}
		}

		System.debug('--- categories        ---' + categories);
		System.debug('--- zoneId            ---' + zoneId);
		System.debug('--- sortBy            ---' + sortBy);
		System.debug('--- limitVoteToEmailDomain ---' + limitVoteToEmailDomain);
		System.debug('--- filterByTopic     ---' + filterByTopic);
		System.debug('--- topicName         ---' + topicName);
		System.debug('--- filterBySearchTerm ---' + filterBySearchTerm);
		System.debug('--- searchTerm        ---' + searchTerm);
		System.debug('--- filterOnUserOwned ---' + filterOnUserOwned);
		System.debug('--- filterOnUserVoted ---' + filterOnUserVoted);
		System.debug('--- searchMyIdeas     ---' + searchMyIdeas);
		System.debug('--- searchByCategories ---' + searchByCategories);
		System.debug('--- searchByTopics    ---' + searchByTopics);
		System.debug('--- searchByStatus    ---' + searchByStatus);
		System.debug('--- searchByThemes    ---' + searchByThemes);
		System.debug('--- filterByMergeIdea ---' + filterByMergeIdea);
		System.debug('--- filterByMyVotedIdeas ---' + filterByMyVotedIdeas);
		System.debug('--- searchByMyVotedIdeas ---' + searchByMyVotedIdeas);
		System.debug('--- filterMyCommentedIdeas ---' + filterMyCommentedIdeas);
		System.debug('--- searchMyCommentedIdeas ---' + searchMyCommentedIdeas);
		System.debug('--- filterMySubscribedIdeas ---' + filterMySubscribedIdeas);
		System.debug('--- searchMySubscribedIdeas ---' + searchMySubscribedIdeas);
		System.debug('--- filterMyCompanyIdeas ---' + filterMyCompanyIdeas);
		System.debug('--- searchMyCompanyIdeas ---' + searchMyCompanyIdeas);
		System.debug('--- filterMyCompanyVotedIdeas ---' + filterMyCompanyVotedIdeas);
		System.debug('--- searchMyCompanyVotedIdeas ---' + searchMyCompanyVotedIdeas);

		System.debug('--- filterMyCompanyCommentedIdeas ---' + filterMyCompanyCommentedIdeas);
		System.debug('--- searchMyCompanyCommentedIdeas ---' + searchMyCompanyCommentedIdeas);
		System.debug('--- filterMyCompanySubscribedIdeas ---' + filterMyCompanySubscribedIdeas);
		System.debug('--- searchMyCompanySubscribedIdeas ---' + searchMyCompanySubscribedIdeas);
		System.debug('--- featureids ---' + featureids);

		List<String> categoriesList = parseStringList(categories);
		List<String> themesList = parseStringList(searchByThemes);
		List<String> topicsList = parseStringList(searchByTopics);
		System.debug('Topic list: ' + topicsList);

		Set<Id> ideasIds = new Set<Id>();
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : 50;

		Boolean limitVoteToEmailDomainValue = limitVoteToEmailDomain != null ? Boolean.valueOf(limitVoteToEmailDomain) : false;
		Boolean filterByTopicValue = filterByTopic != null ? Boolean.valueOf(filterByTopic) : false;
		Boolean filterBySearchTermValue = filterBySearchTerm != null ? Boolean.valueOf(filterBySearchTerm) : false;
		Boolean filterOnUserOwnedValue = filterOnUserOwned != null ? Boolean.valueOf(filterOnUserOwned) : false;
		Boolean filterOnUserVotedValue = filterOnUserVoted != null ? Boolean.valueOf(filterOnUserVoted) : false;
		//Boolean filterOnMyVotedIdeas = filterByMyVotedIdeas != null ? Boolean.valueOf(filterByMyVotedIdeas) : false;
		Boolean filterOnMyCommentedIdeas = filterMyCommentedIdeas != null ? Boolean.valueOf(filterMyCommentedIdeas) : false;
		Boolean filterOnMySubscribedIdeas = filterMySubscribedIdeas != null ? Boolean.valueOf(filterMySubscribedIdeas) : false;
		Boolean filterOnMyCompanyIdeas = filterMyCompanyIdeas != null ? Boolean.valueOf(filterMyCompanyIdeas) : false;
		Boolean filterOnMyCompanyVotedIdeas = filterMyCompanyVotedIdeas != null ? Boolean.valueOf(filterMyCompanyVotedIdeas) : false;

		Boolean filterOnMyCompanyCommentedIdeas = filterMyCompanyCommentedIdeas != null ? Boolean.valueOf(filterMyCompanyCommentedIdeas) : false;
		Boolean filterOnMyCompanySubscribedIdeas = filterMyCompanySubscribedIdeas != null ? Boolean.valueOf(filterMyCompanySubscribedIdeas) : false;

		if (!String.isEmpty(categories)) {
			categories = String.escapeSingleQuotes(categories);
		}
		if (!String.isEmpty(zoneId)) {
			zoneId = String.escapeSingleQuotes(zoneId);
		}
		if (!String.isEmpty(sortBy)) {
			sortBy = String.escapeSingleQuotes(sortBy);
		}
		if (!String.isEmpty(topicName)) {
			topicName = String.escapeSingleQuotes(topicName);
		}
		if (!String.isEmpty(searchTerm)) {
			searchTerm = String.escapeSingleQuotes(searchTerm);
		}

		String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.Id, Related_Topic_Name__c,';
		QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,';
		QUERY += ' X7S_Ideas_Extension__c, X7S_Ideas_Extension__r.Name, ';

		if (!String.isEmpty(sortBy) && sortBy == 'Recent Comments') {
			QUERY += ' LastComment.CreatedDate, LastComment.CreatedBy.Name, LastComment.CreatedBy.CommunityNickname, LastComment.CreatedBy.Id,LastComment.CommentBody,';
		}

		QUERY += ' (SELECT Type, CreatedById, CreatedBy.CommunityNickname FROM Votes WHERE CreatedById = \'' + UserInfo.getUserId() + '\'';

		if (limitVoteToEmailDomainValue) {
			String userEmail = UserInfo.getUserEmail();
			String domain = '%' + userEmail.split('@')[1];
			QUERY += ' OR CreatedBy.Email LIKE \'' + domain + '\' ORDER BY CreatedDate DESC)';
		}
		else {
			QUERY += ')';
		}

		QUERY += ' FROM Idea';

		if (String.isEmpty(zoneId)) {
			QUERY += ' WHERE CommunityId != null ';
		}
		else {
			QUERY += ' WHERE CommunityId = \'' + zoneId + '\' ';
		}
		// IsMerged
		if (filterByMergeIdea == true) {
			QUERY += ' AND IsMerged != true ';
		}
		//My Ideas
		if (!String.isEmpty(searchMyIdeas) &&
			searchMyIdeas.indexOf('No') == -1) {
			if (searchMyIdeas.indexOf('Ideas') != -1) {
				for (Idea lstIdeas : [SELECT Id,CreatedById FROM Idea WHERE CreatedById = :UserInfo.getUserId() LIMIT 1000]) {

					ideasIds.add(lstIdeas.Id);

				}
			}

			if (searchMyIdeas.indexOf('Voted') != -1) {
				filterOnUserVotedValue = true;
			}
			QUERY += ' And Id IN : ideasIds' ;
		}
		if (featureids.size() > 0) {
			String ideaIdString = '(\'' + String.join(featureids, '\',\'') + '\')';
			QUERY += ' And Id IN ' + ideaIdString ;
		}

		System.debug('My Ideas : ' + QUERY);

		// Idea Themes
		if (themesList.size() > 0) {
			QUERY += ' AND ' + buildInQuery(themesList, 'IdeaTheme.Title');
			//QUERY += ' AND IdeaTheme.title=\'' + searchByThemes + '\' ';
		}

		System.debug('Idea Themes: ' + QUERY);

		// Categories
		if (categoriesList.size() > 0) {
			String categoriesJoined = '(\'' + String.join(categoriesList, '\',\'') + '\')';

			QUERY += ' AND Categories INCLUDES ' + categoriesJoined;
		}

		System.debug('Categories: ' + QUERY);

		// Topics - handle '-' in topic name
		if (filterByTopicValue && !String.isEmpty(topicName)) {
			if (!String.isEmpty(topicName)) {
				if (topicName.indexOf('-') != -1) { QUERY += ' AND Related_Topic_Name__c LIKE \'%' + topicName.replace('-', '%') + '%\'';}
				else { QUERY += ' AND Related_Topic_Name__c = \'' + topicName + '\'';}
			}
		}

		System.debug('filterByTopicValue: ' + QUERY);

		// Search term
		if (String.isNotBlank(searchTerm)) {
			String searchQueryTerm = searchTerm.trim();

			if (String.isNotBlank(searchQueryTerm)) {
				QUERY += ' AND ( Title LIKE \'%' + searchQueryTerm + '%\' )';
				System.debug(QUERY);
			}
		}
		else if (filterBySearchTermValue && String.isEmpty(searchTerm)) {
			QUERY += ' AND Title = \'______\'';
		}

		System.debug('Search Term: ' + QUERY);

		//Ideas Picklist Filters
		if (filterOnUserOwnedValue) {
			QUERY += ' AND CreatedById = \'' + UserInfo.getUserId() + '\'';
		}
		else if (filterOnUserVotedValue) {
			//QUERY += ' AND CreatedById != \'' + UserInfo.getUserId() + '\'';
			QUERY += ' AND Id IN (SELECT ParentId FROM Vote WHERE CreatedById = \'' + UserInfo.getUserId() + '\' AND Parent.Type = \'Idea\')';
		}
		else if (filterOnMyCommentedIdeas) {
			QUERY += ' AND Id IN (SELECT IdeaId FROM IdeaComment WHERE CommunityId = \'' + zoneId + '\' AND CreatedById = \'' + UserInfo.getUserId() + '\')';
		}
		else if (filterOnMySubscribedIdeas) {
			QUERY += ' AND Id IN (SELECT ParentId__c FROM X7S_Ideas_Subscription__c WHERE CreatedById = \'' + UserInfo.getUserId() + '\')';
		}

		System.debug('Voted by Me: ' + QUERY.substring(25, QUERY.length() - 1));


		//Ideas Picklist Account Filters
		List<User> usr = (List<User>) Database.query('SELECT Id, AccountId FROM User WHERE Id = ' + '\'' + String.escapeSingleQuotes(UserInfo.getUserId()) + '\'');
		List<String> listOfUserIds = new List<String>();

		if (!usr.isEmpty() && usr[0].AccountId != null) {
			List<Account> acc = (List<Account>) Database.query('SELECT Id,Name, Account_Vote_Limit__c FROM Account WHERE Id = ' + '\'' + String.escapeSingleQuotes(usr[0].AccountId) + '\'');

			if (!acc.isEmpty()) {
				for (User userr : (List<User>) Database.query('SELECT Id,ContactId,AccountId from User WHERE AccountId = ' + '\'' + String.escapeSingleQuotes(acc[0].Id) + '\'')) {
					listOfUserIds.add(userr.Id);
				}
			}
		}

		if (!listOfUserIds.isEmpty()) {
			if (filterOnMyCompanyIdeas) {
				QUERY += 'AND ' + buildInQuery(listOfUserIds, 'CreatedById');
			}
			else if (filterOnMyCompanyVotedIdeas) {
				QUERY += 'AND Id IN (SELECT ParentId FROM Vote WHERE ' + buildInQuery(listOfUserIds, 'CreatedById') + ' AND Parent.Type = \'Idea\' )';
			}
			else if (filterOnMyCompanyCommentedIdeas) {
				QUERY += ' AND Id IN (SELECT IdeaId FROM IdeaComment WHERE CommunityId = \'' + zoneId + '\' AND ' + buildInQuery(listOfUserIds, 'CreatedById') + ')';
			}
			else if (filterOnMyCompanySubscribedIdeas) {
				QUERY += ' AND Id IN (SELECT ParentId__c FROM X7S_Ideas_Subscription__c WHERE ' + buildInQuery(listOfUserIds, 'CreatedById') + ')';
			}

		}
		System.debug('My Account Filters: ' + QUERY.substring(30, QUERY.length() - 1));


		//change by sachin to make it csv instead of single value
		if (String.isNotBlank(searchByCategories)) {
			searchByCategories = '(\'' + String.join(searchByCategories.split(','), '\',\'') + '\')';
			QUERY += ' AND Categories IN  ' + searchByCategories;
		}

		// Can't do filter and search together
		if (String.isEmpty(topicName) && String.isNotBlank(searchByTopics)) {
			List<String> topicFilterList = new List<String>();

			System.debug('topic filer: ' + topicsList);
			QUERY += ' AND (';

			for (String topicEntry : topicsList) {
				if (topicEntry.indexOf('-') != -1) {
					topicFilterList.add(' Related_Topic_Name__c LIKE \'%' + topicEntry.replace('-', '%') + '%\'');
				}
				else {
					topicFilterList.add(' Related_Topic_Name__c = \'' + topicEntry + '\'');
				}
			}
			QUERY += String.join(topicFilterList, ' OR ');
			QUERY += ') ';
		}

		//change by sachin to make it csv instead of single value
		if (String.isNotBlank(searchByStatus)) {
			searchByStatus = '(\'' + String.join(searchByStatus.split(','), '\',\'') + '\')';
			QUERY += ' AND Status IN ' + searchByStatus ;
		}

		System.debug('Status Filter: ' + QUERY);

		if (String.isNotBlank(sortBy)) {
			if (sortBy == 'Recent Ideas') {
				QUERY += ' ORDER BY CreatedDate DESC';
			}
			else if (sortBy == 'Top All-Time') {
				// R1 sort expression
				// QUERY += ' ORDER BY VoteTotal DESC, VoteScore DESC, Title ASC';
				QUERY += ' ORDER BY VoteTotal DESC, CreatedBy.Name ASC, Title DESC';
			}
			else if (sortBy == 'Recent Comments') {
				QUERY += ' ORDER BY LastComment.CreatedDate DESC, Title ASC'; //LastComment.CreatedDate DESC,
			}
			// Sort By Popular Ideas
			else {
				QUERY += ' ORDER BY VoteScore DESC, Title ASC';
			}
		}

		System.debug('Ideas QUERY: ' + QUERY);
		System.debug('listSizeValue: ' + listSizeValue);
		System.debug('ideasIds: ' + ideasIds);

		return new x7sIdeasListWrapper(QUERY, listSizeValue, ideasIds);
	}


	@AuraEnabled
	public static x7sIdeasListWrapper nextPage(
		Integer listSize,
		Integer pageNumber,
		String categories,
		String zoneId,
		String sortBy,
		Boolean limitVoteToEmailDomain,
		Boolean filterByTopic,
		String topicNameAndFeatureList,
		Boolean filterBySearchTerm,
		String searchTerm,
		Boolean filterOnUserOwned,
		Boolean filterOnUserVoted,
		String searchMyIdeas,
		String searchByCategories,
		String searchByTopics,
		String searchByStatus,
		String searchByThemes,
		Boolean filterByMergeIdea,
		Boolean filterByMyVotedIdeas,
		String searchByMyVotedIdeas,
		Boolean filterMyCommentedIdeas,
		String searchMyCommentedIdeas,
		Boolean filterMySubscribedIdeas,
		String searchMySubscribedIdeas,
		Boolean filterMyCompanyIdeas,
		String searchMyCompanyIdeas,
		Boolean filterMyCompanyVotedIdeas,
		String searchMyCompanyVotedIdeas,
		Boolean filterMyCompanyCommentedIdeas,
		String searchMyCompanyCommentedIdeas,
		Boolean filterMyCompanySubscribedIdeas,
		String searchMyCompanySubscribedIdeas) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		x7sIdeasListWrapper ilw = getIdeas(
			listSize,
			categories,
			zoneId,
			sortBy,
			limitVoteToEmailDomain,
			filterByTopic,
			topicNameAndFeatureList,
			filterBySearchTerm,
			searchTerm,
			filterOnUserOwned,
			filterOnUserVoted,
			searchMyIdeas,
			searchByCategories,
			searchByTopics,
			searchByStatus,
			searchByThemes,
			filterByMergeIdea,
			filterByMyVotedIdeas,
			searchByMyVotedIdeas,
			filterMyCommentedIdeas,
			searchMyCommentedIdeas,
			filterMySubscribedIdeas,
			searchMySubscribedIdeas,
			filterMyCompanyIdeas,
			searchMyCompanyIdeas,
			filterMyCompanyVotedIdeas,
			searchMyCompanyVotedIdeas,
			filterMyCompanyCommentedIdeas,
			searchMyCompanyCommentedIdeas,
			filterMyCompanySubscribedIdeas,
			searchMyCompanySubscribedIdeas
		);

		ilw.pageNumber = pageNumberValue;
		ilw.nextPage();

		System.debug('ilw: ' + ilw);

		return ilw;
	}

	@AuraEnabled
	public static x7sIdeasListWrapper previousPage(
		Integer listSize,
		Integer pageNumber,
		String categories,
		String zoneId,
		String sortBy,
		Boolean limitVoteToEmailDomain,
		Boolean filterByTopic,
		String topicNameAndFeatureList,
		Boolean filterBySearchTerm,
		String searchTerm,
		Boolean filterOnUserOwned,
		Boolean filterOnUserVoted,
		String searchMyIdeas,
		String searchByCategories,
		String searchByTopics,
		String searchByStatus,
		String searchByThemes,
		Boolean filterByMergeIdea,
		Boolean filterByMyVotedIdeas,
		String searchByMyVotedIdeas,
		Boolean filterMyCommentedIdeas,
		String searchMyCommentedIdeas,
		Boolean filterMySubscribedIdeas,
		String searchMySubscribedIdeas,
		Boolean filterMyCompanyIdeas,
		String searchMyCompanyIdeas,
		Boolean filterMyCompanyVotedIdeas,
		String searchMyCompanyVotedIdeas,
		Boolean filterMyCompanyCommentedIdeas,
		String searchMyCompanyCommentedIdeas,
		Boolean filterMyCompanySubscribedIdeas,
		String searchMyCompanySubscribedIdeas) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		x7sIdeasListWrapper ilw = getIdeas(
			listSize,
			categories,
			zoneId,
			sortBy,
			limitVoteToEmailDomain,
			filterByTopic,
			topicNameAndFeatureList,
			filterBySearchTerm,
			searchTerm,
			filterOnUserOwned,
			filterOnUserVoted,
			searchMyIdeas,
			searchByCategories,
			searchByTopics,
			searchByStatus,
			searchByThemes,
			filterByMergeIdea,
			filterByMyVotedIdeas,
			searchByMyVotedIdeas,
			filterMyCommentedIdeas,
			searchMyCommentedIdeas,
			filterMySubscribedIdeas,
			searchMySubscribedIdeas,
			filterMyCompanyIdeas,
			searchMyCompanyIdeas,
			filterMyCompanyVotedIdeas,
			searchMyCompanyVotedIdeas,
			filterMyCompanyCommentedIdeas,
			searchMyCompanyCommentedIdeas,
			filterMyCompanySubscribedIdeas,
			searchMyCompanySubscribedIdeas
		);

		ilw.pageNumber = pageNumberValue;
		ilw.previousPage();

		return ilw;
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getPage(Integer listSize, Integer pageNumber, String categories, String zoneId, String sortBy, Boolean limitVoteToEmailDomain, Boolean filterByTopic, String topicNameAndFeatureList, Boolean filterBySearchTerm, String searchTerm, Boolean filterOnUserOwned, Boolean filterOnUserVoted, String searchMyIdeas, String searchByCategories, String searchByTopics, String searchByStatus, String searchByThemes, Boolean filterByMergeIdea, Boolean filterByMyVotedIdeas, String searchByMyVotedIdeas, Boolean filterMyCommentedIdeas, String searchMyCommentedIdeas, Boolean filterMySubscribedIdeas, String searchMySubscribedIdeas, Boolean filterMyCompanyIdeas, String searchMyCompanyIdeas, Boolean filterMyCompanyVotedIdeas, String searchMyCompanyVotedIdeas, Boolean filterMyCompanyCommentedIdeas, String searchMyCompanyCommentedIdeas, Boolean filterMyCompanySubscribedIdeas, String searchMyCompanySubscribedIdeas) {
		System.debug('>>> In Log 2');
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;
		Boolean limitVoteToEmailDomainValue = limitVoteToEmailDomain != null ? Boolean.valueOf(limitVoteToEmailDomain) : false;
		Boolean filterByTopicValue = filterByTopic != null ? Boolean.valueOf(filterByTopic) : false;
		Boolean filterBySearchTermValue = filterByTopic != null ? Boolean.valueOf(filterBySearchTerm) : false;
		Boolean filterOnUserOwnedValue = filterOnUserOwned != null ? Boolean.valueOf(filterOnUserOwned) : false;
		Boolean filterOnUserVotedValue = filterOnUserVoted != null ? Boolean.valueOf(filterOnUserVoted) : false;

		x7sIdeasListWrapper ilw = getIdeas(listSizeValue, categories, zoneId, sortBy, limitVoteToEmailDomainValue, filterByTopicValue, topicNameAndFeatureList, filterBySearchTermValue, searchTerm, filterOnUserOwnedValue, filterOnUserVotedValue, searchMyIdeas, searchByCategories, searchByTopics, searchByStatus, searchByThemes, filterByMergeIdea, filterByMyVotedIdeas, searchByMyVotedIdeas, filterMyCommentedIdeas, searchMyCommentedIdeas, filterMySubscribedIdeas, searchMySubscribedIdeas, filterMyCompanyIdeas, searchMyCompanyIdeas, filterMyCompanyVotedIdeas, searchMyCompanyVotedIdeas, filterMyCompanyCommentedIdeas, searchMyCompanyCommentedIdeas, filterMyCompanySubscribedIdeas, searchMyCompanySubscribedIdeas);
		System.debug('records-001' + ilw.ideaList);
		ilw.pageNumber = pageNumberValue;
		ilw.getPage();
		System.debug('records-002' + ilw.ideaList);
		return ilw;
	}

	@AuraEnabled
	public static x7sIdeasListWrapper submitVote(Id ideaId, String voteType) {
		Set<Id> ideasIds = new Set<Id>{ideaId};

		//ideasIds.add(ideaId);

		String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.Id, Related_Topic_Name__c,';
		QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,';
		QUERY += ' (SELECT Type, CreatedById, CreatedBy.CommunityNickname FROM Votes WHERE CreatedById = \'' + UserInfo.getUserId() + '\'' + ')';
		QUERY += ' FROM Idea';
		QUERY += ' WHERE Id IN :ideasIds ';

		try {
			if (Vote.SObjectType.getDescribe().isCreateable()){
				Vote v = new Vote();
				v.ParentId = ideaId;
				v.Type = voteType;

				insert v;
			}
			x7sIdeasListWrapper wrapper = new x7sIdeasListWrapper(QUERY, 1, ideasIds);
			return wrapper;

		}
		catch (Exception e) {
			System.debug('submitVote failed: ' + e.getMessage());
		}

		return null;
	}

	//	UTILITY FUNCTIONS
	// ----------------------------------------------------------

	@TestVisible
	private static List<String> parseStringList(String categories) {
		List<String> categoriesList = new List<String>();
		if (categories != null && !String.isEmpty(categories)) {
			categoriesList = categories.split(',');
		}
		return categoriesList;
	}

	@TestVisible
	private static String buildInQuery(List<String> valueList, String fieldName) {
		String inQuery = '';
		List<String> fieldValues = new List<String>();

		for (String entry : valueList) {
			fieldValues.add('\'' + entry.trim() + '\'');
		}

		if (fieldValues.size() > 0) {
			inQuery = fieldName + ' IN (';
			inQuery += String.join(fieldValues, ',');
			inQuery += ') ';
		}

		return inQuery;
	}
}