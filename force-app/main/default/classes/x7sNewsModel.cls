/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sNewsModel {
    
    @AuraEnabled
	public String id,author,name,details,groupId,
				  language,networkId;

	@AuraEnabled
    public Boolean audienceAssigned,showAuthor,privateGroup;
	
	@AuraEnabled
    public Datetime publishDate,archiveDate;

    @AuraEnabled
    public List<String> communityIds;
    
    @AuraEnabled
	public List<String> translations;

	public x7sNewsModel()
	{
		id = null;
		author = null;
		name = '';
		details = '';
		groupId = '';
		language = '';
		networkId = '';
		audienceAssigned = false;
		showAuthor = false;
		privateGroup = false;
		publishDate = null;
		archiveDate = null;
		communityIds = null;
		translations = null;
	}
}