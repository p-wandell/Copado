/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesController {
    private static final String DEFAULT_NAME = 'Default';
    private final static Decimal DEFAULT_PAGE_SIZE = 10;
    private static final String X7S_ROW_CAUSE = Schema.X7S_File_Folder__Share.rowCause.X7s_Folder_Custom_Sharing__c;
    private static final String FOLDER_FILTER = 'Folder_Filter';
    private static final String CONTENT_DOCUMENT_FILTER = 'Content_Document_Filter';

    private static List<String> recId { get; set; }
    private static List<Id> fileIds { get; set; }
    private static List<Id> contIds { get; set; }
    private static List<ContentDocumentLink> entityIds { get; set; }
    //private static List<X7S_File_Folder__c> objIds { get; set; }

    // list of File Type items
    private static List<String> fileTypeIds { get; set; }

    public class FilterHelper {
        @AuraEnabled public String selectedFileTypeValue { get; set; }
        @AuraEnabled public String selectedFromDate { get; set; }
        @AuraEnabled public String selectedToDate { get; set; }
        @AuraEnabled public String selectedModFromDate { get; set; }
        @AuraEnabled public String selectedModToDate { get; set; }
        @AuraEnabled public String selectedFileSizeValue { get; set; }
        @AuraEnabled public String selectedOwnerId { get; set; }
        @AuraEnabled public String selectedModifierId { get; set; }
    }

    /**
     * Get files and folders for the specified criteria and the recordId (user, contact, account)
     *
     * @param parentFolderId Parent ID for folder to load
     * @param pageSize page size
     * @param currentPage current page number
     * @param searchString Search string
     * @param isSearchTitle search on Title
     * @param isSearchDescription search on description
     * @param isSearchContent search on content
     * @param sortString sort string
     * @param listFilterParams list of filter parameters
     * @param recordId Target record Id - show only items shared with this ID
     *
     * @return x7sFilesModel Files List Wrapper
     */
    @AuraEnabled
    public static x7sFilesModel getFilesListByRecordId(
            String parentFolderId,
            Decimal pageSize,
            Decimal currentPage,
            String searchString,
            Boolean isSearchTitle,
            Boolean isSearchDescription,
            Boolean isSearchContent,
            String sortString,
            String listFilterParams,
            String recordId
    ) {
        List<String> recordIds = getSharedRecord(recordId);
        return getFilesList(parentFolderId, pageSize, currentPage, searchString, isSearchTitle, isSearchDescription, isSearchContent, sortString, listFilterParams, recordIds);
    }

    /**
     * Get the Model data for the File list components
     *
     * @param parentFolderId Parent ID for folder to load
     * @param pageSize page size
     * @param currentPage current page number
     * @param searchString Search string
     * @param isSearchTitle search on Title
     * @param isSearchDescription search on description
     * @param isSearchContent search on content
     * @param sortString sort string
     * @param listFilterParams list of filter parameters
     *
     * @return x7sFilesListModel Files List Wrapper
     */
    @AuraEnabled
    public static x7sFilesModel getFilesList(
            String parentFolderId,
            Decimal pageSize,
            Decimal currentPage,
            String searchString,
            Boolean isSearchTitle,
            Boolean isSearchDescription,
            Boolean isSearchContent,
            String sortString,
            String listFilterParams
    ) {
        return getFilesList(parentFolderId, pageSize, currentPage, searchString, isSearchTitle, isSearchDescription, isSearchContent, sortString, listFilterParams, null);
    }

    public static x7sFilesModel getFilesList(
            String parentFolderId,
            Decimal pageSize,
            Decimal currentPage,
            String searchString,
            Boolean isSearchTitle,
            Boolean isSearchDescription,
            Boolean isSearchContent,
            String sortString,
            String listFilterParams,
            List<Id> recordIds
    ) {
        if (pageSize == null || pageSize < 1) {
            pageSize = DEFAULT_PAGE_SIZE;
        }

        if (currentPage == null || currentPage < 1) {
            currentPage = 1;
        }

        x7sFilesModel filesModel = new x7sFilesModel();

        filesModel.pageSize = pageSize;
        filesModel.pageCurrent = currentPage;

        Decimal searchOffset = pageSize * (currentPage - 1);
        String selectClause = 'SELECT Id, Name, Description__c, Sharing_Setting__c, Parent_Folder__c, CreatedDate';
        String fromClause = ' FROM X7S_File_Folder__c';
        String orderByClause = getFolderOrderByClause(sortString);
        String whereClause = getWhereClause(parentFolderId, searchString, isSearchTitle, isSearchDescription, isSearchContent, sortString, listFilterParams, recordIds);
        System.debug('getFilesList where clause: ' + whereClause);

        Decimal offset = pageSize * (currentPage - 1);

        Integer recordLimit = (Integer) pageSize;
        Integer recordOffset = (Integer) searchOffset;
        String limitClause = ' LIMIT ' + recordLimit;
        String offsetClause = ' OFFSET ' + offset;

        try {
            List<x7sFilesItemModel> displayItems = new List<x7sFilesItemModel>();
            List<x7sFilesItemModel> folderItems = new List<x7sFilesItemModel>();

            List<Id> listIds = new List<Id>();
            Decimal totalFolders = 0 ;
            Decimal TotalFiles = 0 ;
            String tempQuery = '';
            String query = '';
            contIds = new List<Id>();
            fileIds = new List<Id>();
            entityIds = new List<ContentDocumentLink>();
            Map<Id, X7S_File_Folder__c> folderMap = new Map<Id, X7S_File_Folder__c>();
            List<Id> listIds1 = new List<Id>();
            FilterHelper listFilter = String.isNotBlank(listFilterParams) ? (FilterHelper) JSON.deserialize(listFilterParams, FilterHelper.class) : new FilterHelper();
            Map<String, String> filters = getFilters(listFilterParams);
            String folderFilters = '';
            String contentDocumentFilters = '';

            if (filters.size() > 0) {
                if (filters.get(FOLDER_FILTER) != null) {
                    folderFilters = filters.get(FOLDER_FILTER);
                }

                if (filters.get(CONTENT_DOCUMENT_FILTER) != null) {
                    contentDocumentFilters = filters.get(CONTENT_DOCUMENT_FILTER);
                }
            }

            Decimal filesOffset = 0;
            Decimal availableSpots = 0;

            if (String.isNotBlank(searchString) && (isSearchDescription || isSearchTitle)) {
                query = selectClause + fromClause + whereClause + folderFilters + orderByClause + limitClause + offsetClause;
                System.debug('Folder Filters : ' + folderFilters);

                System.debug('Query for Folders: ' + query);
                folderMap = new Map<Id, X7S_File_Folder__c>((List<X7S_File_Folder__c>) Database.query(query));//NOPMD

                if (!folderMap.isEmpty()) {
                    String communityUrl = getCommunityUrl();
                    listIds.addAll(folderMap.keySet());

                    for (X7S_File_Folder__c folderItem : folderMap.values()) {
                        Id imageId;
                        folderItems.add(new x7sFilesItemModel(folderItem, communityUrl, imageId, null));
                    }

                    for (Integer index = folderItems.size() - 1; index >= 0; index--) {
                        x7sFilesItemModel itemModel = folderItems.get(index);

                        if (itemModel.Id == parentFolderId) { continue; }

                        if (displayItems.size() == 0) { displayItems.add(itemModel);
                        } else { displayItems.add(0, itemModel); }
                    }
                    totalFolders = getRecordCount(fromClause, whereClause, null);
                }
            }
            if (String.isBlank(searchString)
                    && String.isBlank(listFilter.selectedFileSizeValue)
                    && String.isBlank(listFilter.selectedFileTypeValue)
                    && String.isBlank(listFilter.selectedFromDate)
                    && String.isBlank(listFilter.selectedModFromDate)
                    && String.isBlank(listFilter.selectedModToDate)
                    && String.isBlank(listFilter.selectedModifierId)
                    && String.isBlank(listFilter.selectedOwnerId)
                    && String.isBlank(listFilter.selectedToDate)
                    ) {
                query = selectClause
                        + fromClause
                        + whereClause
                        + folderFilters
                        + orderByClause
                        + limitClause
                        + offsetClause;

                System.debug('Folder Filters (No Search) : ' + folderFilters);

                System.debug('Query for Folders: ' + query);
                folderMap = new Map<Id, X7S_File_Folder__c>((List<X7S_File_Folder__c>) Database.query(query));//NOPMD

                if (!folderMap.isEmpty()) {
                    System.debug('map not empty');
                    String communityUrl = getCommunityUrl();
                    System.debug('parentFolder Id: [' + parentFolderId + ']');

                    if (String.isNotBlank(parentFolderId)) {
                        listIds.add(parentFolderId);
                    }

                    System.debug('check folder map values');
                    for (X7S_File_Folder__c folderItem : folderMap.values()) {
                        System.debug('adding folderItem: ' + folderItem);
                        Id imageId;
                        folderItems.add(new x7sFilesItemModel(folderItem, communityUrl, imageId, null));
                    }

                    System.debug('check folder items');
                    for (Integer index = folderItems.size() - 1; index >= 0; index--) {
                        x7sFilesItemModel itemModel = folderItems.get(index);
                        System.debug('adding itemModel: ' + itemModel);

                        if (itemModel.Id == parentFolderId) { continue; }

                        if (displayItems.size() == 0) {
                            displayItems.add(itemModel);
                        } else {
                            displayItems.add(0, itemModel);
                        }
                    }

                    filesModel.files = displayItems;
                }

                totalFolders = getRecordCount(fromClause, whereClause, parentFolderId);
                TotalFiles = x7sFilesContentDocument.getRecordCount(listIds, '');
                Decimal total = totalFolders + TotalFiles;
                offset = (Integer) pageSize * (currentPage - 1);

                Integer recordLimit1 = (Integer) pageSize;
                Integer recordOffset1 = (Integer) searchOffset;
                String limitClause1 = ' LIMIT ' + recordLimit1;
                String offsetClause1 = ' OFFSET ' + (offset - (Integer) searchOffset);

                if (String.isNotBlank(parentFolderId)) {
                    listIds1.add(parentFolderId);
                }

                TotalFiles = x7sFilesContentDocument.getRecordCount(listIds1, '');
                System.debug('Content document getRec count ' + TotalFiles);

                if (folderMap.size() < pageSize && folderMap.size() != 0) {
                    filesOffset = 0;
                    availableSpots = pageSize - folderMap.size();
                    List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(listIds1, sortString, filesOffset, availableSpots, '');

                    for (ContentDocumentLink docLink : documentLinkList) {
                        displayItems.add(new x7sFilesItemModel(docLink));
                        System.debug('Document: ' + docLink.ContentDocument.Title + ' Parent Folder: ' + folderMap.get(docLink.LinkedEntityId));
                    }
                } else if (displayItems.size() < pageSize) {
                    filesOffset = pageSize * (currentPage - 1) - totalFolders;

                    if (String.isBlank(searchString)) {
                        List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(listIds1, sortString, filesOffset, recordLimit1, '');

                        for (ContentDocumentLink docLink : documentLinkList) {
                            displayItems.add(new x7sFilesItemModel(docLink));
                            System.debug('Document: ' + docLink.ContentDocument.Title + ' Parent Folder: ' + folderMap.get(docLink.LinkedEntityId));
                        }
                    }
                } else if (displayItems.size() > pageSize) {
                    filesOffset = 0;
                    if (String.isBlank(searchString)) {
                        List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(listIds1, sortString, filesOffset, recordLimit1, '');

                        for (ContentDocumentLink docLink : documentLinkList) {
                            displayItems.add(new x7sFilesItemModel(docLink));
                            System.debug('Document: ' + docLink.ContentDocument.Title + ' Parent Folder: ' + folderMap.get(docLink.LinkedEntityId));
                        }
                    }
                }
                totalFolders = getRecordCount(fromClause, whereClause, parentFolderId);
                TotalFiles = x7sFilesContentDocument.getRecordCount(listIds1, '');
                total = totalFolders + TotalFiles;

                if (total < 1) { return filesModel; }

                filesModel.total = total;
                filesModel.pageCount = Math.max(Math.ceil(total / pageSize), 1);
                filesModel.pageHasNext = (recordLimit * currentPage) < total;
                filesModel.pageHasPrevious = searchOffset > 0;
                filesModel.files = displayItems;
                System.debug('filesModel.files: ' + filesModel.files);
            }

            if (String.isNotBlank(searchString)) {
                if (isSearchTitle) {
                    tempQuery += ' OR ContentDocument.Title LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                }

                if (isSearchDescription) {
                    tempQuery += ' OR ContentDocument.Description LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
                }

                if (isSearchContent) {
                    Set<String> contentTitles = new Set<String>();

                    String findQuery = 'FIND ' + '\'' +
                            String.escapeSingleQuotes(searchString) + '\'' +
                            ' IN ALL FIELDS RETURNING ContentVersion(Title, Description WHERE (NOT Title LIKE  \'%' +
                            String.escapeSingleQuotes(searchString.trim()) + '%\' ) AND (NOT Description LIKE \'%' +
                            String.escapeSingleQuotes(searchString.trim()) + '%\' ) )';

                    System.debug('Find Query : ' + findQuery);

                    Search.SearchResults searchResults = Search.find(findQuery);

                    List<Search.SearchResult> filesList = searchResults.get('ContentVersion');
                    if (filesList.size() > 0) {
                        System.debug('Found files that contain the content');
                        for (Search.SearchResult searchResult : filesList) {
                            ContentVersion content = (ContentVersion) searchResult.getSObject();

                            // Using a set here to prevent storing duplicate names
                            if (!contentTitles.contains(String.escapeSingleQuotes(content.Title))) {
                                contentTitles.add('\'' + String.escapeSingleQuotes(content.Title) + '\'');
                            }
                        }
                    }

                    if (contentTitles.isEmpty() && (!isSearchTitle)) {
                        tempQuery += ' OR ContentDocument.Title = null';
                    } else if (!contentTitles.isEmpty()) {
                        // Using this trick here to prevent the string from being truncated when converted from a list to a string.
                        List<String> contentTitleList = new List<String>();
                        contentTitleList.addAll(contentTitles);
                        tempQuery += ' OR ContentDocument.Title IN (' + String.join(contentTitleList, ',') + ')';
                    }
                }

                if (String.isNotBlank(tempQuery)) {
                    tempQuery = tempQuery.removeStart(' OR ') ;
                    contentDocumentFilters += ' AND (' + tempQuery + ')';
                }

                System.debug('Temp Query for search: ' + tempQuery);
            }

            if (String.isNotBlank(contentDocumentFilters)) {
                String sortByClause = x7sFilesContentDocument.getOrderByClause(sortString);
                String ContentDocLinkQuery = '';

                if (String.isNotBlank(parentFolderId) && String.isBlank(searchString)) {
                    ContentDocLinkQuery = 'SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = ' + '\'' + String.escapeSingleQuotes(parentFolderId) + '\'';
                } else if (String.isBlank(parentFolderId) && String.isNotBlank(searchString)) {
                    ContentDocLinkQuery = 'SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM X7S_File_Folder__c)';
                 }
                // else if (String.isBlank(parentFolderId) && String.isBlank(searchString)) {
                //     ContentDocLinkQuery = 'SELECT LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = null';
                // }

                contentDocumentFilters = contentDocumentFilters.removeStart(' AND ');

                if (String.isNotBlank(contentDocumentFilters)) {
                    ContentDocLinkQuery += ' AND ' + contentDocumentFilters;
                }

                ContentDocLinkQuery += sortByClause;

                for (ContentDocumentLink singleId : Database.query(ContentDocLinkQuery)) { //NOPMD
                    recId.add((String) singleId.get('LinkedEntityId'));
                }
                // filesOffset = pageSize * (currentPage - 1) ;
                // List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(recId, sortString, filesOffset, recordLimit, contentDocumentFilters);
                // for (ContentDocumentLink docLink : documentLinkList) {
                // 	displayItems.add(new x7sFilesItemModel(docLink));
                // }
                TotalFiles = x7sFilesContentDocument.getRecordCount(recId, contentDocumentFilters);
                // totalFolders = getRecordCount(fromClause, whereClause, null);
            }

            offset = (Integer) pageSize * (currentPage - 1);

            Integer recordLimit1 = (Integer) pageSize;
            Integer recordOffset1 = (Integer) searchOffset;
            String limitClause1 = ' LIMIT ' + recordLimit1;
            String offsetClause1 = ' OFFSET ' + offset;

            if (folderMap.size() < pageSize && folderMap.size() != 0) {
                availableSpots = pageSize - folderMap.size();
                System.debug('availableSpots:' + availableSpots);

                filesOffset = 0 ;
                List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(recId, sortString, filesOffset, availableSpots, contentDocumentFilters);
                for (ContentDocumentLink docLink : documentLinkList) {
                    displayItems.add(new x7sFilesItemModel(docLink));
                }

            } else if (displayItems.size() < pageSize) {
                if (String.isNotBlank(searchString) && (isSearchTitle || isSearchDescription)) {
                    totalFolders = getRecordCount(fromClause, whereClause, null);
                    filesOffset = (pageSize * (currentPage - 1)) - totalFolders;
                    System.debug('filesOffset.size:' + filesOffset);
                } else {
                    filesOffset = pageSize * (currentPage - 1);
                }

                List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(recId, sortString, filesOffset, recordLimit, contentDocumentFilters);
                for (ContentDocumentLink docLink : documentLinkList) {
                    displayItems.add(new x7sFilesItemModel(docLink));
                }
            } else if (displayItems.size() > pageSize) {
                filesOffset = 0;
                List<ContentDocumentLink> documentLinkList = x7sFilesContentDocument.getContentDocumentLinks(recId, sortString, filesOffset, recordLimit, contentDocumentFilters);
                for (ContentDocumentLink docLink : documentLinkList) {
                    displayItems.add(new x7sFilesItemModel(docLink));
                }

            }
            System.debug('totalFolders: ' + totalFolders);
            System.debug('TotalFiles: ' + TotalFiles);

            Decimal total = totalFolders + TotalFiles;
            System.debug('total: ' + total);
            if (total < 1) {
                return filesModel;
            }

            System.debug('total ' + total);
            filesModel.total = total;
            filesModel.pageCount = Math.max(Math.ceil(total / pageSize), 1);
            filesModel.pageHasNext = (recordLimit * currentPage) < total;
            filesModel.pageHasPrevious = searchOffset > 0;
            filesModel.files = displayItems;
            System.debug('filesModel.files: ' + filesModel.files);
        } catch (QueryException ex) {
            System.debug('Error occurred getting Files List - ' + ex.getMessage());
        }
        return filesModel;
    }

    /**
     * Get all folders
     * @param recordId Optional recordId (account, user, contact when placed on a detail page)
     * @return Files model
     */
    @AuraEnabled
    public static x7sFilesModel getFolders(String recordId) {
        System.debug('RecordId: ' + recordId);

        // String currentUser = UserInfo.getUserId();
        // List<Id> sharedIds = new List<Id>();
        // List<X7S_File_Folder__Share> sharedList =[SELECT parentId FROM X7S_File_Folder__Share WHERE UserOrGroupId = :currentUser];
        // for(X7S_File_Folder__Share entry :sharedList){
        //     sharedIds.add(entry.parentId);
        // }
        List<String> folderIdList;

        if (String.isNotBlank(recordId)) {
            folderIdList = getSharedRecord(recordId);
            System.debug('shared folders: ' + folderIdList);
        }

        Map<Id, X7S_File_Folder__c> folderMap =
                String.isBlank(recordId) ?
                        new Map<Id, X7S_File_Folder__c>([
                                SELECT Id, Name, Description__c, Sharing_Setting__c, Parent_Folder__c,CreatedDate,
                                        Parent_Folder__r.Id, Parent_Folder__r.Name,
                                        Parent_Folder__r.Parent_Folder__r.Id, Parent_Folder__r.Parent_Folder__r.Name,
                                        Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Id, Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Name
                                FROM X7S_File_Folder__c
                                ORDER BY Name
                        ]) : new Map<Id, X7S_File_Folder__c>([
                        SELECT Id, Name, Description__c, Sharing_Setting__c, Parent_Folder__c,CreatedDate,
                                Parent_Folder__r.Id, Parent_Folder__r.Name,
                                Parent_Folder__r.Parent_Folder__r.Id, Parent_Folder__r.Parent_Folder__r.Name,
                                Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Id, Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Name
                        FROM X7S_File_Folder__c
                        WHERE Id IN :folderIdList
                        ORDER BY Name
                ]);

        List<x7sFilesItemModel> recordList = new List<x7sFilesItemModel>();
        x7sFilesModel listModel = new x7sFilesModel();

        if (!folderMap.isEmpty()) {
            String communityUrl = getCommunityUrl();

            for (X7S_File_Folder__c folderItem : folderMap.values()) {
                System.debug('Folder Item: ' + folderItem);

                List<String> breadcrumbs = new List<String>();
                Map<String, String> parentItem;

                System.debug('GET PARENT FOLDER INFORMATION FOR FOLDER: ' + folderItem.Name);
                System.debug('Folder info: ' + folderItem);

//                if (folderItem.Name != null) {
//                    System.debug('Parent Item : ' + folderItem.Name);
//                    parentItem = new Map<String, String>();
//
//                    parentItem.put('Id', folderItem.Parent_Folder__c);
//                    parentItem.put('Name', folderItem.Name);
//
//                    breadcrumbs.add(JSON.serialize(parentItem));
//                }
                if (folderItem.Parent_Folder__r.Name != null) {
                    System.debug('Parent Item : ' + folderItem.Parent_Folder__r.Name);
                    parentItem = new Map<String, String>();

                    parentItem.put('Id', folderItem.Parent_Folder__r.Id);
                    parentItem.put('Name', folderItem.Parent_Folder__r.Name);

                    breadcrumbs.add(JSON.serialize(parentItem));
                }
                if (folderItem.Parent_Folder__r.Parent_Folder__r.Name != null) {
                    System.debug('Parent Item : ' + folderItem.Parent_Folder__r.Parent_Folder__r.Name);
                    parentItem = new Map<String, String>();

                    parentItem.put('Id', folderItem.Parent_Folder__r.Parent_Folder__r.Id);
                    parentItem.put('Name', folderItem.Parent_Folder__r.Parent_Folder__r.Name);

                    breadcrumbs.add(JSON.serialize(parentItem));
                }
                if (folderItem.Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Name != null) {
                    System.debug('Parent Item : ' + folderItem.Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Name);
                    parentItem = new Map<String, String>();

                    parentItem.put('Id', folderItem.Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Id);
                    parentItem.put('Name', folderItem.Parent_Folder__r.Parent_Folder__r.Parent_Folder__r.Name);

                    breadcrumbs.add(JSON.serialize(parentItem));
                }

                recordList.add(new x7sFilesItemModel(folderItem, communityUrl, null, breadcrumbs));
            }

            listModel.files = recordList;
        }

        return listModel;
    }

    @TestVisible
    private static String getWhereClause(String parentFolderId,
            String searchString,
            Boolean isSearchTitle,
            Boolean isSearchDescription,
            Boolean isSearchContent,
            String sortString,
            String listFilterParams,
            List<Id> recordIds) {

        String whereClause = '';
        String tempWhereClause = '';
        recId = new List<String>();
        String tempSearchFolderQuery = '';
        FilterHelper listFilter = String.isNotBlank (listFilterParams) ? (FilterHelper) JSON.deserialize(listFilterParams, FilterHelper.class) : new FilterHelper();

        System.debug('Parent folder Id: ' + parentFolderId);
        System.debug('Search String: ' + searchString);
        System.debug('Search Title: ' + isSearchTitle);
        System.debug('Search Description: ' + isSearchDescription);
        System.debug('Search Content: ' + isSearchContent);
        System.debug('Sort By: ' + sortString);
        System.debug('listFilter--' + listFilter);
        System.debug('Record Ids: ' + recordIds);

        if (String.isBlank(searchString)) {
            System.debug('SearchString is empty, will use parent folder for filtering');

            // Only use parent folder if we are not searching for all files/folders.
            if (String.isNotBlank(parentFolderId)) {
                tempWhereClause = '(Parent_Folder__c = \'' + String.escapeSingleQuotes(parentFolderId) + '\')';
            } else {
                tempWhereClause = 'Parent_Folder__c = NULL';
            }
        }

        if (String.isNotBlank(searchString)) {
            if (isSearchTitle) {
                tempSearchFolderQuery += ' OR Name LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'' ;
            }

            if (isSearchDescription) {
                tempSearchFolderQuery += ' OR Description__c LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
            }
        }

        if (String.isNotBlank(tempSearchFolderQuery)) {
            tempSearchFolderQuery = '(' + tempSearchFolderQuery.removeStart(' OR ') + ') ';
        }

        if (String.isNotBlank(tempWhereClause)) {
            tempWhereClause = tempWhereClause.removeStart(' AND ');
            whereClause = ' WHERE ' + tempWhereClause + tempSearchFolderQuery ;
        }

        if (String.isNotBlank(tempSearchFolderQuery) && String.isBlank(tempWhereClause)) {
            whereClause = ' WHERE ' + tempSearchFolderQuery;
        }

        if (!(recordIds == null)) {
            List<String> Ids = new List<String>();
            for (Id singleId : recordIds) {
                Ids.add('\'' + (String) singleId + '\'');
            }
            if (!(Ids.isEmpty())) {
                whereClause += ' AND Id IN (' + String.join(Ids, ',') + ')';
            }
        }

        System.debug('Final whereClause:' + whereClause);
        return whereClause;
    }

    private static Map<String, String> getFilters(String listFilterParams) {
        Map<String, String> filterQueries = new Map<String, String>();
        String folderFilters;
        String contentDocumentFilters;

        if (String.isNotBlank(listFilterParams)) {
            folderFilters = '';
            contentDocumentFilters = '';

            FilterHelper listFilterHelper = (FilterHelper) JSON.deserialize(listFilterParams, FilterHelper.class);
            fileTypeIds = new List<String>();

            if (listFilterHelper.selectedFileTypeValue != '' && listFilterHelper.selectedFileTypeValue != null) {
                List<String> filterItems = listFilterHelper.selectedFileTypeValue.split(';');
                List<String> items = new List<String>();
                for (String item : filterItems) {
                    items.add('\'' + String.escapeSingleQuotes(item) + '\'');
                }
                contentDocumentFilters += ' AND ContentDocument.FileType IN ' + items;
            }
            if (listFilterHelper.selectedFileSizeValue != '' && listFilterHelper.selectedFileSizeValue != null) {
                String fileSize = getFileSize(listFilterHelper.selectedFileSizeValue);
                contentDocumentFilters += ' AND ContentDocument.ContentSize' + fileSize;
            }
            if (String.isNotBlank(listFilterHelper.selectedFromDate)) {
                String fromDate = listFilterHelper.selectedFromDate + 'T00:00:00Z';
                contentDocumentFilters += ' AND ContentDocument.CreatedDate >=' + fromDate;
                folderFilters += ' AND CreatedDate >=' + fromDate;
            }
            if (String.isNotBlank(listFilterHelper.selectedToDate)) {
                String toDate = listFilterHelper.selectedToDate  + 'T23:59:59Z';
                contentDocumentFilters += ' AND ContentDocument.CreatedDate <=' + toDate;
                folderFilters += ' AND CreatedDate <=' + toDate;
            }
            if (String.isNotBlank(listFilterHelper.selectedModFromDate)) {
                String fromDate = listFilterHelper.selectedModFromDate + 'T00:00:00Z';
                contentDocumentFilters += ' AND ContentDocument.LastModifiedDate >=' + fromDate;
                folderFilters += ' AND LastModifiedDate >=' + fromDate;
            }
            if (String.isNotBlank(listFilterHelper.selectedModToDate)) {
                String toDate = listFilterHelper.selectedModToDate  + 'T23:59:59Z';
                contentDocumentFilters += ' AND ContentDocument.LastModifiedDate <=' + toDate;
                folderFilters += ' AND LastModifiedDate <=' + toDate;
            }
            if (listFilterHelper.selectedOwnerId != '' && listFilterHelper.selectedOwnerId != null) {
                contentDocumentFilters += ' AND ContentDocument.CreatedById = ' + '\'' + String.escapeSingleQuotes(listFilterHelper.selectedOwnerId) + '\'';
                folderFilters += ' AND CreatedById = ' + '\'' + String.escapeSingleQuotes(listFilterHelper.selectedOwnerId) + '\'';
            }
            if (listFilterHelper.selectedModifierId != '' && listFilterHelper.selectedModifierId != null) {
                contentDocumentFilters += ' AND ContentDocument.LastModifiedById = ' + '\'' + String.escapeSingleQuotes(listFilterHelper.selectedModifierId) + '\'';
                folderFilters += ' AND LastModifiedById = ' + '\'' + String.escapeSingleQuotes(listFilterHelper.selectedModifierId) + '\'';
            }

            filterQueries.put(CONTENT_DOCUMENT_FILTER, contentDocumentFilters);
            filterQueries.put(FOLDER_FILTER, folderFilters);
        }

        return filterQueries;
    }

    private static String getFolderOrderByClause(String sortBy) {
        String sortByClause = '';

        switch on sortBy {
            when 'A to Z Name' { sortByClause += ' ORDER BY Name'; }
            when 'Z to A Name' { sortByClause += ' ORDER BY Name DESC'; }
            when else { sortByClause += ' ORDER BY Name'; }
        }
        return sortByClause;
    }

    @TestVisible
    private static Decimal getRecordCount(String fromClause, String whereClause, String parentFolderId) {
        String countQuery = '';

        if (parentFolderId != '' && parentFolderId != null) {
            X7S_File_Folder__c parentId = Database.query('SELECT Id,Parent_Folder__c ' + fromClause + ' WHERE Id = :parentFolderId');

            if (parentId.Parent_Folder__c != null) {
                countQuery = 'SELECT count() ' + fromClause + ' WHERE Parent_Folder__c = :parentFolderId';
            } else {
                if (String.isNotBlank(whereClause)) {
                    countQuery = 'SELECT count() ' + fromClause + whereClause + ' AND Parent_Folder__c != null ';
                } else {
                    countQuery = 'SELECT count() ' + fromClause + ' WHERE Parent_Folder__c != null ';
                }
            }
        } else {
            System.debug('whereClause---' + whereClause);
            countQuery = 'SELECT count() ' + fromClause + whereClause ;
        }

        System.debug('countQuery---' + countQuery);

        Decimal total = Database.countQuery(countQuery);

        return total;
    }

    public static String getCommunityUrl() {
        String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm();

        try {
            String url = Network.getLoginUrl(Network.getNetworkId());
            String communityUrl = url.substring(0, url.lastIndexOf('/s/'));
            return communityUrl;
        } catch (Exception e) { System.debug('No community found');return baseUrl; }
    }

    /**
     * Get folder for the specified record Id
     *
     * @param recordId Folder record Id
     *
     * @return Folder record
     */
    @AuraEnabled
    public static x7sFilesFolder getFolder(String recordId) {
        x7sFilesFolder filesFolder = null;

        X7S_File_Folder__c folder = [SELECT Id, Name, Description__c, Parent_Folder__c, Sharing_Setting__c FROM X7S_File_Folder__c WHERE Id = :recordId WITH SECURITY_ENFORCED];
        if (folder != null) {
            filesFolder = new x7sFilesFolder(folder.Id, folder.Name, folder.Description__c, folder.Parent_Folder__c, folder.Sharing_Setting__c);
        }

        return filesFolder;
    }

    /**
     * Get the Criteria Values
     *
     * @param settingId setting record Id
     *
     * @return x7sFilesCriteriaListModel Criteria wrapper
     */

    @AuraEnabled
    public static x7sFilesCriteriaListModel getCriteriaValues(String settingId) {
        //System.debug('getCriteriaValues:' + settingId);
        try {
            X7S_Files_Setting__mdt settingCMT = X7S_Files_Setting__mdt.getInstance(settingId);

            if (settingCMT != null) {
                x7sFilesCriteriaListModel settingModel = x7sFilesCriteriaController.getCriteriaListModel (settingCMT.X7S_Files_Criteria_Set__c);
                settingModel.dump('getCriteriaValues: ' + settingId);

                return settingModel;
            }
        } catch (QueryException ex) {
            System.debug('Settings not found for ' + settingId);
        }
        return null;
    }

    @AuraEnabled
    public static String getBaseUrl() {
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
        return baseUrl;
    }

    @TestVisible
    private static List<Id> getSharedRecord(Id recordId) {
        System.debug('getSharedRecord for ' + recordId);
        Integer queryLimit = x7sFilesConstants.QueryLimit;
        List<Id> itemList = new List<Id>();

        try {
            String objectName = String.valueOf(recordId.getSobjectType());
            String targetId = '';
            switch on objectName {
                when 'Account' {
                    User accountUser = [SELECT Id, Account.Id FROM User WHERE Account.Id = :recordId  WITH SECURITY_ENFORCED LIMIT 1];
                    if (accountUser != null) {
                        targetId = (String) accountUser.get('Id');
                        System.debug('Account user:' + targetId);
                    }
                }
                when 'Contact' {
                    User contactUser = [SELECT Id,Contact.Id FROM User WHERE Contact.Id = :recordId  WITH SECURITY_ENFORCED ] ;
                    if (contactUser != null) {
                        targetId = (String) contactUser.get('Id');
                        System.debug('Contact user:' + targetId);
                    }
                }
                when else { targetId = recordId; }
            }
            System.debug('Target recordId: ' + targetId);
            if (String.isNotBlank(targetId)) {
                for (X7S_File_Folder__Share sharedFolder : [SELECT ParentId, RowCause, UserOrGroupId FROM X7S_File_Folder__Share WHERE RowCause = :X7S_ROW_CAUSE AND UserOrGroupId = :targetId  WITH SECURITY_ENFORCED LIMIT :queryLimit]) {
                    itemList.add(sharedFolder.ParentId);
                }
            }
            System.debug('Shares folders ItemList:' + itemList);

            return itemList;
        } catch (QueryException ex) {
            System.debug('Error occurred getting Records for recordId : ' + recordId + ' - ' + ex.getMessage());
        }

        return null;
    }

    @TestVisible
    private static String getFileSize(String size) {
        String fileSize = '';
        switch on size {
            when 'lessThan10KB' { fileSize = ' <= 10000 '; }
            when 'greaterThan10KBTo100KB' { fileSize = ' > 10000 AND ContentDocument.ContentSize <= 100000 '; }
            when 'greaterThan100KBTO1MB' { fileSize = ' > 100000 AND ContentDocument.ContentSize <= 1000000 '; }
            when 'greaterThan1MBTO10MB' { fileSize = ' > 1000000 AND ContentDocument.ContentSize <= 10000000 '; }
            when 'greaterThan10MBTO50MB' { fileSize = ' > 10000000 AND ContentDocument.ContentSize <= 50000000 '; }
            when 'greaterThan50MBTO100MB' { fileSize = ' > 50000000 AND ContentDocument.ContentSize <= 100000000 '; }
            when 'greaterThan100MB' { fileSize = ' > 100000000 '; }
        }
        return fileSize;
    }
}