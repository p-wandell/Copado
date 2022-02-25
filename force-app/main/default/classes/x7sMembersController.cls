/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
 * Members controller class
 * Retrieves data for the front end components.
 */
@SuppressWarnings('PMD.ExcessiveClassLength')
global without sharing class x7sMembersController {

    global static Id networkId = System.Network.getNetworkId();

    global static final Integer STANDARDSETLIMIT = 10000;
    global static final Integer SOQlMAXROWLIMIT = 10000;
    global static final Integer INTLISTLIMIT = 1000;
    global static final Integer INTLISTSIZE = 50;
    global static final Integer INTPAGENUMBER = 1;
    global static final Integer INTLIMITMEMBERSRECORDS = 8;
    private static Boolean isInternalUser = UserInfo.getUserType() == 'Standard';
    private static Boolean isGuestUser = UserInfo.getUserType() == 'Guest';
    private static Boolean isExternalUser = !isInternalUser && !isGuestUser;


    // List of member to exclude from Count and List
    private static List<String> excludedIds {
        get;
        set;
    }

    // List of members that I follow
    private static Set<String> membersFollowed {
        get;
        set;
    }
    // List of members that I follow
    private static Set<String> featureIds {
        get;
        set;
    }

    // List of Knowledgeable Members
    private static Set<String> topicMembers {
        get;
        set;
    }

    private static Boolean hideInternalMembers {
        get;
        set;
    }

    @TestVisible
    private static List<String> customFieldList {
        get;
        set;
    }


    /* ---------------------------------------------------------------------------------
     * Public methods
     * ---------------------------------------------------------------------------------
     */

    /**
     * Get a count of all the members
     *
     * @param excludeList exclude the specified members from the result set
     *
     * @return Count of members found
     */
    @AuraEnabled
    global static Decimal getMemberCountEx(List<String> excludeList) {
        setExcludedIds(excludeList);

        return getMemberCount();
    }

    /*
        @Name           : getMemberCount
        @Description    : Get the exact member count (not limited by the StandardSetController)
    */
    @AuraEnabled
    global static Decimal getMemberCount() {
        Decimal recordCount = 0;

        String memberQuery = 'SELECT COUNT(Id) entityCount FROM NetworkMember n WHERE NetworkId = :networkId AND n.Member.IsActive = TRUE';

        if (membersFollowed != null) {
            memberQuery += ' AND n.Member.Id IN (' + getMemberIdList(membersFollowed) + ')';
        }

        if (topicMembers != null) {
            memberQuery += ' AND n.Member.Id IN (' + getMemberIdList(topicMembers) + ')';
        }

        if (excludedIds != null) {
            memberQuery += ' AND n.Member.Id NOT IN (' + getExcludedList() + ')';
        }

        if (featureIds != null) {
            memberQuery += ' AND n.Member.Id IN (' + getMemberIdList(featureIds) + ')';
        }

        // PMD -- verified all strings are escaped.
        for (AggregateResult result : Database.query(memberQuery)) {   //NOPMD
            recordCount += (Decimal) result.get('entityCount');
        }

        System.debug('getMemberCount global - aggregate call = ' + recordCount);
        return recordCount;
    }

    private static Decimal getMemberCount(String searchString, Set<String> featureIds) {
        Decimal recordCount = 0;

        String recordQuery = 'SELECT COUNT(ID) entityCount  FROM NetworkMember n';
        recordQuery += getWhereClause(searchString, featureIds);

        // PMD all strings escaped for query.
        for (AggregateResult result : Database.query(recordQuery)) {  //NOPMD
            recordCount += (Decimal) result.get('entityCount');
        }

        System.debug('getMemberCount private - aggregate call = ' + recordCount);

        return recordCount;
    }

//  Member List
    @AuraEnabled
    global static x7sMembersWrapper getMemberList(
            Decimal pageSize,
            Decimal currentPage,
            String sortBy,
            String searchMyMembers,
            String searchString,
            List<String> excludeList,
            List<String> featureIds) {

        hideInternalMembers = false;
        setExcludedIds(excludeList);

        return getMemberList(pageSize, currentPage, sortBy, searchMyMembers, searchString, featureIds);
    }

    @AuraEnabled
    global static x7sMembersWrapper getMemberList(
            Decimal pageSize,
            Decimal currentPage,
            String sortBy,
            String searchMyMembers,
            String searchString,
            String topicId,
            List<String> excludeList,
            List<String> featureIds) {

        hideInternalMembers = false;
        System.debug('Hide internal members = ' + hideInternalMembers);

        setExcludedIds(excludeList);

        if (!setTopicMembers(topicId)) {
            return new x7sMembersWrapper();
        }

        return getMemberList(pageSize, currentPage, sortBy, searchMyMembers, searchString, featureIds);
    }

    // called by Member_ListHelper
    @AuraEnabled
    global static x7sMembersWrapper getMemberList(
            Decimal pageSize,
            Decimal currentPage,
            String sortBy,
            String searchMyMembers,
            String searchString,
            String topicId,
            Boolean hideInternal,
            List<String> excludeList,
            List<String> featureIds) {

        hideInternalMembers = hideInternal;
        System.debug('Hide internal members = ' + hideInternalMembers);

        setExcludedIds(excludeList);

        if (!setTopicMembers(topicId)) {
            return new x7sMembersWrapper();
        }

        return getMemberList(pageSize, currentPage, sortBy, searchMyMembers, searchString, featureIds);
    }

    @AuraEnabled
    global static x7sMembersWrapper getMemberListC(
            Decimal pageSize,
            Decimal currentPage,
            String sortBy,
            String searchMyMembers,
            String searchString,
            String topicId,
            Boolean hideInternal,
            List<String> excludeList,
            List<String> customFields,
            List<String> featureIds) {

        hideInternalMembers = hideInternal;
        System.debug('Hiding internal members = ' + hideInternalMembers);

        setExcludedIds(excludeList);

        if (!setTopicMembers(topicId)) {
            return new x7sMembersWrapper();
        }

        System.debug('Getting custom fields:' + customFields);
        setCustomFields(customFields);

        return getMemberList(pageSize, currentPage, sortBy, searchMyMembers, searchString, featureIds);
    }

    public static x7sMembersWrapper getMemberList(
            Decimal pageSize,
            Decimal currentPage,
            String sortBy,
            String searchMyMembers,
            String searchString,
            List<String> featureIds) {
        System.debug('getMemberList(pagesize: ' + pageSize + ', currentPage: ' + currentPage + ')');

        x7sMembersWrapper model = new x7sMembersWrapper();

        try {
            Decimal searchOffset = currentPage <= 1 ? 0 : pageSize * (currentPage - 1);
            Integer recordLimit = (Integer) pageSize;
            Integer recordOffset = (Integer) searchOffset;

            // Check whether the Member I Follow is checked or not - searchMyMembers == '' if not
            if (!String.isEmpty(searchMyMembers)) {
                membersFollowed = getSubscriptionId();

                if (membersFollowed.size() == 0) {
                    return model;
                }
            }

            // add to a set to eliminate duplicates
            Set<String> listIds = new Set<String>();
            if (featureIds != null) {
                for (String s : featureIds) {
                    listIds.add(s);
                }
            }

            // this will fail for very large communities (50,000+)
            Decimal total = getMemberCount(searchString, listIds);

            // we have reached the SOQL limit
            if ((Integer) total == SOQlMAXROWLIMIT - 1) {
                // tell the Aura component we have hit the limit
                model.totalResults = -1;
            } else {
                model.totalResults = (Integer) total;
            }

//            System.debug('getMemberCount = ' + total);

            if (total > 0 && pageSize > 0) {
                model.pageNumber = (Integer) currentPage;
                model.totalPages = (Integer) Math.max(Math.ceil(total / pageSize), 1);

                if (Math.mod((Integer) total, (Integer) pageSize) > 0) {
                    model.totalPages += 1;
                }
            }

            String Query = getSelectClause();
            Query += getFromClause();
            Query += getWhereClause(searchString, listIds);

            if (sortBy == 'Sort by Last Name') {
                Query += ' ORDER BY n.Member.LastName';
            } else if (sortBy == 'Sort by First Name') {
                Query += ' ORDER BY n.Member.FirstName';
            } else if (sortBy == 'Date Joined Oldest') {
                Query += ' ORDER BY n.Member.CreatedDate';
            } else if (sortBy == 'Date Joined Newest') {
                Query += ' ORDER BY n.Member.CreatedDate DESC';
            }

            Query += ' LIMIT ' + recordLimit;
            Query += ' OFFSET ' + recordOffset;

//            System.debug('Controller qry: ' + Query);

            // PMD all strings escaped.
            List<NetworkMember> members = (List<NetworkMember>) Database.query(Query); //NOPMD

            for (NetworkMember member : members) {
                model.membersList.add(member.Member);
            }

            model.updateWrapperContent(model.membersList);
            model.listSizeValue = recordLimit;
            model.totalResults = (Integer) total;
            model.totalPages = Math.max((Integer) Math.ceil(total / recordLimit), 1);
            model.hasNextSet = (recordLimit * currentPage) < total;
            model.hasPreviousSet = searchOffset > 0;

        } catch (Exception e) {
            System.debug('MemberController Exception getMembersList: ' + e.getMessage());
            return null;
        }

        return model;
    }

    @AuraEnabled
    global static List<String> getMemberPicklist(String fieldName, String searchString) {
        x7sMembersFilters filterSet = new x7sMembersFilters();

        List<String> values = new List<String>();
        Integer recordLimit = (Integer) filterSet.PickList_Limit;
        String fieldString = 'n.Member.' + String.escapeSingleQuotes(fieldName);


        // check if we have filter defined in Custom Metadata
        if (filterSet.filters.size() > 0) {
            X7S_Members_Filter_Item__mdt filter = filterSet.getFilterByFieldName(fieldName);

            if (filter != null) {
                System.debug('Loading picklist from ' + filter.DeveloperName);
                values = filterSet.getFilterValues(fieldName, searchString);

                if (values.size() > 0) {
                    return values;
                }
            }
        }

        //Other wise we build from the data
//        System.debug('Loading picklist from data....');
        String query = 'SELECT ';

        query += fieldString;
        query += ' c, ';
        query += ' COUNT_DISTINCT(n.Member.Id)';
        query += ' FROM NetworkMember n';
        query += ' WHERE n.Member.IsActive = TRUE';

        if (String.isNotBlank(searchString)) {
            query += ' AND (' + fieldString + ' LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\')';
        }

        query += ' GROUP BY ' + fieldString;
        query += ' LIMIT ' + recordLimit;

        // PMD all strings escaped.
        List<AggregateResult> results = Database.query(query);  // NOPMD

        for (AggregateResult ar : results) {
            String entry = (String) ar.get('c');

            if (String.isNotBlank(entry)) {
                values.add(entry);
            }
        }

        return values;
    }

    private static void setExcludedIds(List<String> excludeList) {
        if (excludeList != null) {
            excludedIds = new List<String>();

            // Ignore blank IDs
            for (String i : excludeList) {
                if (String.isNotBlank(i)) {
                    excludedIds.add(i);
                }
            }
        }
    }

    /*
        @Name        : getMemberIdList
        @Description : Return a comma delimited list of member IDs
     */
    @TestVisible
    private static String getMemberIdList(Set<String> memberList) {
        String followList = '';
        Integer followPos = 0;

        for (String i : memberList) {
            if (String.isNotBlank(i)) {
                followList += '\'' + String.escapeSingleQuotes(i) + '\'';
                followPos += 1;

                if (followPos < memberList.size()) {
                    followList += ', ';
                }
            }
        }

        return followList;
    }

    /*
        @Name        : getExcludedList
        @Description : Return a comma delimited list of member IDs to exclude
     */
    private static String getExcludedList() {
        String idList = '';
        Integer pos = 0;

        for (String i : excludedIds) {
            if (String.isNotBlank(i)) {
                idList += '\'' + String.escapeSingleQuotes(i) + '\'';
                pos += 1;

                if (pos < excludedIds.size()) {
                    idList += ', ';
                }
            }
        }

        return idList;
    }

    private static Boolean setTopicMembers(String topicId) {
        if (String.isNotBlank(topicId)) {
            Integer recordLimit = INTLISTLIMIT;
            topicMembers = new Set<String>();

            for (KnowledgeableUser user : [
                    SELECT UserId, TopicId, RawRank, NetworkId
                    FROM KnowledgeableUser
                    WHERE NetworkId = :networkId AND TopicId = :topicId
                    LIMIT :recordLimit
            ]) {
                topicMembers.add(user.UserId);
            }

            return topicMembers != null && topicMembers.size() > 0;
        }

        return true;
    }

    @TestVisible
    private static void setCustomFields(List<String> customFields) {
        System.debug('Setting custom fields');

        if (customFields != null) {
            customFieldList = new List<String>();

            for (String i : customFields) {
                if (String.isNotBlank(i)) {
                    customFieldList.add(i);
                }
            }
        }
    }

    private static String getSelectClause() {
        String selectClause = 'SELECT n.Member.Id'
                + ', n.Member.Name'
                + ', n.Member.CommunityNickname'
                + ', n.Member.Email'
                + ', n.Member.Title'
                + ', n.Member.Phone'
                + ', n.Member.CreatedDate'
                + ', n.Member.FullPhotoUrl'
                + ', n.Member.UserPreferencesShowTitleToExternalUsers'
                + ', n.Member.UserPreferencesShowTitleToGuestUsers'
                + ', n.Member.UserPreferencesShowMobilePhoneToExternalUsers'
                + ', n.Member.UserPreferencesShowMobilePhoneToGuestUsers'
                + ', n.Member.UserPreferencesShowEmailToExternalUsers'
                + ', n.Member.UserPreferencesShowCountryToExternalUsers'
                + ', n.Member.UserPreferencesShowCountryToGuestUsers'
                + ', n.Member.UserPreferencesShowEmailToGuestUsers';

        if (customFieldList != null) {
//            System.debug('Adding custom fields: ');
            for (String f : customFieldList) {
//                System.debug('    field: ' + f);
                selectClause += ', n.Member.' + String.escapeSingleQuotes(f);
            }
        }
        return selectClause;
    }

    private static String getFromClause() {
        return ' FROM NetworkMember n';
    }

    global static final String SEARCH_FIELD_SEPARATOR = '';
    global static final String SEARCH_SEPARATOR = ';';
    global static final String FIELD_SEPARATOR = ',';
    private static final String SEARCH_FIELD = ':';

    // Use a search pattern, based on field names specified in the builder
    //      searchString:field1,..field[n];memberField1:value1;memberField2:value2;
    //  where:
    //      searchString = search string
    //      memberField[n] = Member.Contact Field
    //      value[n] = Member.Contact.Field[n] value
    // and
    //      field1 to n are additional member object search fields for the searchString
    //
    // example:  apple:phone,email;MailingCountry:US;MailingCity:New York;
    //  search for 'apple' in Name, phone, email AND country == US, city == New York

    public static String getWhereClause(String searchString, Set<String> featureIds) {
        String whereClause = ' WHERE n.Member.IsActive=TRUE AND NetworkId = \'' + networkId + '\'';

        if (featureIds != null && featureIds.size() > 0) {
            whereClause += ' AND n.Member.Id IN (' + getMemberIdList(featureIds) + ')';
        }
        if (hideInternalMembers != null && hideInternalMembers) {
            whereClause += ' AND n.Member.UserType != \'Standard\'';
        }

        // Check whether the Member I Follow is checked or not - searchMyMembers == '' if not
        if (membersFollowed != null && membersFollowed.size() > 0) {
            whereClause += ' AND n.Member.Id IN (' + getMemberIdList(membersFollowed) + ')';
        }

        if (topicMembers != null) {
            whereClause += ' AND n.Member.Id IN (' + getMemberIdList(topicMembers) + ')';
        }

        if (excludedIds != null && excludedIds.size() > 0) {
            whereClause += ' AND n.Member.Id NOT IN (' + getExcludedList() + ')';
        }

        if (searchString != null && searchString.trim().length() > 0) {
            System.debug('searchString===' + searchString);
            if (searchString.indexOf(SEARCH_SEPARATOR) != -1) {
                List<String> searchParts = searchString.split(SEARCH_SEPARATOR);

                String nameSearch = searchParts[0];
                List <String> nameParts = nameSearch.split(SEARCH_FIELD);

                if (nameParts.size() > 0 && String.isNotBlank(nameParts[0])) {
                    String searchPart = nameParts[0];

                    whereClause += ' AND (n.Member.Name'
                            + ' LIKE \'%'
                            + String.escapeSingleQuotes(String.valueOf(searchPart))
                            + '%\'';

                    if (nameParts.size() > 1 && String.isNotBlank(nameParts[1])) {
                        List<String> parts = nameParts[1].split(FIELD_SEPARATOR);

                        if (parts.size() > 0) {
                            for (String part : parts) {
                                whereClause += ' OR n.Member.' + part.trim()
                                        + ' LIKE \'%'
                                        + String.escapeSingleQuotes(String.valueOf(searchPart))
                                        + '%\'';
                            }
                        }
                    }
                    whereClause += ')';
                }

                // additional member search fields
                // escape the ' character in last names (ex. O'Leary)
                for (Integer i = 1; i < searchParts.size(); i++) {
                    if (searchParts[i].indexOf(SEARCH_FIELD) != -1) {
                        String fieldName = searchParts[i].substringBefore(SEARCH_FIELD);
                        String fieldValue = searchParts[i].substringAfter(SEARCH_FIELD);

                        whereClause += ' AND n.Member.'
                                + fieldName.trim()
                                + ' LIKE \'%'
                                + String.escapeSingleQuotes(fieldValue)
                                + '%\'';

                        //if filter is on country then check if user wants to expose the country to other users
                        if (fieldName.contains('Country')) {
                            if (isGuestUser) {
                                whereClause += ' AND  n.Member.UserPreferencesShowCountryToGuestUsers = TRUE';
                            } else if (isExternalUser) {
                                whereClause += ' AND  n.Member.UserPreferencesShowCountryToExternalUsers  = TRUE';
                            }

                        }
                    }
                }
            } else {
                whereClause += ' AND (n.Member.Name'
                        + ' LIKE \'%'
                        + String.escapeSingleQuotes(String.valueOf(searchString))
                        + '%\')';
            }
        }


        return whereClause;
    }

    /////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    global static x7sMembersWrapper getMembersEx(
            Integer numberOfMembers,
            String sortBy,
            String searchMyMembers,
            String searchString,
            List<String> excludeList) {

        setExcludedIds(excludeList);

        return getMembers(numberOfMembers, sortBy, searchMyMembers, searchString);
    }

    @AuraEnabled
    global static x7sMembersWrapper getMembers(
            Integer numberOfMembers,
            String sortBy,
            String searchMyMembers,
            String searchString) {
        try {
            //changed user to NetworkMember
            //List<User> memberList = new List<User>();

            // excluded ids
            //Set<String> excluded = new Set<String>();

            // Set used for store the userId's
            Set<String> setUserId = new Set<String>();

            Integer intLimit = Integer.valueOf(numberOfMembers);

            String Query = getQueryString();

            // Check whether the Member I Follow is chcked or not
            if (!String.isEmpty(searchMyMembers)) {
                if (searchMyMembers == 'Members I Follow') {
                    setUserId = getSubscriptionId();
                }

                // Add the query for Member I follow feature
                Query += 'AND Id IN :setUserId';
            }

            if (excludedIds != null && excludedIds.size() > 0) {
                String idList = '';
                Integer pos = 0;

                // Ignore blank IDs
                for (String i : excludedIds) {
                    if (String.isNotBlank(i)) {
                        idList += '\'' + i + '\'';
                        pos += 1;

                        if (pos < excludedIds.size()) {
                            idList += ', ';
                        }
                    }
                }

                Query += ' AND Id NOT IN (' + idList + ')';
            }

            if (!String.isEmpty(Query)) {
                // Check for searching feature
                if (searchString != null && searchString.trim().length() > 0) {
                    Query += ' And ( Name LIKE \'%' + String.valueOf(searchString) + '%\')';
                }
                if (sortBy == 'Sort by Last Name') { // Condition for Sort By Last Name
                    Query += ' ORDER BY LastName';
                }
                // Condition for Sort By First Name
                else if (sortBy == 'Sort by First Name') {

                    Query += ' ORDER BY FirstName';
                }

                // StandardSetController LIMIT
                Query += ' LIMIT ' + SOQlMAXROWLIMIT;

                System.debug('Controller qry: ' + Query);

                x7sMembersWrapper membersWrapper = new x7sMembersWrapper(
                        Query,
                        intLimit,
                        null,
                        setUserId,
                        true,
                        false);

                return membersWrapper;
            }
        } catch (Exception e) {

            System.debug('***Exception ***' + e);
            return null;
        }
        return null;
    }

    /*
        @Name          :  getSubscriptionId
        @Description   :  Method used to get the subscription Id's
    */
    private static Set<String> getSubscriptionId() {
        Set<String> setUserId = new Set<String>();

        for (EntitySubscription objEntitySubscription : [
                SELECT SubscriberId, ParentId, NetworkId, Id
                FROM EntitySubscription
                WHERE SubscriberId = :UserInfo.getUserId()
                LIMIT 100
        ]) {
            setUserId.add(objEntitySubscription.ParentId);
        }

        return setUserId;
    }

    @AuraEnabled
    global static x7sMembersWrapper nextPageEx(
            Integer numberOfMembers,
            Integer pageNumber,
            String sortBy,
            String searchMyMembers,
            String searchString,
            List<String> excludeList) {
        // Excluded the following IDs from the list
        excludedIds = new List<String>();

        // Ignore blank IDs
        for (String i : excludeList) {
            if (String.isNotBlank(i)) {
                excludedIds.add(i);
            }
        }

        return nextPage(numberOfMembers, pageNumber, sortBy, searchMyMembers, searchString);
    }

    /*
        @Name          :  nextPage
        @Description   :  Method used on click of "Next" in pagination to diaplay news records as per numberOfNewsPerPage
    */
    @AuraEnabled
    global static x7sMembersWrapper nextPage(
            Integer numberOfMembers,
            Integer pageNumber,
            String sortBy,
            String searchMyMembers,
            String searchString) {

        x7sMembersWrapper objWrapperMember = membersPagination(
                numberOfMembers,
                pageNumber,
                sortBy,
                searchMyMembers,
                searchString);

        if (objWrapperMember != null) {
            objWrapperMember.nextPage();
            objWrapperMember.setController = null;

            return objWrapperMember;
        } else {
            return null;
        }
    }

    /*
    @Name          :  membersPagination
    @Description   :  Method used when click on next/previous button.
    */
    private static x7sMembersWrapper membersPagination(
            Integer numberOfMembers,
            Integer pageNumber,
            String sortBy,
            String searchMyMembers,
            String searchString) {
        //Integer listSizeValue   = numberOfMembers != null ? Integer.valueOf(numberOfMembers) : INTLISTSIZE;
        Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : INTPAGENUMBER;
        Integer intLimit = Integer.valueOf(numberOfMembers);
        String QUERY = getQueryString();

        Set<String> setUserId = new Set<String>();

        // Check whether the Member I Follow is chcked or not
        if (!String.isEmpty(searchMyMembers)) {
            if (searchMyMembers == 'Members I Follow') {
                setUserId = getSubscriptionId();
            }
            // Add the query for Member I folow feature
            QUERY += ' AND Id IN : setUserId';
        }

        if (excludedIds != null && excludedIds.size() > 0) {
            String idList = '';
            Integer pos = 0;

            // Ignore blank IDs
            for (String i : excludedIds) {
                if (String.isNotBlank(i)) {
                    idList += '\'' + i + '\'';
                    pos += 1;

                    if (pos < excludedIds.size()) {
                        idList += ', ';
                    }
                }
            }

            QUERY += ' AND Id NOT IN (' + idList + ')';
        }

        // Check for searching feature
        if (searchString != null && searchString.trim().length() > 0) {
            QUERY += ' And ( Name LIKE \'%' + String.valueOf(searchString) + '%\')';
        }

        // Condition for Sort By Last Name
        if (sortBy == 'Sort by Last Name') {
            QUERY += ' ORDER BY LastName';
        }
        // Condition for Sort By First Name
        else if (sortBy == 'Sort by First Name') {
            QUERY += ' ORDER BY FirstName';
        }

        // StandardSetController LIMIT
        QUERY += ' LIMIT ' + SOQlMAXROWLIMIT;

        if (!String.isEmpty(QUERY)) {
            x7sMembersWrapper objWrapperMember = new x7sMembersWrapper(
                    QUERY,
                    intLimit,
                    null,
                    setUserId,
                    false,
                    false);
            objWrapperMember.pageNumber = pageNumberValue;

            return objWrapperMember;
        } else {
            return null;
        }
    }

    @AuraEnabled
    global static x7sMembersWrapper previousPageEx(
            Integer numberOfMembers,
            Integer pageNumber,
            String sortBy,
            String searchMyMembers,
            String searchString,
            List<String> excludeList) {
        // Excluded the following IDs from the list
        excludedIds = new List<String>();

        // Ignore blank IDs
        for (String i : excludeList) {
            if (String.isNotBlank(i)) {
                excludedIds.add(i);
            }
        }

        return previousPage(numberOfMembers, pageNumber, sortBy, searchMyMembers, searchString);
    }

    /*
    @Name          :  previousPage
    @Description   :  Method used on click of "Previous" in pagination to diaplay news records as per numberOfNewsPerPage
    */
    @AuraEnabled
    global static x7sMembersWrapper previousPage(
            Integer numberOfMembers,
            Integer pageNumber,
            String sortBy,
            String searchMyMembers,
            String searchString) {
        x7sMembersWrapper objWrapperMember = membersPagination(
                numberOfMembers,
                pageNumber,
                sortBy,
                searchMyMembers,
                searchString);

        if (objWrapperMember != null) {
            objWrapperMember.previousPage();
            objWrapperMember.setController = null;

            return objWrapperMember;
        } else {
            return null;
        }
    }

    /*
    @Name          :  getSitePrefix
    @Description   :  Method to fetch site prefix so that urls are redirected properly dynamically in any org.
    */
    @AuraEnabled
    global static String getSitePrefix() {
        return System.Site.getPathPrefix();
    }

    /*
    @Name          :  getQueryString
    @Description   :  Method to generate dynamic query for objects used in process.
                      this method is generating query for TopicAssignment,Topic as per our requirement
    */
    public static String getQueryString() {
        String QUERY = 'SELECT Id, Name, CommunityNickname, Email, Title, Phone, CreatedDate, FullPhotoUrl'
                + ', UserPreferencesShowTitleToExternalUsers'
                + ', UserPreferencesShowTitleToGuestUsers'
                + ', UserPreferencesShowMobilePhoneToExternalUsers'
                + ', UserPreferencesShowMobilePhoneToGuestUsers'
                + ', UserPreferencesShowEmailToExternalUsers'
                + ', UserPreferencesShowCountryToExternalUsers'
                + ', UserPreferencesShowCountryToGuestUsers'
                + ', UserPreferencesShowEmailToGuestUsers'
                + ' FROM USER ';

        // Query to fetch the user on the basis of network Id
        QUERY += ' WHERE IsActive=true AND Id IN (SELECT MemberId FROM NetworkMember WHERE NetworkId = :networkId)';

        return QUERY;
    }

    /**
    @Name          :  getMetaDataMemberList
    @parameters    :  recordIds of members returned from metaData
    @Description   :  Method to fetch featured members records to show on featured components.
    **/
    @AuraEnabled(Cacheable=true)
    public static String getMetaDataMemberList(String recordLabel) {
        System.debug(recordLabel);
        X7S_Members_Setting__mdt setting = [SELECT Feature_MemberList__c FROM X7S_Members_Setting__mdt WHERE DeveloperName = :recordLabel]; //NOPMD

        return setting.Feature_MemberList__c;
    }

    /**
    @Name          :  getFeaturedMembersLwc
    @Description   :  Method to fetch featured member records to show on featured components.
    */
    @AuraEnabled
    global static x7sMembersWrapper getFeaturedMembersLwc(List<String> listNickNames, Boolean isFeature) {
        try {
            String Query = getQueryString();

            if (!String.isBlank(Query) && (isFeature == true)) {
                Query += ' AND Featured__c = true';

                x7sMembersWrapper membersWrapper = new x7sMembersWrapper(
                        Query,
                        INTLIMITMEMBERSRECORDS,
                        null,
                        null,
                        true,
                        false);

                return membersWrapper;
            }

            if (!String.isBlank(Query) &&
                    (listNickNames != null && listNickNames.size() > 0 && isFeature == false)) {
                List<String> lstMemberNickNames = new List<String>();
                Set<String> setMemberNickNames = new Set<String>();

                for (String s : listNickNames) {
                    if (String.isNotBlank(s)) {
                        setMemberNickNames.add(s);
                    }
                }

                lstMemberNickNames.addAll(setMemberNickNames);

                Query += ' AND CommunityNickname IN : lstMemberNickNames';

                x7sMembersWrapper membersWrapper = new x7sMembersWrapper(
                        Query,
                        INTLIMITMEMBERSRECORDS,
                        lstMemberNickNames,
                        null,
                        true,
                        true);

                return membersWrapper;
            }
        } catch (Exception e) {
            System.debug('*** Exception getFeaturedMembers ***' + e);
            return null;
        }

        return null;
    }

    @AuraEnabled(Cacheable=true)
    global static Map<String, String> getTopicValues() {
        return x7sMembersTopicsController.getTopics();
    }

    @AuraEnabled
    global static void followRecord(String recordId) {
        ConnectApi.ChatterUsers.follow(System.Network.getNetworkId(), UserInfo.getUserId(), recordId);
    }

    /**
        Find the EntitySubscription ID for this record and current user
     */
    @AuraEnabled
    global static void unfollowRecord(String recordId) {
        for (EntitySubscription follow : [
                SELECT Id
                FROM EntitySubscription
                WHERE NetworkId = :System.Network.getNetworkId()
                AND ParentId = :recordId AND SubscriberId = :UserInfo.getUserId()
        ]) {
            ConnectApi.Chatter.deleteSubscription(System.Network.getNetworkId(), follow.Id);
        }
    }
}