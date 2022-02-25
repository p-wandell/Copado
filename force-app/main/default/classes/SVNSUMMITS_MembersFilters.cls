/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 10/17/17.
 */

public with sharing class SVNSUMMITS_MembersFilters
{
	private final static String FIELD_SEPARATOR = '\\.';
	private final static String MEMBER_RECORD   = 'Member';
	private final static String FIELD_NAME      = 'Name';
	private final static String FILTER_RECORD   = 'MembersFilterEntry__c';
	private final static String FILTER_PARENT   = 'Filter__r.Name';

	// Filter set
	public List<Members_Filter__mdt> filters { get; set; }

	// Filter settings
	public Decimal PickList_Limit   { get; set; }
	public Boolean SendNotification { get; set; }

	public SVNSUMMITS_MembersFilters()
	{
		Members_Filter_Settings__mdt settings =
		[
			SELECT Filter_List_Limit__c, Send_Email_Notification__c
			FROM Members_Filter_Settings__mdt
			WHERE DeveloperName = 'Default'
		];

		PickList_Limit = settings.Filter_List_Limit__c;
		SendNotification = settings.Send_Email_Notification__c;

		Map<Id, Members_Filter__mdt> allFilters = new Map<Id, Members_Filter__mdt>([
			SELECT Id, DeveloperName, Field_Name__c
			FROM Members_Filter__mdt
		]);

		filters = allFilters.values();
	}

	public Members_Filter__mdt getFilterByName(String name)
	{
		for (Members_Filter__mdt filter : filters)
		{
			if (filter.DeveloperName == name)
			{
				return filter;
			}
		}

		return null;
	}

	public Members_Filter__mdt getFilterByFieldName(String fieldName)
	{
//		System.debug('fieldName : ' + fieldName);

		String fieldString = fieldName.startsWith(MEMBER_RECORD)
			? fieldName
			: MEMBER_RECORD + '.' + fieldName;

		for (Members_Filter__mdt filter : filters)
		{
			if (filter.Field_Name__c == fieldString)
			{
				return filter;
			}
		}

		return null;
	}

	public MembersFilter__c clearFilter(String filterName)
	{
		List<MembersFilter__c> filterItems = [SELECT Id, Name FROM MembersFilter__c WHERE Name = :filterName];

		if (filterItems.size() > 0) { delete filterItems;}

		MembersFilter__c newFilter = new MembersFilter__c(Name = filterName);
		insert newFilter;

		filterItems = [SELECT Id, Name FROM MembersFilter__c WHERE Name = :filterName];
		return filterItems[0];
	}

	public List<String> getFieldRecords(Members_Filter__mdt filter)
	{
		List<String> records   = new List<String>();
		List<String>fieldParts = filter.Field_Name__c.split(FIELD_SEPARATOR);

		for (Integer count = 0; count < fieldParts.size() - 1; count++) {
			records.add(fieldParts[count]);
		}

		return records;
	}

	public String getFieldName(Members_Filter__mdt filter)
	{
		List<String>fieldParts = filter.Field_Name__c.split(FIELD_SEPARATOR);
		String fieldName       = fieldParts[fieldParts.size()-1];

		return fieldName;
	}

	public List<String> getFilterValues(String fieldName, String searchString)
	{
		Members_Filter__mdt filter = getFilterByFieldName(fieldName);

		return getFilterValues(filter, searchString);
	}

	public List<String> getFilterValues(Members_Filter__mdt filter, String searchString)
	{
		List<String> values      = new List<String>();
		Integer      recordLimit = (Integer)this.PickList_Limit;

		String query = 'SELECT ' + FIELD_NAME;
		query += ' FROM '  + FILTER_RECORD;
		query += ' WHERE ' + FILTER_PARENT;
		query += ' = \'' + filter.DeveloperName + '\'';

		if (String.isNotBlank(searchString)) {
			query += ' AND  Name LIKE \'%' + searchString + '%\'';
		}

		query += ' ORDER BY ' + FIELD_NAME;
		query += ' LIMIT ' + recordLimit;

		System.debug('getFilterValues from Filter object qry: ' + query);

		List<MembersFilterEntry__c> results = Database.query(query);
		for (MembersFilterEntry__c entry : results) { values.add(entry.Name);}

		System.debug('    found : ' + values.size());
		return values;

	}

	public List<MembersFilterEntry__c> getFilterEntries(Members_Filter__mdt filter)
	{
		List<MembersFilterEntry__c> entries = new List<MembersFilterEntry__c>();
		Integer recordLimit = (Integer)this.PickList_Limit;

		String query = 'SELECT ' + FIELD_NAME;
		query += ' FROM '  + FILTER_RECORD;
		query += ' WHERE ' + FILTER_PARENT;
		query += ' = \'' + filter.DeveloperName + '\'';

		query += ' ORDER BY ' + FIELD_NAME;
		query += ' LIMIT ' + recordLimit;

		System.debug('getFilterEntries from Filter object qry: ' + query);

		entries = Database.query(query);

		return entries;
	}

	public void notifyBatchCompletion(Database.BatchableContext bc, MembersFilter__c filter, Integer count)
	{
		if (!SendNotification) { return; }

		AsyncApexJob job = [
			SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
			FROM AsyncApexJob
			WHERE Id = :bc.getJobId()];

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

		String[] toAddresses = new String[] {job.CreatedBy.Email};
		email.setToAddresses(toAddresses);


		List<String> params = new String[] {
			filter.Name,
			String.valueOf(job.TotalJobItems),
			String.valueOf(job.JobItemsProcessed),
			String.valueOf(job.NumberOfErrors),
			String.valueOf(count)};

		email.setSubject(String.format(System.Label.ss_mbr_batch_filter_subject, params) + job.Status);
		email.setPlainTextBody(String.format(System.Label.ss_mbr_batch_filter_body, params));

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
	}
}