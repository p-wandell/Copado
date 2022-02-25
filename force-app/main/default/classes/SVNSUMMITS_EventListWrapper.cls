/* Copyright ©2016-2018 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_EventListWrapper {

	@AuraEnabled
	global List<Event__c> objEventList { get; set; }

	@AuraEnabled
	global Boolean isEditable { get; set; }

	@AuraEnabled
	global Map <String, String> topicNameToId { get; set; }

	@AuraEnabled
	global Map<String, String> groupIdToName { get; set; }

	@AuraEnabled
	global List<ConnectApi.Topic> topicLst { get; set; }

	@AuraEnabled
	global Integer intDate { get; set; }

	@AuraEnabled
	global String strMonth { get; set; }

	@AuraEnabled
	global String strDay { get; set; }

	@AuraEnabled
	global String strMinute { get; set; }

	@AuraEnabled
	global Integer daysOfMultiDaysEvent { get; set; }

	@AuraEnabled
	public List<TopicAssignment> topicsOfRecord { get; set; }

	@AuraEnabled
	public String strStartDate { get; set; }

	@AuraEnabled
	public String strEndDate { get; set; }

    /* PAGINATION Variables */
	@AuraEnabled
	global Integer totalResults { get; set; }

	@AuraEnabled
	public Integer totalPages { get; set; }

	@AuraEnabled
	public String dtNow { get; set; }

	@AuraEnabled
	global Integer pageNumber { get; set; }

	@AuraEnabled
	global Boolean hasPreviousSet { get; set; }

	@AuraEnabled
	global Boolean hasNextSet { get; set; }

	@AuraEnabled
	global Integer listSizeValue { get; private set; }

	@AuraEnabled
	global Map<Id, List<TopicAssignment>> eventsToTopicsMap { get; set; }

	@AuraEnabled
	global String strTimeZone { get; set; }

	@AuraEnabled
	global String errorMsg { get; set; }

	@AuraEnabled
	global String field { get; set; }

	private ApexPages.StandardSetController setController { get; set; }

	global static Id communityId = System.Network.getNetworkId();

	public SVNSUMMITS_EventListWrapper() {
		this.field = '';
		this.errorMsg = '';
		this.intDate = 0;
		this.dtNow = '';
		this.strTimeZone = '';
		this.strDay = '';
		this.strEndDate = '';
		this.strStartDate = '';
		this.strMinute = '';
		this.strMonth = '';
		this.isEditable = false;
		this.listSizeValue = 0;
		this.daysOfMultiDaysEvent = 0;
		this.hasNextSet = false;
		this.hasPreviousSet = false;
		this.pageNumber = 0;

		this.topicsOfRecord = new List<TopicAssignment>();
		this.eventsToTopicsMap = new Map<Id, List<TopicAssignment>>();
		this.topicLst = new List<ConnectApi.Topic>();
	}

	global SVNSUMMITS_EventListWrapper(String field, String errorMsg) {
		this.field = field;
		this.errorMsg = errorMsg;
	}

	global SVNSUMMITS_EventListWrapper(String QUERY, Integer listSize, Datetime fromDt, Datetime toDt, Set<String> eventIds, String listViewMode, Boolean isFeatured, Map<String, String> featurdEventIds)
	{
		this.executeQuery(QUERY, listSize, fromDt, toDt, eventIds, listViewMode, isFeatured, featurdEventIds, null);
	}

	global SVNSUMMITS_EventListWrapper(String QUERY, Integer listSize, Datetime fromDt, Datetime toDt, Set<String> eventIds, String listViewMode, Boolean isFeatured, Map<String, String> featurdEventIds, Set<String> groupEventIds)
	{
		this.executeQuery(QUERY, listSize, fromDt, toDt, eventIds, listViewMode, isFeatured, featurdEventIds, groupEventIds);
	}

	public void executeQuery(String QUERY, Integer listSize, Datetime fromDt, Datetime toDt, Set<String> eventIds, String listViewMode, Boolean isFeatured, Map<String, String> featurdEventIds, Set<String> groupEventIds)
	{
		//Initialise EventList
		strTimeZone = String.valueOf(UserInfo.getTimeZone());
		this.objEventList = new List<Event__c>();
		this.topicNameToId = new Map<String, String>();

		System.debug('Query:');
		System.debug(QUERY);

		this.setController = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY));

		if (listViewMode == 'CALENDAR') {
			this.listSizeValue = this.setController.getResultSize();
		} else {
			this.listSizeValue = listSize;
		}

		this.setController.setPageSize(listSizeValue);

		System.debug('call to update controller attributes');
		updateControllerAttributes(isFeatured, featurdEventIds);
	}

    /*
         Method Name : nextPage
         Description : Method for fetching values of next page
    */
	global void nextPage() {
		this.setController.setPageNumber(this.pageNumber + 1 > 0 ? this.pageNumber + 1 : 1);
		updateControllerAttributes(false, null);
	}

    /*
         Method Name : previousPage
         Description : Method for fetching values of previous page
    */
	global void previousPage() {
		this.setController.setPageNumber(this.pageNumber - 1 > 0 ? this.pageNumber - 1 : 1);
		updateControllerAttributes(false, null);
	}

    /*
         Method Name : updateControllerAttributes
         Description : Method for updating values of controlle attributes
    */
	private void updateControllerAttributes(Boolean isFeatured, Map<String, String> featurdEventIds) {
		if (isFeatured == true) {
			List<Event__c> templist = this.setController.getRecords();

			Map<Id, Event__c> tempEventsMap = new Map<Id, Event__c>();

			for (Event__c event : templist) { tempEventsMap.put(event.Id, event);}

			for (String str : featurdEventIds.keySet()) {
				if (tempEventsMap.containsKey(str)) { this.objEventList.add(tempEventsMap.get(str));}
			}
		} else {
			//for all other objEventList news list get records for set controller directly
			this.objEventList = this.setController.getRecords();
			System.debug('list = ' + this.objEventList.size());
		}

        /*if Record is updated with All day event  then it takes value for today's date else will take today's date with time*/
		if (this.objEventList.size() > 0) {
			if (this.objEventList[0].All_Day_Event__c) { this.dtNow = String.valueOf(Date.today());
			} else { this.dtNow = String.valueOf(Datetime.now()); }
		}

		this.totalResults = this.setController.getResultSize();
		this.totalPages = Math.mod(this.setController.getResultSize(),
				this.setController.getPageSize()) == 0 ?
					this.setController.getResultSize() / this.setController.getPageSize() :
					this.setController.getResultSize() / this.setController.getPageSize() + 1;
		this.pageNumber = this.totalPages > 0 ? this.setController.getPageNumber() : 0;
		this.hasPreviousSet = this.setController.getHasPrevious();
		this.hasNextSet = this.setController.getHasNext();

		Set<String> eventsObjIds = new Set<String>();
		for (SObject events : this.setController.getRecords()) {
			eventsObjIds.add(events.Id);
		}

		eventsToTopicsMap = new Map<Id, List<TopicAssignment>>();
		List<TopicAssignment> topics = new List<TopicAssignment>();

		for (TopicAssignment t : [SELECT Id,EntityId,Topic.Id,Topic.Name FROM TopicAssignment WHERE EntityId IN :eventsObjIds AND NetworkId = :communityId]) {

			this.topicNameToId.put(t.Topic.Name, t.Topic.Id);
			topics = new List<TopicAssignment>();
			if (eventsToTopicsMap.containsKey(t.EntityId)) { topics.addAll(eventsToTopicsMap.get(t.EntityId));}

			topics.add(t);

			if (eventsObjIds.size() > 1) {
				if (topics.size() < 4) {
					eventsToTopicsMap.put(t.EntityId, topics);
				}
			} else {
				eventsToTopicsMap.put(t.EntityId, topics);
			}
		}

		this.groupIdToName = SVNSUMMITS_EventListController.getAllGroups();
	}
}