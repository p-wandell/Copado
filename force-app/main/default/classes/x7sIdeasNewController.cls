/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasNewController {
	private static final Integer TOPIC_LOAD_LIMIT = 2000;
	private static final Decimal MAX_UPLOAD_FILE_SIZE = 4248;
	private static final Integer MAX_USERS_LOAD_LIMIT = 7;

	@AuraEnabled (Cacheable=true)
	public static x7sIdeasCommon getCommonSettings(String zoneName) {
		x7sIdeasCommon settings = new x7sIdeasCommon('', false);

		settings.sitePath = getSitePrefix();
		settings.zoneId = getZoneId(zoneName);
		settings.isAuthenticated = isAuthenticated();
		settings.nicknameEnabled = x7sIdeasUtility.isNicknameDisplayEnabled();

		return settings;
	}

	@AuraEnabled (Cacheable=true)
	public static x7sIdeasNewModel getIdeasNewModel(String zoneName, String fieldSetName, Boolean useTopics, Boolean useCategories, Boolean useStatus) {
		System.debug('Get New Model for ' + zoneName);
		x7sIdeasNewModel model = new x7sIdeasNewModel();

		model.settings = getCommonSettings(zoneName);
		model.themes = getThemeList(zoneName);
		model.topics = useTopics ? getTopicNamesList() : null;
		model.categories = useCategories ? x7sIdeasUtility.getIdeaCategoryValues() : null;
		model.statusus = useStatus ? x7sIdeasUtility.getIdeaStatusValues() : null;
		model.defaultStatus = getDefaultStatus();

		getMaxFileSize(model);

		if (String.isNotBlank(fieldSetName)) {
			x7sIdeasCommon settings = new x7sIdeasCommon('', false);
			model.settings.customFields = settings.getCustomFields(fieldSetName);
		}

		System.debug('getIdeasNewModel: ' + model);

		return model;
	}

	@TestVisible
	private static void getMaxFileSize(x7sIdeasNewModel model) {
		Decimal maxFileSizeKb = MAX_UPLOAD_FILE_SIZE;
		String allowedExtensions = '.pdf, .jpeg, .png';
		String networkId = Network.getNetworkId();
		List<Network> networkList;
		Network curNetwork;

		if (Test.isRunningTest()) {
			networkId = [SELECT Id FROM Network LIMIT 1][0].Id;
		}

		networkList = [SELECT Id, MaxFileSizeKb, AllowedExtensions FROM Network WHERE Id = :networkId WITH SECURITY_ENFORCED];

		if (networkList != null && networkList.size() > 0) {
			curNetwork = networkList[0];

			if (curNetwork.MaxFileSizeKb != null && curNetwork.MaxFileSizeKb != 0 && curNetwork.MaxFileSizeKb < MAX_UPLOAD_FILE_SIZE) { maxFileSizeKb = curNetwork.MaxFileSizeKb;}

			if (curNetwork.AllowedExtensions != null) { allowedExtensions = curNetwork.AllowedExtensions;}
		}

		model.allowedExtensions = allowedExtensions;
		model.maxFileSizeKb = maxFileSizeKb;
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return !Auth.CommunitiesUtil.isGuestUser();
	}

	@AuraEnabled (Cacheable=true)
	public static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}


	@AuraEnabled (Cacheable=true)
	public static String getZoneId(String nameValue) {
		String zoneId = '';

		if (String.isNotEmpty(nameValue)) {
			List<Community> currCommunity = [SELECT Id FROM Community WHERE Name = :nameValue WITH SECURITY_ENFORCED];

			if (currCommunity != null && currCommunity.size() > 0) {
				zoneId = currCommunity[0].Id;
			}
		}

		return zoneId;
	}

	public class RelatedFiles {
		@AuraEnabled public List<RelatedFile> files;
	}

	public class RelatedFile {
		@AuraEnabled public String name;
		@AuraEnabled public String fileName;
		@AuraEnabled public String dataString;
	}

	/*
		Name : createIdeaNew
		Description: This method is used to get the Id of idea records which is going to insert and
		if any error occurs it passes the error message.
		Visibility: AllUsers,
	*/
	@AuraEnabled
	public static String createIdeaNew(List<Idea> currIdeaList, String imageString, String relatedFileString, String visibility, String customFieldSetName) {
		System.debug('Create New Idea:');
		System.debug('    relatedJSON: ' + relatedFileString);
		List<RelatedFile> relatedFiles = new List<RelatedFile>();

		if (String.isNotBlank(relatedFileString)) {
			RelatedFiles relatedFileItems = (RelatedFiles) JSON.deserialize(relatedFileString, RelatedFiles.class);
			System.debug('    related files: ' + relatedFileItems);

			if (relatedFileItems != null) {
				System.debug('Related file count: ' + relatedFileItems.files.size());
				for (RelatedFile entry : relatedFileItems.files) {
					System.debug('    adding related file: ' + entry.name + ', ' + entry.fileName);
					relatedFiles.add(entry);
				}
			}
		}

		String ideaId = null;
		String ideaExtId = null;

		try {
			if (currIdeaList != null && currIdeaList.size() > 0) {
				System.debug(currIdeaList[0].Title);
				System.debug(currIdeaList[0].AttachmentName);
				System.debug(currIdeaList[0].AttachmentContentType);

				if (String.isNotBlank(imageString)) { currIdeaList[0].AttachmentBody = EncodingUtil.base64Decode(imageString);}

				upsert currIdeaList;

				// get the idea details
				Idea createdIdea = currIdeaList[0];
				ideaId = String.valueOf(createdIdea.Id);
				System.debug('New created idea: ' + createdIdea);

				x7sIdeasListWrapper wrapper = x7sIdeasViewController.getIdeaRecord(
					createdIdea.CommunityId, createdIdea.Id, customFieldSetName);
				Idea newIdea = wrapper.ideaList[0];
				System.debug('New retrieved Idea: ' + newIdea);
				ideaExtId = String.valueOf(newIdea.X7S_Ideas_Extension__c);
				System.debug('ideaExtId: ' + ideaExtId);

				// add related files
				if (ideaExtId != null
					&& relatedFiles != null
					&& relatedFiles.size() > 0) {
					
					if(ContentVersion.SObjectType.getDescribe().isCreateable() &&
						Schema.SObjectType.ContentVersion.fields.Title.isCreateable() &&
						Schema.SObjectType.ContentVersion.fields.PathOnClient.isCreateable() &&
						Schema.SObjectType.ContentVersion.fields.ContentLocation.isCreateable() &&
						Schema.SObjectType.ContentVersion.fields.VersionData.isCreateable()) {
						List<ContentVersion> contentVersions = new List<ContentVersion>();

						System.debug('    --- Create content versions');
						for (RelatedFile related : relatedFiles) {
							System.debug('   related file: ' + related);

							ContentVersion content = new ContentVersion();

							content.Title = related.name;
							content.PathOnClient = related.fileName;
							content.ContentLocation = 'S';
							content.VersionData = EncodingUtil.base64Decode(related.dataString);

							contentVersions.add(content);
						}
						insert contentVersions;

						List<String> contentIds = new List<String>();
						for (ContentVersion content : contentVersions) {
							contentIds.add(content.Id);
						}
						System.debug('    --- Create related links');
						// link to the Idea
						if(ContentDocumentLink.SObjectType.getDescribe().isCreateable() &&
							Schema.SObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable() &&
							Schema.SObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable() &&
							Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable() &&
							Schema.SObjectType.ContentDocumentLink.fields.Visibility.isCreateable()) {

							List<ContentDocumentLink> relatedLinks = new List<ContentDocumentLink> ();
							List<ContentVersion> insertedContent = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN :contentIds];

							for (ContentVersion currentVersion : insertedContent) {
								ContentDocumentLink relatedLink = new ContentDocumentLink();

								relatedLink.ContentDocumentId = currentVersion.ContentDocumentId;
								relatedLink.LinkedEntityId = ideaExtId;
								relatedLink.ShareType = 'I';
								relatedLink.Visibility = visibility;

								relatedLinks.add(relatedLink);
							}
							insert relatedLinks;
						}
					}
				}
			}

			return ideaId;

		}
		catch (Exception e) { System.debug('createNewIdea Apex exception: ' + e);return e.getMessage();}
	}

	@AuraEnabled
	public static x7sIdeasListWrapper getIdeaRecord(String zoneId, String recordId, String customFieldSetName) {
		return x7sIdeasViewController.getIdeaRecord(zoneId, recordId, customFieldSetName);
	}

	@AuraEnabled
	public static List<String> getobjValues(String objName, String fieldName) {
		return null;
	}

	@AuraEnabled
	public static Boolean deleteIdea(String ideaId) {
		Boolean result = true;

		if (!String.isEmpty(ideaId) && Schema.sObjectType.Idea.isDeletable()) {
			try {
				Idea currIdea = new Idea(Id = ideaId);
				delete currIdea;
			}
			catch (Exception e) {
				result = false;
			}
		}

		return result;
	}

	@AuraEnabled
	public static List<Idea> checkDuplicateIdeas(String title, String zoneId, Integer simIdeasLimit, String statusList) {
		Integer simIdeasLimitValue = Integer.valueOf(simIdeasLimit);

		List<Idea> ideasList = new List<Idea>();
		List<Idea> ideasListSOSL = new List<Idea>();

		if (!String.isEmpty(title)) {
			List<String> keywordList = title.replace('%', '').replace('*', '').split(' ');
			Set<String> keywordSet = new Set<String>();
			Set<String> keywordSetSOSL = new Set<String>();

			for (String s : keywordList) {
				if (s.trim().length() > 1) {
					keywordSet.add(s.trim());
					keywordSetSOSL.add('*' + s.trim() + '*');
				}
			}

			if (keywordSet.size() > 0) {
				keywordList = new List<String>(keywordSet);
				String keywordStringSOSL = '("' + String.join(new List<String>(keywordSetSOSL), '") OR ("') + '")';
				System.debug('checkDuplicateIdeas: key word SOSL: ' + keywordStringSOSL);

				if (String.isBlank(statusList)) {
					ideasListSOSL = (List<Idea>) [FIND :keywordStringSOSL RETURNING Idea(Id, Title, VoteTotal WHERE CommunityId = :zoneId) LIMIT :simIdeasLimitValue][0];
				}
				else {
					List<String> statusEntries = statusList.split(',');
					ideasListSOSL = (List<Idea>) [FIND :keywordStringSOSL RETURNING Idea(Id, Title, VoteTotal WHERE CommunityId = :zoneId AND (Status IN :statusEntries)) LIMIT :simIdeasLimitValue][0];
				}
				ideasList = [SELECT Id, Title, VoteTotal FROM Idea WHERE CommunityId = :zoneId AND Title IN :keywordList AND (NOT Id IN :ideasListSOSL) ORDER BY VoteScore DESC LIMIT :simIdeasLimitValue];
				ideasList.addAll(ideasListSOSL);

				if (ideasList.size() > simIdeasLimitValue) {
					List<Idea> tmpIdeasList = new List<Idea>();
					for (Idea currIdea : ideasList) {
						if (tmpIdeasList.size() < simIdeasLimitValue) {
							tmpIdeasList.add(currIdea);
						}
						else {
							break;
						}
					}

					ideasList = tmpIdeasList;
				}

			}
		}

		return ideasList;
	}

	@AuraEnabled
	public static List<IdeaTheme> getThemeList(String ideaZoneName) {
		try {
			Community c = [SELECT Id FROM Community WHERE Name = :ideaZoneName WITH SECURITY_ENFORCED LIMIT 1];
			return c.Id != null ? [SELECT Id, Title FROM IdeaTheme WHERE CommunityId = :c.Id ORDER BY Title] : null;
		}
		catch (QueryException e) {
			System.debug('cannot load themes for ' + ideaZoneName);
			return null;
		}
	}

	@AuraEnabled
	public static List<Topic> getTopicNamesList() {
		Id networkId = System.Network.getNetworkId();

		List<Topic> topicList = new List<Topic>();

		if (networkId != null) {
			topicList = [SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout FROM Topic WHERE NetworkId = :networkId ORDER BY Name LIMIT :TOPIC_LOAD_LIMIT];
		}
		else {
			topicList = [SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout FROM Topic WHERE NetworkId = NULL ORDER BY Name LIMIT :TOPIC_LOAD_LIMIT];
		}

		return topicList;
	}

	@AuraEnabled
	public static List<String> getStatusValues() {
		return x7sIdeasUtility.getIdeaStatusValues();
	}

	@AuraEnabled
	public static List<String> getCategoryValues() {
		return x7sIdeasUtility.getIdeaCategoryValues();
	}

	@AuraEnabled
	public static String getDefaultStatus() {
		String defaultValue = '';

		try {
			Schema.DescribeFieldResult fieldResult = Idea.Status.getDescribe();
			List <Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

			if (picklistValues != null) {
				for (Schema.PicklistEntry picklistValue : picklistValues) {
					if (picklistValue.isDefaultValue()) {
						defaultValue = picklistValue.getValue();
					}
				}
			}

			if (String.isBlank(defaultValue) && picklistValues != null && picklistValues.size() > 0) {
				defaultValue = picklistValues[0].getValue();
			}
		}
		catch (Exception e) {
			System.debug('getDefaultStatus exception: ' + e.getMessage());
		}

		return defaultValue;
	}

	@AuraEnabled
	public static List<User> fetchUsers(String inputKeyword) {
		Integer userLimit = MAX_USERS_LOAD_LIMIT;
		String userInput = '%' + String.escapeSingleQuotes(inputKeyword) + '%';

		List<User> returnList = [
			SELECT Id, Username, LastName, FirstName, Name, CompanyName, Title
			FROM User
			WHERE Name LIKE :userInput
			WITH SECURITY_ENFORCED
			LIMIT :userLimit
		];
		Security.stripInaccessible(AccessType.READABLE, returnList);

		return returnList;
	}

	@AuraEnabled
	public static User getRequestedByRecord(String userId) {
		try {
			return [SELECT Id, Name, FirstName, LastName FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
		} catch (Exception ex) { System.debug('Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return null;}
	}

	@AuraEnabled
	public static QuestionDetail getQuestionDetail(String recordId) {
		QuestionDetail questionDetail = new QuestionDetail();
		try {
			List<FeedItem> listOfFeedItems = [SELECT Id,ParentId,Body,Title,CreatedById FROM FeedItem WHERE Id = :recordId WITH SECURITY_ENFORCED];

			if (!listOfFeedItems.isEmpty()) {
				questionDetail.Body = String.isEmpty(listOfFeedItems[0].Body) ? '' : listOfFeedItems[0].Body;
				questionDetail.Title = String.isEmpty(listOfFeedItems[0].Title) ? '' : listOfFeedItems[0].Title;

				if (!String.isEmpty(listOfFeedItems[0].ParentId)) {
					List<User> feedUsers = [SELECT Id,Name,FirstName, LastName FROM User WHERE Id = :listOfFeedItems[0].CreatedById WITH SECURITY_ENFORCED];

					if (!feedUsers.isEmpty()) {
						questionDetail.requestedBy = feedUsers[0];
					}
				}
			}
			return questionDetail;

		} catch (Exception ex) { System.debug('getQuestionDetail() - Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());return null;}
	}

	public class QuestionDetail {
		@AuraEnabled public String Body;
		@AuraEnabled public String Title;
		@AuraEnabled public User requestedBy;
	}
}