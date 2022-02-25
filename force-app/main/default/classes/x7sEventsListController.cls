/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
 * x7sEventsListController
 * Apex class for lightning components for Events records displaying list view, featured,
 * and creating X7S_Event__c and X7S_Event_RSVP__c records
 **/
@SuppressWarnings('PMD.ExcessiveClassLength')
public with sharing class x7sEventsListController {
    private static final Integer DEFAULT_LIST_SIZE = 50;
    private static final Integer DEFAULT_PAGE_VALUE = 1;
    private static final String SEARCH_SEPARATOR = ';';
    private static final String SEARCH_FIELD = ':';
    private static final String FIELD_SEPARATOR = ',';
    private static final String EVENT_OBJECT_NAME = 'X7S_Event__c';
    private static final Integer MAX_TOPICS = 1000;
    private static final String EVENT_TRANSLATION_OBJECT_NAME = 'X7S_Event_Translation__c';
    private static final String DHILD_RELATIONSHIP_OBJECT_NAME = 'X7S_Event_Translation__r';
    public static final String FOR_GUEST_TYPE = 'Guest';

    // Current community ID
    private static Id communityId {
        get {
            return System.Network.getNetworkId();
        }
    }

    // Set of fields used for checking TopicAssignment fields
    private static String [] TopicAssigmtAccessFields = new String []{
            'EntityId',
            'TopicId'
    };

    // Set of fields used for checking access to Topic fields
    private static String [] TopicAccessFields = new String []{
            'Name',
            'Id'
    };

    // Set of fields used for inserting TopicAssignment fields
    private static String [] TopicAssigmtInsertFields = new String []{
            'EntityId',
            'TopicId'
    };

    // Set of fields used for inserting fields while creating Events
    private static String [] eventInsertFields = new String []{
            'NetworkId__c',
            'All_Day_Event__c',
            'All_Day_Start__c',
            'All_Day_End__c',
            'Start_DateTime__c',
            'End_DateTime__c',
            'Details__c',
            'Location_Address__c',
            'Location_Name__c',
            'Ticket_Price__c',
            'Venue_Information__c',
            'Location_URL__c',
            'Payment_URL__c',
            'Event_Type__c',
            'Language__c',
            'GroupId__c',
            'Audience_Selected__c',
            'Summary__c'
    };

    // Set of fields used for fetching Event records
    private static String [] EventAccessFields = new String []{
            'Id',
            'Name',
            'All_Day_Event__c',
            'All_Day_Start__c',
            'All_Day_End__c',
            'Details__c',
            'Enable_Pricing_Payment__c',
            'Enable_RSVP__c',
            'End_DateTime__c',
            'Location_Address__c',
            'Location_Name__c',
            'Location_URL__c',
            'NetworkId__c',
            'Number_of_Attendees__c',
            'Payment_URL__c',
            'Event_Type__c',
            'RSVP_Count_Threshold__c',
            'Start_DateTime__c',
            'Ticket_Price__c',
            'Venue_Information__c',
            'GroupId__c',
            'Language__c',
            'Audience_Selected__c',
            'Summary__c',
            'Image_Reference__c',
            'Image_Type__c'
    };

    // Set of fields used for fetching EventTranslation records
    private static String [] EventTranslationFields = new String []{
            'Id',
            'Name',
            'Detail__c',
            'Venue_Information__c',
            'Language__c',
            'Parent__c',
            'Location_Name__c',
            'Title__c'
    };

    private static List<String> customFieldList {
        get;
        set;
    }

    private static String filterString {
        get;
        set;
    }

    // Set of fields used for checking access to Attachment records
    private static String [] AttachmentAccessFields = new String []{
            'Id',
            'Name'
    };

    // Set of fields used for inserting Attachment records
    private static String [] AttachmentInsertFields = new String []{
            'parentId',
            'Body',
            'Name',
            'ContentType'
    };

    private static String nameSpace {
        get {
            if (nameSpace == null) {
                String ns = getNameSpacePrefix();
                nameSpace = String.isBlank(ns) ? '' : ns + '__';
            }
            return nameSpace;
        }
        private set;
    }

    @AuraEnabled
    public static String getNameSpacePrefix() {
        return x7sEventsBaseController.getModel().namespacePrefix;
        //return '';
    }

    @AuraEnabled
    public static String getSitePrefix() {
        return System.Site.getPathPrefix();
    }

    @AuraEnabled
    public static String getSessionId() {
        return String.isEmpty(UserInfo.getSessionId()) ? '' : UserInfo.getSessionId();
    }

    @AuraEnabled
    public static String getTimeZone() {
        return String.valueOf(UserInfo.getTimeZone());
    }

    /* ---------------------------------------------------------
     * EVENT CUSTOM METADATA SETTINGS RELATED
     */

    @AuraEnabled
    public static Boolean userAuthorizedToPost() {
        Boolean userAuthorized = false;

        try {
            X7S_Events_Setting__mdt setting = [   // NOPMD
                    SELECT PermissionSetName__c
                    FROM X7S_Events_Setting__mdt
                    WHERE DeveloperName = 'Default'

            ];

            System.debug('userAuthorizedToPost name = ' + setting.PermissionSetName__c);
            userAuthorized = permissionSetMember(UserInfo.getUserId(), setting.PermissionSetName__c);
        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, 'X7S_Events_Setting__mdt not configured Permission set name: ' + e.getMessage());
        }

        return userAuthorized;
    }

    public static Boolean userAuthorizedToViewAll() {
        Boolean authorized = false;
        try {
            X7S_Events_Setting__mdt setting = [         //NOPMD
                    SELECT View_All_Permission_Set__c
                    FROM X7S_Events_Setting__mdt
                    WHERE DeveloperName = 'Default'

            ];
            authorized = permissionSetMember(UserInfo.getUserId(), setting.View_All_Permission_Set__c);
            System.debug('user authorized to see all = ' + authorized);
        } catch (Exception ex) {
            System.debug(System.LoggingLevel.ERROR, 'CMT Author_Permission_Set__c : ' + ex.getMessage());
        }

        return authorized;
    }

    private static Boolean permissionSetMember(String userId, String permissionSetList) {
        Boolean isMember = false;

        if (String.isNotBlank(permissionSetList)) {
            List<String> permissionSets = permissionSetList.split(',\\s*');

            isMember = [SELECT COUNT() FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.Name IN :permissionSets] > 0;
        }

        return isMember;
    }

    @AuraEnabled
    public static Boolean requireGroupMembership() {
        Boolean requireMembership = false;

        try {
            X7S_Events_Setting__mdt setting = [         // NOPMD
                    SELECT Require_Group_Membership__c
                    FROM X7S_Events_Setting__mdt
                    WHERE DeveloperName = 'Default'

            ];

            requireMembership = setting.Require_Group_Membership__c;
        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, 'X7S_Events_Setting__mdt not configured for Require Group Membership : ' + e.getMessage());
        }

        return requireMembership;
    }

    @TestVisible
    private static Integer getTopicLimit() {
        Integer topicLimit = MAX_TOPICS;

        try {
            X7S_Events_Setting__mdt setting = [
                    SELECT Topic_Limit__c
                    FROM X7S_Events_Setting__mdt
                    WHERE DeveloperName = 'Default'
            ];

            topicLimit = setting.Topic_Limit__c != null ? Integer.valueOf(setting.Topic_Limit__c) : MAX_TOPICS;
        } catch (Exception e) { System.debug(System.LoggingLevel.ERROR, 'X7S_Events_Setting__mdt not configured for Topic Limit');  }

        return topicLimit;
    }

    /**
     * MethodName	: deleteAttachment
     * param			: eventRecordId
     * Description	: Method for deleting the first attachment for a particular record when user selects another record in Edit Detail page.
     *
     * @param eventRecordId target event id
     *
     * @return list of deleted attachments
     */
    @AuraEnabled
    public static List<Attachment> deleteAttachment(String eventRecordId) {
        List<Attachment> attachments = new List<Attachment>();

        if (!Attachment.SObjectType.getDescribe().isDeletable()) {
            System.debug('deleteAttachment(): unabled to delete Attachement');
            return attachments;
        }

        try {
            attachments = [SELECT Id FROM Attachment WHERE ParentId = :eventRecordId WITH SECURITY_ENFORCED ];

            if (!attachments.isEmpty()) {
                delete attachments;
            }
        } catch (Exception e) {
            System.debug('deleteAttachment() : ' + e.getMessage() + ' line number: ' + e.getLineNumber());
        }

        return attachments;
    }

    /*
        * MethodName		: isObjectCreatable
        * param			 :
        * Description	   : Method to check whether Event__c object is creatable or not.
    */
    @AuraEnabled
    public static Boolean isObjectCreatable() {
        return Schema.SObjectType.X7S_Event__c.isCreateable() ? true : false;
    }

    /*
        * MethodName		: isObjectEditable
        * param			 :
        * Description	   : Method to check whether Event__c object is Updateable or not.
    */
    @AuraEnabled
    public static Boolean isObjectEditable() {
        return Schema.SObjectType.X7S_Event__c.isUpdateable() ? true : false;
    }

    @AuraEnabled
    public static Boolean isRecordEditable(String eventRecordId) {
        try {
            List<UserRecordAccess> userRecordAccess = new List<UserRecordAccess>();

            userRecordAccess = [SELECT HasEditAccess, RecordId FROM UserRecordAccess WHERE RecordId = :eventRecordId AND UserId = :UserInfo.getUserId() WITH SECURITY_ENFORCED ];

            return (!userRecordAccess.isEmpty() && userRecordAccess[0].HasEditAccess) ? true : false;
        } catch (Exception e ){
            System.debug('isRecordEditable() : ' + e.getMessage() + ' line NUmber : ' + e.getLineNumber());
        }

        return false;
    }

    /**
     * MethodName	: saveEvents
     * params		: eventObj, strfilterByTopic, allDayEventStartDate, allDayEventEndDate
     * Description	: Method for saving all event records for create as well ad detail page.
     *
     * @param eventObj New event object
     * @param strEventFilterTopic topic filter
     * @param allDayEventStartDate start date
     * @param allDayEventEndDate end date
     * @param audience selected audience
     *
     * @return new event
     */
    @AuraEnabled
    public static X7S_Event__c saveEvents(
            X7S_Event__c eventObj,
            String strEventFilterTopic,
            String allDayEventStartDate,
            String allDayEventEndDate,
            String audience) {
        //Updating  all DML to be wrapped in a Database.savepoint() in case we need to roll back due to failure of a DML
        Savepoint SP_PreEventDMLState = Database.setSavepoint();

        if (X7S_Event__c.SObjectType.getDescribe().isCreateable()) {
            // Obtaining the field name/token map for the Event object
            Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.X7S_Event__c.fields.getMap();
            Map<String, Schema.SObjectField> TAFldMap = Schema.SObjectType.TopicAssignment.fields.getMap();

            for (String fieldToCheck : eventInsertFields) {
                String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

                // Check if the user has access to view field
                // exception Search and pass error to client
                if (!eventFldMap.get(fullFieldName).getDescribe().isCreateable()) {
                    throw new System.NoAccessException();
                }
            }

            for (String fieldToCheck : TopicAssigmtInsertFields) {
                // Check if the user has access to view field
                //  exception Search and pass error to client
                if (!TAFldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                    throw new System.NoAccessException();
                }
            }

            //Set communityId and Audience targeting
            eventObj.NetworkId__c = communityId;
            eventObj.Audience_Selected__c = String.isNotBlank(audience);

            // Insert or upsert topics for create as well as edit Event page
            // get this from events settings CMT
            Integer maxTopics = getTopicLimit();
            String entityTypeName = nameSpace + EVENT_OBJECT_NAME;

            Map<String, TopicAssignment> topicMap = new Map<String, TopicAssignment>();

            try {
                if (eventObj.Id != null) {
                    List<TopicAssignment> topicAssignments = [SELECT Id, EntityId, Topic.Id, Topic.Name FROM TopicAssignment WHERE NetworkId = :communityId AND EntityId = :eventObj.Id AND EntityType = :entityTypeName WITH SECURITY_ENFORCED LIMIT :maxTopics];
                    for (TopicAssignment tAssgn : topicAssignments) {
                        topicMap.put(tAssgn.TopicId, tAssgn);
                    }
                }

                upsert eventObj;
            } catch (DmlException dmlExp) {
                Database.rollback(SP_PreEventDMLState);
            } catch (Exception e) {
                System.debug('Error :' + e.getMessage() + ',Line number : ' + e.getLineNumber());
                return null;
            }

            // Update topics for this event
            if ((topicMap.size() > 0 || String.isNotBlank(strEventFilterTopic))
                && TopicAssignment.SObjectType.getDescribe().isCreateable()
                && TopicAssignment.SObjectType.getDescribe().isDeletable()) {
                List<TopicAssignment> topicAssignmentLst = new List<TopicAssignment>();
                Set<String> topicLst = new Set<String>();

                if (strEventFilterTopic.trim().length() > 0) {
                    topicLst.addAll(strEventFilterTopic.split(','));
                }
                Set<String> topicSet = new Set<String>();
                List<TopicAssignment> deleteAssignments = new List<TopicAssignment>();
                if (topicMap.size() > 0) {
                    for (String topicId : topicMap.keySet()) {
                        for (String tId : topicLst) {

                            if (tId != topicId) {
                                if (!topicSet.contains(tId)) {
                                    topicSet.add(tId);
                                    TopicAssignment t = new TopicAssignment();
                                    t.EntityId = eventObj.Id;
                                    t.TopicId = tId;
                                    topicAssignmentLst.add(t);
                                }
                            }
                        }
                        if (!topicLst.contains(topicId)) {
                            deleteAssignments.add(topicMap.get(topicId));
                        }
                    }
                } else {
                    for (String strTopicId : topicLst) {
                        if (!String.isEmpty(strTopicId)) {
                            TopicAssignment t = new TopicAssignment();
                            t.EntityId = eventObj.Id;
                            t.TopicId = strTopicId;
                            topicAssignmentLst.add(t);
                        }
                    }
                }

                try {
                    if (deleteAssignments.size() > 0) {
                        delete deleteAssignments;
                    }

                    if (topicAssignmentLst.size() > 0) {

                        //upsert topicAssignmentLst;
                        insert topicAssignmentLst;
                    }
                } catch (DmlException exp) {
                    System.debug('Error :' + exp.getMessage() + ',Line number : ' + exp.getLineNumber());
                    Database.rollback(SP_PreEventDMLState);
                } catch (Exception e) {
                    System.debug('Error :' + e.getMessage() + ',Line number : ' + e.getLineNumber());
                    return null;
                }

            }

            // create an audience target record for this item
            if (String.isNotBlank(audience)) {
                assignAudienceToRecord(audience, eventObj.Id, System.Network.getNetworkId());
            }

            return eventObj;
        } else {
            return null;
        }
    }

    /*
        * MethodName : saveEvents
        * param		 : fldMap, objectAccess
        * Description: Method for Checking no access exception for specific fields in the map.
    */
    private static Boolean checkFieldType(Map<String, Schema.SObjectField> fldMap, String[] objectAccess) {
        for (String fieldToCheck : objectAccess) {
            String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

            if (!fldMap.get(fullFieldName).getDescribe().isAccessible()) {
                System.debug(LoggingLevel.ERROR, 'Access failed for field: ' + fullFieldName);
                return false;
            }
        }
        return true;
    }

    /*
    @Name		: getGroups
    @Description: Get a list of all the groups this user is a member of
     */
    @AuraEnabled
    public static Map<String, String> getGroups() {
        Map<String, String> groups = new Map<String, String>();

        for (CollaborationGroupMember member : [
                SELECT Id, CollaborationGroupId, CollaborationGroup.Name
                FROM CollaborationGroupMember
                WHERE MemberId = :UserInfo.getUserId() AND NetworkId = :communityId
                LIMIT 1000
        ]) {
            groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
        }

        return groups;
    }

    /*
    @Name		   : getAllGroups
    @Description	: Get a list of all the groups on the org
     */
    @AuraEnabled
    public static Map<String, String> getAllGroups() {
        Map<String, String> groups = new Map<String, String>();

        for (CollaborationGroupMember member : [
                SELECT Id, CollaborationGroupId, CollaborationGroup.Name
                FROM CollaborationGroupMember
                WHERE NetworkId = :communityId
                LIMIT 1000
        ]) {
            groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
        }

        return groups;
    }

    @AuraEnabled
    public static x7sEventsListWrapper getEventsList(
            Boolean compactMode,
            Integer recordSize,
            Integer listSize,
            String strFilterType,
            String sortBy,
            String filterByTopic,
            String topicName,
            String searchTerm,
            String filterOn,
            String fromDate,
            String toDate,
            String listViewMode,
            String customFields,
            String filters,
            List<String> eventIdList) {
        customFieldList = getCustomFields(customFields);
        filterString = filters;

        return getEvents(compactMode, recordSize, listSize, 0, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode, eventIdList);
    }

    /*
     * MethodName : getEvents
     * param	  : eventListFlag, numberofresults, listSize, pageNumber, strfilterType
     *				strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm,
     *				searchTerm, filterOn, fromDate, toDate, listViewMode, FeaturedEventIdList
     * Description: Method to fetch all event records for list view, topic and search pages.
     */
    @AuraEnabled
    public static x7sEventsListWrapper getEvents(
            Boolean eventListFlag,
            Integer numberofresults,
            Integer listSize,
            Integer pageNumber,
            String strfilterType,
            String strRecordId,
            String networkId,
            String sortBy,
            String filterByTopic,
            String topicName,
            Boolean filterBySearchTerm,
            String searchTerm,
            String filterOn,
            String fromDate,
            String toDate,
            String listViewMode,
            List<String> eventIdList) {
        System.debug('calling getEvents');
        System.debug('      results     : ' + numberofresults);
        System.debug('      list size   : ' + listSize);
        System.debug('      sort by     : ' + sortBy);
        System.debug('      from        : ' + fromDate);
        System.debug('      to          : ' + toDate);
        System.debug('      filter on   : ' + filterOn);
        System.debug('      search      : ' + searchTerm);
        System.debug('      topic filter: ' + filterByTopic);
        System.debug('      topic       : ' + topicName);
        System.debug('      Event Ids   : ' + eventIdList);

        // get this from events settings CMT
        Integer maxTopics = getTopicLimit();
        String entityTypeName = nameSpace + EVENT_OBJECT_NAME;
        Set<String> multiLngIds = new Set<String>();

        // Obtaining the field name/token map for the Event object
        Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();
        Map<String, Schema.SObjectField> TAFldMap = Schema.SObjectType.TopicAssignment.fields.getMap();

        // Checking no access exception for EventAccessFields, TopicAccessFields and TopicAssigmtAccessFields
        if (!checkFieldType(topicFldMap, TopicAccessFields)) {
            System.debug('ACCESS CHECK failed for TopicAccessFields');
            throw new System.NoAccessException();
        }

        if (!checkFieldType(TAFldMap, TopicAssigmtAccessFields)) {
            System.debug('ACCESS CHECK failed for TopicAssignmentAccessFields');
            throw new System.NoAccessException();
        }

        listSize = Integer.valueOf(listSize);

        Datetime fromDt;
        Datetime toDt;

        try {
            //create datetime instance of fromDate and toDate as we get them in string format
            if (String.isNotBlank(fromDate) || String.isNotBlank(toDate)) {
                if (String.isNotBlank(fromDate)) {
                    fromDt = Datetime.valueOf(fromDate + ' ' + '00:00:00');
                }
                if (String.isNotBlank(toDate)) {
                    toDt = Datetime.valueOf(toDate + ' ' + '23:59:00');
                }
            }
        } catch (Exception e) {
            System.debug('ERROR:' + e);
            return new x7sEventsListWrapper('Date', e.getMessage());
        }

        Integer limitInt = Integer.valueOf(numberofresults);
        Set<String> topicIds = new Set<String>();
        Set<String> groupEventIds = null;

        // this fails to yield results in very large communities
        for (TopicAssignment topicAssignment : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND EntityId = :String.valueOf(strRecordId) AND EntityType = :entityTypeName LIMIT :maxTopics]) {
            topicIds.add(topicAssignment.Topic.Id);
        }

        Set<String> eventIds = new Set<String>();
        for (TopicAssignment topicAssignment : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND Topic.Id IN :topicIds AND EntityType = :entityTypeName LIMIT :maxTopics]) {
            eventIds.add(topicAssignment.EntityId);
        }

        List<String> keywordSetCategoriesList = new List<String>(eventIds);
        String categoriesJoined = '(\'' + String.join(keywordSetCategoriesList, '\',\'') + '\')';

        // Group membership
        Boolean requireGroupId = requireGroupMembership();
        List<String> myEventIds = new List<String>();

        Boolean useAudience = audienceEnabled() && !userAuthorizedToViewAll();
        List<String> audienceIds = new List<String>();

        if (useAudience) {
            audienceIds = getAudienceTargetIds(communityId);
            System.debug('Using audience - ' + audienceIds);
        }

        if (filterOn.startsWith('My Events')) {
            // IF on a profile page, the user Id is tacked on to the filterOn string
            // - filterOn == 'My Events':recordId
            // else use the current userId
            String userId = UserInfo.getUserId();

            if (filterOn.indexOf(':') > 0) {
                userId = filterOn.substringAfterLast(SEARCH_FIELD);
            }

            for (X7S_Event_RSVP__c myRsvp : [SELECT Event__c FROM X7S_Event_RSVP__c WHERE User__c = :userId]) {
                myEventIds.add(myRsvp.Event__c);
            }
        }

        // get the user langauge api value
        String userLanguage = getLanguage();
        User currentUser = getCurrentUser();

        // multi language enabled logic
        if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

            String queryEventsTranslate = getTranslationQuery();

            //Translation Records
            if (String.isNotBlank(queryEventsTranslate)) {

                List<X7S_Event_Translation__c> translateList;

                if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
                    translateList = Database.query(String.escapeSingleQuotes(queryEventsTranslate) +
                            ' WHERE NAME LIKE \'%' + String.escapeSingleQuotes(searchTerm.trim()) + '%\'' +
                            ' AND Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\''
                    );
                } else {
                    translateList = Database.query(String.escapeSingleQuotes(queryEventsTranslate) +
                            ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\''
                    );
                }

                for (X7S_Event_Translation__c eventRecord : translateList) {
                    multiLngIds.add(eventRecord.Parent__c);
                }
            }

            //Events Records
            String queryEventsArticle = getEventsQuery();
            if (String.isNotBlank(queryEventsArticle)) {
                List<X7S_Event__c> eventList;

                if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
                    eventList = Database.query(String.escapeSingleQuotes(queryEventsArticle) +
                            ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm.trim()) + '%\'' +
                            ' AND Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\''
                    );
                } else {
                    eventList = Database.query(String.escapeSingleQuotes(queryEventsArticle) +
                            ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\''
                    );
                }

                for (X7S_Event__c eventRecord : eventList) {
                    multiLngIds.add(eventRecord.Id);
                }
            }
        }


        /* **************************************************
         * Main query string
         ************************************************** */
        String Query = getSelectClause();
        Query += getFromClause();
        Query += getWhereClause();

        //Event records fetched in case of Recommended for you and eventListFlag = false
        if (filterOn == 'None' && limitInt != null && eventListFlag == false) {

            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

                if (categoriesJoined.length() > 5) {
                    multiLngIds = multiLanguageSet(keywordSetCategoriesList, multiLngIds);

                    Query += ' And Id IN :multiLngIds '; //**
                }
            } else {
                Query += categoriesJoined.length() > 5 ? ' AND Id IN ' + categoriesJoined : ' '; //**
            }

            if (String.isNotBlank(strRecordId)) {
                Query += ' And Id != \'' + String.escapeSingleQuotes(strRecordId.trim()) + '\'';  //**

            }
        }

        //Fetching event records in case of Search page - List view
        if (String.isNotBlank(searchTerm)) {
            if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
                searchTerm = String.escapeSingleQuotes(searchTerm.trim());
            }

            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

                Query += ' And Id IN :multiLngIds '; //**
            } else {
                Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm.trim()) + '%\'';
            }
        }

        //Fetch Event Records related Topic Page
        if (filterOn == 'Topic Value') {

            System.debug('Topic Value selected -- topic name = ' + topicName);

            eventIds = new Set<String>();


            // hack for Topic names with spaces that are replaced with a '-' in the URL

            topicName = topicName.trim();
            if (topicName.indexOf('-') != -1) {
                topicName = '%' + topicName.replace('-', '%') + '%';
            }
            topicName = String.escapeSingleQuotes(topicName);
            entityTypeName = String.escapeSingleQuotes(entityTypeName.trim());
            List<TopicAssignment> topicsLst = new List<TopicAssignment>([SELECT Id, EntityId, Topic.Id, Topic.Name FROM TopicAssignment WHERE Topic.Name LIKE:topicName AND EntityType = :entityTypeName LIMIT :maxTopics]);

            for (TopicAssignment t : topicsLst) {
                eventIds.add(t.EntityId);
            }

            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

                Set<String> eventLanguageIds = new Set<String>();
                for (String id : eventIds) {
                    if (multiLngIds.contains(id)) {
                        eventLanguageIds.add(id);
                    }
                }

                multiLngIds = eventLanguageIds;
                Query += ' And Id IN :multiLngIds ';
            } else {
                Query += ' AND Id IN : eventIds ';   //**
            }

            Query += ' AND NetworkId__c = \'' + communityId + '\'';
        }

        if (filterOn == 'Group') {
            Query += ' AND GroupId__c  = \'' + String.escapeSingleQuotes(topicName.trim()) + '\'';
            System.debug('Query for Groups : ' + Query);
        }

        if (filterOn == 'LocationName' && String.isNotBlank(strfilterType)) {
            Query += ' AND Location_Name__c  = \'' + String.escapeSingleQuotes(strfilterType.trim()) + '\'';
            System.debug('Query for location : ' + Query);
        }

        if (filterOn == 'Event_Type__c' && String.isNotBlank(strfilterType)) {
            Query += ' AND Event_Type__c  = \'' + String.escapeSingleQuotes(strfilterType.trim()) + '\'';
            System.debug('Query for Event Type : ' + Query);
        }

        if (filterOn.startsWith('My Events')) {

            String myEventIdString = '(\'' + String.join(myEventIds, '\',\'') + '\')';
            System.debug('My Events : ' + myEventIdString);

            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {


                multiLngIds = multiLanguageSet(myEventIds, multiLngIds);
                Query += ' And Id IN :multiLngIds ';

            } else {
                Query += ' AND Id IN ' + myEventIdString; //**
            }
        }

        //If event Ids are provided to filter on
        if (eventIdList.size() > 0) {
            String eventIdString = '(\'' + String.join(eventIdList, '\',\'') + '\')';
            System.debug('Featured Events : ' + eventIdString);

            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

                multiLngIds = multiLanguageSet(eventIdList, multiLngIds);
                Query += ' And Id IN :multiLngIds ';

            } else {
                Query += ' AND Id IN ' + eventIdString;
            }
        }

        // Filter string pattern
        //  field1:value1;field2:value2;
        System.debug('filter string: ' + filterString);
        if (String.isNotBlank(filterString)) {
            Query += getCustomFilterClause(filterString);
        }

        if (fromDt != null || toDt != null || String.isNotBlank(filterByTopic) || String.isNotBlank(sortBy)) {

            if (fromDt != null || toDt != null) {
                if (fromDt != null) {
                    Query += ' And (Start_DateTime__c >= :fromDt OR All_Day_Start__c >= :fromDate) ';
                }
                if (toDt != null) {
                    Query += ' And (Start_DateTime__c <= :toDt OR ALL_Day_Start__c <= :toDate) ' ;
                }
            } else if (sortBy == 'Upcoming') {
                Query += ' AND (UpComing_Sort__c >= TODAY OR End_DateTime__c >= TODAY OR All_Day_End__c >= TODAY) ';
            }

            if (String.isNotBlank(filterByTopic)) {

                System.debug('Filter by topic: ' + filterByTopic);
                Set<String> topicLst = new Set<String>();
                topicLst.addAll(filterByTopic.split(','));

                Boolean fieldIsId = false;

                for (String topicNameEntry : topicLst) {
                    if (topicNameEntry instanceof Id) {
                        fieldIsId = true;
                    } else {
                        if (topicNameEntry.indexOf('-') != -1) {
                            topicLst.add(topicNameEntry.trim().replace('-', ' '));
                        } else {
                            topicLst.add(topicNameEntry.trim());
                        }
                    }
                }
                System.debug('Topic list: ' + topicLst);

                List<String> topicIdList = new List<String>();
                String targetName = fieldIsId ? 'Id' : 'name';
                String topicIdQuery = 'SELECT Id, Name FROM Topic WHERE ' + targetName + ' IN : topicLst';
                List<Topic> topics = Database.query(String.escapeSingleQuotes(topicIdQuery));
                for (Topic entry : topics) {
                    topicIdList.add(entry.Id);
                }

                // Filter by Topic
                eventIds = new Set<String>();

                for (TopicAssignment t : [SELECT Id, EntityId, Topic.Id FROM TopicAssignment WHERE NetworkId = :communityId AND Topic.Id = :topicIdList AND EntityType = :entityTypeName LIMIT :maxTopics]) {
                    eventIds.add(t.EntityId);
                }

                if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

                    Set<String> eventLanguageIds = new Set<String>();
                    for (String id : eventIds) {
                        if (multiLngIds.contains(id)) {
                            eventLanguageIds.add(id);
                        }
                    }

                    multiLngIds = eventLanguageIds;
                    Query += ' AND Id IN :multiLngIds ';
                } else {
                    Query += ' AND Id IN :eventIds ';
                }
            }
        }

        if (!Query.contains('Id IN')) {
            if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {
                Query += ' AND Id IN :multiLngIds ';
            }
        }

        if (requireGroupId) {

            groupEventIds = getGroups().keySet();
            Query += groupEventIds.size() > 0 ? ' AND (GroupId__c = null OR GroupId__c IN : groupEventIds)' : ' AND GroupId__c = null';
        }

        if (useAudience) {
            Query += getAudienceQuery(audienceIds);
        }

        Query += getSortClause(sortBy);
        Query += getLimitClause(limitInt);

        x7sEventsListWrapper resultWrapper = new x7sEventsListWrapper(
                Query,
                multiLngIds,
                listSize,
                fromDt,
                toDt,
                String.isNotBlank(fromDate) ? Date.valueOf(fromDate) : null,
                String.isNotBlank(toDate) ? Date.valueOf(toDate) : null,
                eventIds,
                listViewMode,
                false,
                null,
                groupEventIds,
                userLanguage,
                currentUser.UserType,
                audienceIds);

        return resultWrapper;
    }

    public static String getSelectClause() {

        String userLanguage = getLanguage();
        User currentUser = getCurrentUser();

        String fields = String.join(EventAccessFields, ',');
        fields = fields.removeEnd(',');

        // Main query string
        String selectClause = 'SELECT ' + fields + ', (SELECT Id, Name FROM Attachments)';

        // Main query with translation record
        if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {

            String fieldsTranslation = String.join(EventTranslationFields, ',');
            fieldsTranslation = fieldsTranslation.removeEnd(',');
            selectClause += ', (SELECT ' + fieldsTranslation + ' FROM ' + DHILD_RELATIONSHIP_OBJECT_NAME + '';
            selectClause += ' WHERE Language__c = \'' + String.escapeSingleQuotes(userLanguage) + '\')';
        }

        if (customFieldList != null) {
            for (String field : customFieldList) {
                if (!EventAccessFields.contains(field)) {
                    selectClause += ', ' + String.escapeSingleQuotes(field.trim());
                }
            }
        }

        System.debug('Select clause: ' + selectClause);
        return selectClause;
    }

    public static String getTranslationQuery() {
        String fieldsTranslation = String.join(EventTranslationFields, ',');
        fieldsTranslation = fieldsTranslation.removeEnd(',');
        String selectClause = 'SELECT ' + fieldsTranslation + ' FROM ' + EVENT_TRANSLATION_OBJECT_NAME + '';

        System.debug('Select Translation clause: ' + selectClause);
        return selectClause;
    }

    public static String getEventsQuery() {

        String fields = String.join(EventAccessFields, ',');
        fields = fields.removeEnd(',');
        String selectClause = 'SELECT ' + fields + ' FROM ' + EVENT_OBJECT_NAME + '';

        System.debug('Select Events clause: ' + selectClause);
        return selectClause;
    }

    private static String getFromClause() {
        return ' FROM ' + EVENT_OBJECT_NAME;
    }

    public static String getCalendarWhereClause(String filterByTopic) {
        String query = getWhereClause();

        if (String.isNotBlank(filterByTopic)) {
            query += ' And Id IN :eventIds';
        }

        return query;
    }

    public static String getWhereClause() {
        String query = ' WHERE NetworkId__c = ';
        query += String.isNotBlank(communityId) ? '\'' + communityId + '\'' : 'null';

        return query;
    }

    public static String getSortClause(String sortBy) {
        System.debug('sortBy = ' + sortBy);

        String sortByClause = '';

        if (sortBy == 'Upcoming') {
            sortByClause += ' ORDER BY UpComing_Sort__c';
        }
        // sort event records in calendar mode for Top attendees
        else if (sortBy == 'Top Attendance') {
            sortByClause += ' ORDER BY Number_of_Attendees__c DESC';
        } else {
            sortByClause += ' ORDER BY UpComing_Sort__c';
        }

        return sortByClause;
    }

    public static String getLimitClause(Integer limitValue) {
        return limitValue != null ? ' LIMIT ' + limitValue : '';
    }

    public static String getCustomFilterClause(String filterString) {
        System.debug('getCustomFilterClause - filter string: ' + filterString);
        String filterQuery = '';

        if (String.isNotBlank(filterString)) {
            List<String> searchParts = filterString.split(SEARCH_SEPARATOR);

            for (Integer i = 0; i < searchParts.size(); i++) {
                if (searchParts[i].indexOf(SEARCH_FIELD) != -1) {
                    String fieldName = searchParts[i].substringBefore(SEARCH_FIELD);
                    String fieldValue = searchParts[i].substringAfter(SEARCH_FIELD);

                    filterQuery += ' AND '
                            + fieldName.trim()
                            + ' LIKE \'%'
                            + String.escapeSingleQuotes(fieldValue)
                            + '%\'';
                }
            }
        }

        System.debug('Custom filter query: ' + filterQuery);
        return filterQuery;
    }

    /**
     * Create the query sub-string to select records for the use's audience
     *
     * @param audienceIds list of target ids applicable to the user's audience
     *
     * @return sub-query string to select records for the target audience
     */
    private static String getAudienceQuery(List<String> audienceIds) {
        return ' AND (Audience_Selected__c = false'
                + (audienceIds.size() > 0 ? ' OR Id IN : audienceIds' : '')
                + (') ');
    }

    public static List<String> getCustomFields(String fieldList) {
        System.debug('getCustomFields : ' + fieldList);
        List<String> fieldsSet = fieldList.split(FIELD_SEPARATOR);

        // prefix the namespace
        for (Integer pos = 0; pos < fieldsSet.size(); pos++) {
            String fieldValue = fieldsSet.get(pos);
            fieldsSet.set(pos, nameSpace + fieldValue);
        }

        List<String> fields = new List<String>();

        Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.X7S_Event__c.fields.getMap();

        for (String field : fieldsSet) {
            if (eventFldMap.containsKey(field.trim())) {
                fields.add(field.trim());
            } else {
                System.debug('Custom field ' + field + ' not found on the X7S_Event__C record');
            }
        }

        return fields;
    }

    @AuraEnabled
    public static x7sEventsListWrapper nextPageList(
            Integer pageNumber,
            Boolean compactMode,
            Integer recordSize,
            Integer listSize,
            String strFilterType,
            String sortBy,
            String filterByTopic,
            String topicName,
            String searchTerm,
            String filterOn,
            String fromDate,
            String toDate,
            String listViewMode,
            String customFields,
            String filters,
            List<String> eventIdList) {
        customFieldList = getCustomFields(customFields);
        filterString = filters;

        return nextPage(compactMode, recordSize, listSize, pageNumber, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode, eventIdList);
    }
    /*
        * MethodName		: nextPage
        * param			 : eventListFlag, numberofresults, numberofresults, listSize,toDate,
                              pageNumber, strfilterType, strRecordId, networkId, sortBy,searchTerm,
                              filterByTopic, topicName, filterBySearchTerm, filterOn, fromDate, listViewMode, FeaturedEventIdList
        * Description	   : Method to fetch all event records for next page pagination.
    */
    @AuraEnabled
    public static x7sEventsListWrapper nextPage(Boolean eventListFlag, Integer numberofresults, Integer listSize, Integer pageNumber, String strfilterType, String strRecordId, String networkId, String sortBy, String filterByTopic, String topicName, Boolean filterBySearchTerm, String searchTerm, String filterOn, String fromDate, String toDate, String listViewMode, List<String> eventIdList) {
        Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : DEFAULT_LIST_SIZE;
        Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE;

        x7sEventsListWrapper ilw = getEvents(eventListFlag, numberofresults, listSizeValue, pageNumberValue, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventIdList);
        ilw.pageNumber = pageNumberValue;

        ilw.nextPage();

        return ilw;

    }

    @AuraEnabled
    public static x7sEventsListWrapper previousPageList(
            Integer pageNumber,
            Boolean compactMode,
            Integer recordSize,
            Integer listSize,
            String strFilterType,
            String sortBy,
            String filterByTopic,
            String topicName,
            String searchTerm,
            String filterOn,
            String fromDate,
            String toDate,
            String listViewMode,
            String customFields,
            String filters,
            List<String> eventIdList) {
        customFieldList = getCustomFields(customFields);
        filterString = filters;

        return previousPage(compactMode, recordSize, listSize, pageNumber, strFilterType, topicName, '', sortBy, filterByTopic, topicName, false, searchTerm, filterOn, fromDate, toDate, listViewMode, eventIdList);

    }
    /*
        * MethodName		: previousPage
        * param			 : eventListFlag, numberofresults, numberofresults, listSize,toDate,
                              pageNumber, strfilterType, strRecordId, networkId, sortBy,searchTerm,
                              filterByTopic, topicName, filterBySearchTerm, filterOn, fromDate, listViewMode, FeaturedEventIdList
        * Description	   : Method to fetch all event records for previous page pagination.
    */
    @AuraEnabled
    public static x7sEventsListWrapper previousPage(Boolean eventListFlag, Integer numberofresults, Integer listSize, Integer pageNumber, String strfilterType, String strRecordId, String networkId, String sortBy, String filterByTopic, String topicName, Boolean filterBySearchTerm, String searchTerm, String filterOn, String fromDate, String toDate, String listViewMode, List<String> eventIdList) {
        Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : DEFAULT_LIST_SIZE;
        Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE;

        x7sEventsListWrapper ilw = getEvents(eventListFlag, numberofresults, listSizeValue, pageNumberValue, strfilterType, strRecordId, networkId, sortBy, filterByTopic, topicName, filterBySearchTerm, searchTerm, filterOn, fromDate, toDate, listViewMode, eventIdList);
        ilw.pageNumber = pageNumberValue;

        ilw.previousPage();

        return ilw;

    }

    /*
        * MethodName  : getTopics
        * Description : Method to fetch all topics records.
    */

    @AuraEnabled
    public static Map<String, String> getTopics() {
        Map<String, String> topics = new Map<String, String>();
        List<Topic> topicList = new List<Topic>();
        Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();

        if (communityId != null) {
            for (String fieldToCheck : TopicAccessFields) {
                // Check if the user has access to view field
                // exception Search and pass error to client
                if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }
            topicList = [
                    SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
                    FROM Topic
                    WHERE NetworkId = :communityId
                    LIMIT 2000
            ];
        } else {
            for (String fieldToCheck : TopicAccessFields) {
                // Check if the user has access to view field
                // exception Search and pass error to client
                if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    throw new System.NoAccessException();
                }
            }

            topicList = [
                    SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
                    FROM Topic
                    WHERE NetworkId = null
                    LIMIT 2000
            ];
        }

        for (Topic t : topicList) {
            topics.put(t.Id, t.Name);
        }

        return topics;
    }

    /*@AuraEnabled(Cacheable=true)
    public static Map<String, String> getTopics() {

        Map<String, String> topics = new Map<String, String>();
        List<Topic> topicList = new List<Topic>();

        String queryTopic = getQueryString('Topic');
        System.debug('Query:'+ queryTopic);
        if (String.isNotBlank(queryTopic)) {
            if (String.isNotBlank(networkId)) {
                queryTopic += ' Where (NetworkId = \'' + networkId + '\'';
                queryTopic += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
            } else {
                queryTopic += ' WHERE NetworkId = null';
            }
            queryTopic += ' LIMIT 1000';

            System.debug('getTopics Query: ' + queryTopic);

            topicList = Database.query(queryTopic);

            for (Topic t : topicList) {
                topics.put(t.Id, t.Name);
            }

            return topics;
        } else {
            return null;
        }
    } */

    @AuraEnabled
    public static x7sEventsListWrapper getEventRecord(String eventRecordId, String customFields) {
        System.debug('New getEventRecord call with' + customFields);

        if (String.isNotBlank(customFields)) {
            customFieldList = getCustomFields(customFields);
        }

        return getEventRecord(eventRecordId);

    }

    /**
     * MethodName		: getEventRecord
     * param			 : eventRecordId
     * Description	   : Method to fetch particular event record on call of edit page.
     * @param eventRecordId Target event Id
     * @return EventListWrapper
     */
    @AuraEnabled
    public static x7sEventsListWrapper getEventRecord(String eventRecordId) {

        //get the user language api value
        String userLanguage = getLanguage();
        User currentUser = getCurrentUser();
        System.debug('getting event record:');

        Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.X7S_Event__c.fields.getMap();
        Map<String, Schema.SObjectField> attFldMap = Schema.SObjectType.Attachment.fields.getMap();

        for (String fieldToCheck : EventAccessFields) {
            String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

            System.debug('	: ' + fullFieldName);

            // Check if the user has access to view field
            // exception Search and pass error to client
            if (!eventFldMap.get(fullFieldName).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        for (String fieldToCheck : AttachmentAccessFields) {

            // Check if the user has access to view field
            // Search and pass error to client
            if (!attFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }

        Boolean useAudience = audienceEnabled() && !userAuthorizedToViewAll();
        List<String> audienceIds = new List<String>();

        if (useAudience) {
            audienceIds = getAudienceTargetIds(communityId);
        }

        Set<String> eventIds = new Set<String>();
        String Query = getSelectClause();

        Query += getFromClause();
        //Query += getWhereClause();
        Query += ' WHERE  Id = \'' + String.escapeSingleQuotes(eventRecordId.trim()) + '\'';

        if (useAudience) {
            Query += getAudienceQuery(audienceIds);
        }

        System.debug('query = ' + Query);

        x7sEventsListWrapper wrapper = new x7sEventsListWrapper(Query, null, 1, null, null, null, null, eventIds, null, false, null, null, userLanguage, currentUser.UserType, audienceIds);

        if (wrapper.objEventList.size() > 0) {
            X7S_Event__c event = wrapper.objEventList[0];

            wrapper.detailsForAddToCalendar = breakUpDetails(event.Details__c);
            wrapper.summaryForAddToCalendar = breakUpDetails(event.Summary__c);
        }

        return wrapper;
    }

    @TestVisible
    private static String breakUpDetails(String details) {
        if (String.isBlank(details)) {
            return '';
        }

        Integer sizeOfDetails = measureString(details);
        // Will hold modified details with CRLF characters inserted to break
        // up line at 75 octets.
        String updatedDetails = '';

        if (sizeOfDetails > 75) {
            // Content is greater than 75 octets, need to break up string with
            // CRLF characters.
            String newLine = '\r\n ';
            Integer stringLength = details.length();
            Integer characterIndex = 0;
            // The max line length is 75 octets minus the new line length.
            Integer maximumLineLength = 75 - measureString(newLine);
            // Line length and string length may not be the same.
            Integer lineLength = maximumLineLength;

            do {
                String characterToCheck = details.substring(characterIndex, characterIndex + 1);
                // Character length in octets.
                Integer characterLength = measureString(characterToCheck);

                if (lineLength - characterLength >= 0) {
                    lineLength -= characterLength;
                    updatedDetails += characterToCheck;

                    if (lineLength == 0) {
                        // Add a the NewLine character(s)
                        updatedDetails += newLine;

                        // Reset to maximum line length again.
                        lineLength = maximumLineLength;
                    }
                } else {
                    // next character will exceed the maximum line length
                    // add the new line character and reset line length
                    updatedDetails += newLine + characterToCheck;
                    lineLength = maximumLineLength - characterLength;
                }

                characterIndex++;
            } while (characterIndex < stringLength);
        } else {
            // Details string does not need to be broken up.
            updatedDetails = details;
        }

        return updatedDetails;
    }

    private static Integer measureString(String stringToMeasure) {
        if (String.isNotBlank(stringToMeasure)) {
            Blob stringBlob = Blob.valueOf(stringToMeasure);
            return stringBlob.size();
        }

        return 0;
    }

    /**
     * MethodName	: getEventName
     * param			: eventRecordId
     * Description	: Method to fetch particular event record's Name.
     *
     * @param eventRecordId
     *
     * @return
     */
    @AuraEnabled
    public static String getEventName(String eventRecordId) {
        String userLanguage = getLanguage();
        User currentUser = getCurrentUser();
        String[] flds = new String[]{
                'Id', 'Name'
        };
        Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.X7S_Event__c.fields.getMap();

        for (String fieldToCheck : flds) {
            // Check if the user has access to view field
            // exception Search and pass error to client
            if (!eventFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }

        if (String.isNotBlank(userLanguage) && String.isNotEmpty(userLanguage) && currentUser.UserType != FOR_GUEST_TYPE) {
            List<X7S_Event__c> eventRecord = new List<X7S_Event__c>([
                    SELECT Id, Name,Language__c, (SELECT Title__c FROM X7S_Event_Translation__r WHERE Language__c = :userLanguage)
                    FROM X7S_Event__c
                    WHERE Id = :eventRecordId AND NetworkId__c = :communityId
            ]);

            if (eventRecord != null && eventRecord.size() > 0) {
                if (eventRecord[0].Language__c == userLanguage) {
                    return eventRecord[0].Name;
                } else {
                    return eventRecord[0].X7S_Event_Translation__r[0].Title__c;
                }
            }
        }

        return [SELECT Id, Name FROM X7S_Event__c WHERE Id = :eventRecordId AND NetworkId__c = :communityId].Name;
    }

    /*
        * MethodName		: getFeaturedEvents
        * param			 : recordId1, recordId2, recordId3, recordId4, recordId5
        * Description	   : Method to fetch featured and featured 1+4 event records.
    */
    @AuraEnabled
    public static x7sEventsListWrapper getFeaturedEvents(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5) {
        Map<String, Schema.SObjectField> eventFldMap = Schema.SObjectType.X7S_Event__c.fields.getMap();
        Map<String, Schema.SObjectField> attFldMap = Schema.SObjectType.Attachment.fields.getMap();
        Set<String> multiLngIds = new Set<String>();

        for (String fieldToCheck : EventAccessFields) {
            String fullFieldName = fieldToCheck.contains('__c') ? nameSpace + fieldToCheck : fieldToCheck;

            // Check if the user has access to view field
            // exception Search and pass error to client
            if (!eventFldMap.get(fullFieldName).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        for (String fieldToCheck : AttachmentAccessFields) {

            // Check if the user has access to view field
            // exception Search and pass error to client
            if (!attFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        // fetching all five records related to featured 1+4 records
        Boolean isFeatured = true;
        Set<String> eventIds = new Set<String>();
        Map<String, String> featuredEventIds = new Map<String, String>();

        if (recordId1 != null && !String.isEmpty(recordId1)) {
            featuredEventIds.put(recordId1, recordId1);
        }
        if (recordId2 != null && !String.isEmpty(recordId2)) {
            featuredEventIds.put(recordId2, recordId2);
        }
        if (recordId3 != null && !String.isEmpty(recordId3)) {
            featuredEventIds.put(recordId3, recordId3);
        }
        if (recordId4 != null && !String.isEmpty(recordId4)) {
            featuredEventIds.put(recordId4, recordId4);
        }
        if (recordId5 != null && !String.isEmpty(recordId5)) {
            featuredEventIds.put(recordId5, recordId5);
        }

        eventIds = featuredEventIds.keySet();

        String Query = 'Select ' + String.join(EventAccessFields, ',') + ',(select Id,Name from Attachments limit 1) FROM X7S_Event__c Where Id IN : eventIds And NetworkId__c = \'' + communityId + '\'';

        return new x7sEventsListWrapper(Query, multiLngIds, 5, null, null, eventIds, null, isFeatured, featuredEventIds, null, null, null);
    }

    /*
        * MethodName		: getRSVPMemberAttendes
        * param			 : EventName
        * Description	   : Method to fetch the rsvp member status. Whether they are joining or not.
    */
    @AuraEnabled
    public static Boolean getRSVPMemberAttendes(Id EventName) {
        List<X7S_Event_RSVP__c> lstEventRSVP = new List<X7S_Event_RSVP__c>([
                SELECT Id, Name, Event__c, User__c
                FROM X7S_Event_RSVP__c
                WHERE Event__c = :EventName
                AND User__c = :UserInfo.getUserId()
        ]);

        return lstEventRSVP.isEmpty() ? false : true;
    }

    /*
         * MethodName		: createRSVPevents
         * param			 : EventName, response
         * Description	   : Method to create X7S_Event_RSVP__c records on clicking yes on the RSVP component.
     */
    @AuraEnabled
    public static X7S_Event_RSVP__c createRSVPevents(Id EventName, String response) {
        if (X7S_Event_RSVP__c.SObjectType.getDescribe().isCreateable()) {
            if ([SELECT COUNT() FROM X7S_Event_RSVP__c WHERE Event__c = :EventName AND User__c = :UserInfo.getUserId()] <= 0) {
                X7S_Event_RSVP__c eventRSVPList = new X7S_Event_RSVP__c();
                eventRSVPList.Event__c = EventName;
                eventRSVPList.User__c = UserInfo.getUserId();
                eventRSVPList.Response__c = response;
                insert eventRSVPList;

            }
        }
        return null;
    }

    /*
        * MethodName		: deleteRSVPevents
        * param			 : EventId
        * Description	   : Method to delete X7S_Event_RSVP__c records on clicking No on RSVP component.
    */
    @AuraEnabled
    public static X7S_Event_RSVP__c deleteRSVPevents(Id EventId) {
        if (EventId != null) {
            delete [
                    SELECT Id
                    FROM X7S_Event_RSVP__c
                    WHERE User__c = :UserInfo.getUserId()
                    AND Event__c = :EventId
                    LIMIT 1
            ];
        }
        return null;
    }

    /*
        * MethodName		: deleteRSVPevents
        * param			 : EventId
        * Description	   : Method to delete X7S_Event_RSVP__c records on clicking No on RSVP component.
    */
    @AuraEnabled
    public static Boolean checkRSVPevents(Id EventId) {
        return [
                SELECT COUNT()
                FROM X7S_Event_RSVP__c
                WHERE User__c = :UserInfo.getUserId()
                AND Event__c = :EventId AND Event__r.NetworkId__c = :communityId
                LIMIT 1
        ] > 0 ? true : false;
    }

    @AuraEnabled
    public static Decimal getRSVPAttendeeCount(Id eventId) {
        X7S_Event__c[] events = [SELECT Id, Number_of_Attendees__c FROM X7S_Event__c WHERE Id = :eventId WITH SECURITY_ENFORCED ];

        return (events.size() > 0) ? events[0].Number_of_Attendees__c : 0;
    }

    @AuraEnabled
    public static List<String> getEventsPicklist(String fieldName, String searchString) {
        List<String> values = new List<String>();

        Integer recordLimit = DEFAULT_LIST_SIZE;
        String fieldString = 'e.' + nameSpace + fieldName;

        String queryStart = 'SELECT ' + fieldString;
        String queryEnd = '';

        queryStart += ' location,';
        queryStart += ' COUNT_DISTINCT(e.Id)';
        queryStart += ' FROM ';
        queryStart += nameSpace + 'X7S_Event__c e';

        if (String.isNotBlank(searchString)) {
            queryStart += ' WHERE (' + fieldString;
        }

        queryEnd += ' GROUP BY ' + fieldString;
        queryEnd += ' LIMIT ' + recordLimit;

        List<AggregateResult> results;

        if (String.isNotBlank(searchString)) {
            results = Database.query(String.escapeSingleQuotes(queryStart) +
                    ' LIKE \'%' + String.escapeSingleQuotes(searchString) +
                    '%\')' + String.escapeSingleQuotes(queryEnd)
            );
        } else {
            results = Database.query(String.escapeSingleQuotes(queryStart + queryEnd));
        }

        for (AggregateResult ar : results) {
            String entry = (String) ar.get('location');

            if (String.isNotBlank(entry)) {
                values.add(entry);
            }
        }

        return values;
    }

    @AuraEnabled
    public static List<String> getEventTypeList() {
        return buildPicklistValues('X7S_Event__c', 'Event_Type__c');
    }

    private static List<String> buildPicklistValues(String objName, String fieldName) {
        List<String> options = new List<String>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(nameSpace + objName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(nameSpace + fieldName).getDescribe().getPicklistValues();

        for (Schema.PicklistEntry a : values) {
            options.add(a.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static List<String> getPicklistValues(String objName, String fieldName) {
        return null;
    }

    @AuraEnabled
    public static List<String> getEventPickList(String fieldName, String searchString) {
        List<String> values = new List<String>();

        String queryStart = 'SELECT e.';
        String queryEnd = '';

        queryStart += nameSpace + fieldName;
        queryStart += ' c, ';
        queryStart += ' COUNT_DISTINCT(e.Id)';
        queryStart += ' FROM ';
        queryStart += nameSpace + 'X7S_Event__c e';

        if (String.isNotBlank(searchString)) {
            queryStart += ' WHERE (' + fieldName;
        }

        queryEnd += ' GROUP BY ' + fieldName;
        queryEnd += ' LIMIT ' + 100;

        List<AggregateResult> results;

        if (String.isNotBlank(searchString)) {
            results = Database.query(String.escapeSingleQuotes(queryStart) +
                    ' LIKE \'%' + String.escapeSingleQuotes(searchString) +
                    '%\')' + String.escapeSingleQuotes(queryEnd)
            );
        } else {
            results = Database.query(String.escapeSingleQuotes(queryStart + queryEnd));
        }


        for (AggregateResult ar : results) {
            String entry = (String) ar.get('c');

            if (String.isNotBlank(entry)) {
                values.add(entry);
            }
        }

        return values;
    }

    public static Map<String, String> getCustomFieldTypes(String customFields) {
        Map<String, String> fieldTypeMap = new Map<String, String>();

        Map<String, Schema.SObjectType> publicDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = publicDescribe.get(nameSpace + 'X7S_Event__c');
        Schema.DescribeSObjectResult objectDescribeResult = objectType.getDescribe();
        Map<String, Schema.SObjectField> objectFieldMap = objectDescribeResult.fields.getMap();

        for (String field : getCustomFields(customFields)) {
            Schema.SObjectField objectField = objectFieldMap.get(nameSpace + field);
            Schema.DescribeFieldResult fieldDescription = objectField.getDescribe();

            fieldTypeMap.put(field, fieldDescription.getType().name());
        }

        return fieldTypeMap;
    }

    /**
	 * Method to attach attachment to Event
	 *
	 * @param eventId Event Id
	 * @param attachmentType Attachment Type
	 * @param attachmentName Image attachment file name
	 * @param image Featured image as a binary64 encoded string
	 *
	 * @return Attachment Object
	 */
    @AuraEnabled
    public static Attachment updateImage(String eventId, String attachmentType, String attachmentName, String image) {
        System.debug('updateImage( ' + attachmentName + ')');

        try {
            if (Attachment.SObjectType.getDescribe().isAccessible() &&
                    Attachment.SObjectType.getDescribe().isCreateable() &&
                    Schema.SObjectType.Attachment.fields.ParentId.isCreateable() &&
                    Schema.SObjectType.Attachment.fields.Body.isCreateable() &&
                    Schema.SObjectType.Attachment.fields.ContentType.isCreateable() &&
                    Schema.SObjectType.Attachment.fields.Name.isCreateable()
                    ) {
                if (String.isNotEmpty(image) && String.isNotEmpty(attachmentType) && String.isNotEmpty(attachmentName)) {
                    Attachment attachment = new Attachment();
                    attachment.Body = EncodingUtil.base64Decode(image);
                    attachment.Name = String.valueOf(('' + attachmentName));
                    attachment.ParentId = eventId;
                    attachment.ContentType = attachmentType;
                    insert attachment;
                    return attachment;
                }
            }
            return null;
        } catch (Exception ex) {
            System.debug('Error :' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());
            return null;
        }
    }

    /**
	 * Method to save and link related file to event
	 *
	 * @param eventId Event Id
	 * @param attachmentName Image attachment file name
	 * @param image Featured image as a binary64 encoded string
	 *
	 * @return Newly created ContentDocumentLink object
	 */
    @AuraEnabled
    public static ContentDocumentLink saveRelatedFile(String eventId, String attachmentName, String image) {
        if (String.isNotEmpty(eventId) && String.isNotEmpty(image) && String.isNotEmpty(attachmentName)) {
            try {
                if(ContentVersion.SObjectType.getDescribe().isCreateable() &&
                    Schema.SObjectType.ContentVersion.fields.Title.isCreateable() &&
                    Schema.SObjectType.ContentVersion.fields.PathOnClient.isCreateable() &&
                    Schema.SObjectType.ContentVersion.fields.ContentLocation.isCreateable() &&
                    Schema.SObjectType.ContentVersion.fields.VersionData.isCreateable() && 
                    ContentDocumentLink.SObjectType.getDescribe().isCreateable() &&
                    Schema.SObjectType.ContentDocumentLink.fields.ContentDocumentId.isCreateable() &&
                    Schema.SObjectType.ContentDocumentLink.fields.LinkedEntityId.isCreateable() &&
                    Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable() &&
                    Schema.SObjectType.ContentDocumentLink.fields.Visibility.isCreateable()) {

                    List<ContentVersion> contentVersions = new List<ContentVersion>();

                    ContentVersion content = new ContentVersion();

                    content.Title = attachmentName;
                    content.PathOnClient = '/' + attachmentName;
                    content.ContentLocation = 'S';
                    content.VersionData = EncodingUtil.base64Decode(image);
                    
                    insert content;

                    // link to the Event record
                    ContentVersion insertedContent = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id];

                    ContentDocumentLink relatedLink = new ContentDocumentLink();
                    
                    relatedLink.ContentDocumentId = insertedContent.ContentDocumentId;
                    relatedLink.LinkedEntityId = eventId;
                    relatedLink.ShareType = 'I';
                    relatedLink.Visibility = 'AllUsers';
                    insert relatedLink;
                    
                    ContentDocumentLink docLink = [SELECT LinkedEntityId,ContentDocument.LatestPublishedVersionId 
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId = :eventId AND 
                                                    ContentDocumentId = :relatedLink.ContentDocumentId
                                                    LIMIT 1];
                    X7S_Event__c event = [SELECT Id,Image_Reference__c FROM X7S_Event__c WHERE Id = :eventId LIMIT 1];
                    
                    if(event.Id != null && docLink.ContentDocument.LatestPublishedVersionId != null && X7S_Event__c.SObjectType.getDescribe().isUpdateable() &&
                        Schema.SObjectType.X7S_Event__c.fields.Image_Reference__c.isUpdateable()) {
                        event.Image_Reference__c = docLink.ContentDocument.LatestPublishedVersionId;
                        update event;
                    }
                    return relatedLink;
                } 
                return null;
            } catch (Exception ex) {
                System.debug('Error in saveRelatedFile():' + ex.getMessage() + ',Line number : ' + ex.getLineNumber());
                return null;
            }
        }
        return null;
    }

    // CURRENT USER
    @AuraEnabled
    public static User getCurrentUser() {
        return [SELECT Id, Name, CommunityNickname,LanguageLocaleKey,UserType FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }

    public static Boolean useLanguage() {
        Boolean useMultiLanguage = false;

        try {
            X7S_Events_Setting__mdt setting = [SELECT Enable_Multi_Language__c FROM X7S_Events_Setting__mdt WHERE DeveloperName = 'Default'  ]; // NOPMD
            useMultiLanguage = setting.Enable_Multi_Language__c;
        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, 'X7S_Events_Setting__mdt not configured for Enable_Multi_Language__c');
        }

        return useMultiLanguage;

    }

    @AuraEnabled(Cacheable=true)
    public static String getLanguage() {
        String userLanguage;
        try {
            if (useLanguage()) {
                User currentUser = getCurrentUser();
                if (String.isNotBlank(currentUser.LanguageLocaleKey) && String.isNotEmpty(currentUser.LanguageLocaleKey)) {
                    userLanguage = currentUser.LanguageLocaleKey;
                    System.debug('***currentUser Name:' + currentUser.Name + '  ' + userLanguage);
                }
            }

        } catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, 'User local language not configured for translation');
        }
        return userLanguage;
    }

    public static Set<String> multiLanguageSet(List<String> eventIds, Set<String> multiLngIds) {

        Set<String> eventLanguageIds = new Set<String>();

        for (String id : eventIds) {
            if (multiLngIds.contains(id)) {
                eventLanguageIds.add(id);
            }
        }
        return eventLanguageIds;
    }

    @AuraEnabled(Cacheable=true)
    public static Map<String, String> getLanguageOption() {

        Map<String, String> languageOpts = new Map<String, String>();
        try {
            Schema.DescribeFieldResult fieldResult = X7S_Event__c.language__c.getDescribe();
            List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry plst : pList) {
                languageOpts.put(plst.getLabel(), plst.getValue());
            }
            return languageOpts;
        } catch (Exception ex) {
            System.debug('Error Message:' + ex.getMessage() + ', Error Line:' + ex.getLineNumber());
            return null;
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // Audience Personalization
    //

    final static ConnectApi.PublishStatus CONNECT_API_PUBLISH_STATUS_DRAFT = ConnectApi.PublishStatus.Draft;
    final static ConnectApi.PublishStatus CONNECT_API_PUBLISH_STATUS_LIVE = ConnectApi.PublishStatus.Live;
    final static String DEFAULT_PUBLISH_STATUS = 'Draft';
    final static String AUDIENCE_DEFAULT = 'Default';
    final static Integer AUDIENCE_QUERY_LIMIT = 200;
    final static String TOKEN_SOBJECT_NAME = 'X7S_Event__c';
    final static String TOKEN_GROUP_NAME = 'Event Entry';

    /**
     * Check CMT record for audience checkbox
     *
     * @return Audience enabled status - true or false
     */
    @AuraEnabled(Cacheable=true)
    public static Boolean audienceEnabled() {
        Boolean enabled = false;
        try {
            X7S_Events_Setting__mdt setting = [SELECT Enable_Audience_Targeting__c FROM X7S_Events_Setting__mdt WHERE DeveloperName = 'Default'  LIMIT 1]; // NOPMD
            enabled = setting.Enable_Audience_Targeting__c;
        } catch (Exception ex) {
            System.debug('CMT audienceEnabled exception: ' + ex.getMessage());
        }

        return enabled;
    }

    /**
     * Get all defined audiences for the community
     *
     * @param networkId Community Id
     * @param searchString search by name
     *
     * @return Map of audience Ids and Names
     */
    @AuraEnabled(Cacheable=true)
    public static Map<String, String> getAudienceList(String networkId, String searchString) {
        System.debug('getAudienceList: ' + networkId);
        Map<String, String> audienceList = new Map<String, String>();

        String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
        if (String.isBlank(communityId)) {
            if (Test.isRunningTest()) {
                communityId = x7sEventsUtility.strNetworkId;
            } else {
                return audienceList;
            }
        }

        communityId = communityId.substring(0, 15);

        String query = 'SELECT Id, AudienceName, ContainerId, DeveloperName FROM Audience WHERE ContainerId = :communityId ';
        if (String.isNotBlank(searchString)) {
            query += ' AND AudienceName LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\'';
        }
        query += ' ORDER BY AudienceName LIMIT :AUDIENCE_QUERY_LIMIT';

        List<Audience> audiences = Database.query(String.escapeSingleQuotes(query));

        for (Audience audience : audiences) {
            System.debug('    adding: ' + audience.AudienceName + '\t[' + audience.Id + ']');
            if (audience.AudienceName != AUDIENCE_DEFAULT) {
                audienceList.put(audience.Id, audience.AudienceName);
            }
        }

        System.debug('getAudienceList: ' + audienceList);

        return audienceList;
    }

    /**
     * Assign the item to an audience
     *
     * @param audienceId Selected Audience is
     * @param recordId record Id
     * @param networkId Community ID
     *  NOTE: networkId must be provided as the future method do not have access to NetWork
     */
    @Future
    public static void assignAudienceToRecord(String audienceId, String recordId, String networkId) {
        System.debug('assignAudienceToRecord: ' + audienceId + ', ' + recordId + ', ' + networkId);

        ConnectApi.TargetCollectionInput inputCollection = new ConnectApi.TargetCollectionInput();
        List<ConnectApi.TargetInput> targetInputList = new List<ConnectApi.TargetInput>();
        ConnectApi.TargetInput targetInput = new ConnectApi.TargetInput();

        targetInput.audienceId = audienceId.substring(0, 15);
        targetInput.groupName = TOKEN_GROUP_NAME;
        targetInput.publishStatus = CONNECT_API_PUBLISH_STATUS_LIVE;
        targetInput.targetType = EVENT_OBJECT_NAME;
        targetInput.targetValue = recordId.substring(0, 15);

        targetInputList.add(targetInput);

        inputCollection.targets = targetInputList;
        System.debug('input' + inputCollection);

        // Add as LIVE
        ConnectApi.TargetCollection targetOutput = ConnectApi.Personalization.createTargets(networkId.substring(0, 15), inputCollection);

        // Add as DRAFT
        for (ConnectApi.TargetInput input : inputCollection.targets) {
            input.publishStatus = CONNECT_API_PUBLISH_STATUS_DRAFT;
        }

        targetOutput = ConnectApi.Personalization.createTargets(networkId.substring(0, 15), inputCollection);


        System.debug('assignAudienceToRecord' + targetOutput);
    }

    /**
     * Remove the item from the audience
     *
     * @param recordId record Id
     */
    @AuraEnabled
    public static void deleteCurrentAudience(String recordId) {
        deleteAudienceRecord(System.Network.getNetworkId(), recordId);
    }

    /**
     * Remove the item from the audience
     *
     * @param networkId Community Id
     * @param recordId record Id
     * NOTE: networkId must be provided as the future method do not have access to NetWork
     */
    @Future
    public static void deleteAudienceRecord(String networkId, String recordId) {
        if (String.isNotBlank(recordId)) {
            System.debug('Delete audience for record: ' + recordId);
            String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
            if (String.isBlank(communityId)) {
                if (Test.isRunningTest()) {
                    communityId = x7sEventsUtility.strNetworkId;
                } else {
                    return;
                }
            }

            List<String> targets = getTargetsForRecordId(communityId, recordId);

            if (targets.size() > 0) {
                System.debug('Found targets to delete: ' + targets);
                for (String target : targets) {
                    System.debug('    Deleting : ' + target);
                    ConnectApi.Personalization.deleteTarget(communityId.substring(0, 15), target.substring(0, 15));
                }
            }
        }
    }

    public static List<String> getAudienceTargetIds(String networkId) {
        List<String> targetIds = new List<String>();
        List<String> targetTypes = new List<String>{
                TOKEN_SOBJECT_NAME
        };
        List<String> groupTypes = new List<String>{
                TOKEN_GROUP_NAME
        };
        Boolean includeAudience = true;
        Boolean includeInGroups = true;

        String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;

        if (String.isBlank(communityId)) {
            if (Test.isRunningTest()) {
                communityId = x7sEventsUtility.strNetworkId;
            } else {
                return targetIds;
            }
        }

        System.debug('getAudienceTargetIds - networkId: ' + communityId);
        ConnectApi.TargetCollection targetCollection = ConnectApi.Personalization.getTargets(
                communityId.substring(0, 15),
                null,
                null,
                null,
                CONNECT_API_PUBLISH_STATUS_DRAFT,
                null,
                targetTypes,
                includeAudience,
                includeInGroups,
                groupTypes
        );

        System.debug('targetCollection: ' + targetCollection);
        System.debug('targets: ' + targetCollection.targets);

        for (ConnectAPi.Target target : targetCollection.targets) {
            System.debug('Adding ' + target);
            targetIds.add(target.targetValue);
        }

        System.debug('targetIds: ' + targetIds);
        return targetIds;
    }

    /**
     * Get the audience Id for the specified record
     *
     * @param networkId Community ID
     * @param recordId Item record Id
     *
     * @return Audience id
     */
    @AuraEnabled
    public static String getAudienceIdForRecordId(String networkId, String recordId) {
        String audienceId = '';
        ConnectApi.Target target = getTarget(networkId, recordId);

        if (target != null) {
            audienceId = ((ConnectApi.AudienceTarget) target.audience).id;
        }

        return audienceId;
    }

    public static List<String> getTargetsForRecordId(String networkId, String recordId) {
        List<String> targetIds = new List<String>();

        try {

            String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;

            if (String.isBlank(communityId)) {
                if (Test.isRunningTest()) {
                    communityId = x7sEventsUtility.strNetworkId;
                } else {
                    return targetIds;
                }
            }

            String targetRecordId = recordId.substring(0, 15);
            String targetCommunity = communityId.substring(0, 15);

            List<PersonalizationTargetInfo> targets = [
                    SELECT Id, ContainerId, TargetValue, PublishStatus
                    FROM PersonalizationTargetInfo
                    WHERE ContainerId = :targetCommunity AND TargetValue = :targetRecordId
                    WITH SECURITY_ENFORCED
                    ORDER BY PublishStatus DESC
                    LIMIT :AUDIENCE_QUERY_LIMIT
            ];

            if (targets.size() > 0) {
                for (PersonalizationTargetInfo target : targets) {
                    targetIds.add(target.Id);
                }
            }
        } catch (Exception e) {
            System.debug('getTargetsForRecordId(): ' + e.getMessage() + ' line number: ' + e.getLineNumber());
        }

        return targetIds;
    }

    public static ConnectAPi.Target getTarget(String networkId, String recordId) {
        ConnectApi.Target target = null;
        try {
            String communityId = String.isBlank(networkId) ? System.Network.getNetworkId() : networkId;
            String targetValue = String.isNotBlank(recordId) ? recordId.substring(0, 15) : null;

            List<PersonalizationTargetInfo> targetInfos = [
                    SELECT Id, DraftRowId, ContainerId, TargetType, TargetValue, GroupName, PublishStatus
                    FROM PersonalizationTargetInfo
                    WHERE TargetValue = :targetValue AND ContainerId = :communityId
                    WITH SECURITY_ENFORCED
            ];

            if (targetInfos.size() > 0) {
                String targetId = targetInfos[0].Id;

                target = ConnectApi.Personalization.getTarget(communityId, targetId);

                System.debug('Found target for recordId :'
                        + target.id
                        + ' audience: (' + ((ConnectApi.AudienceTarget) target.audience).id + ') '
                        + ((ConnectApi.AudienceTarget) target.audience).audienceName);
            }
        } catch (Exception e) {
            System.debug('getTarget() : ' + e.getMessage() + ' line number: ' + e.getLineNumber());
        }


        return target;
    }
}