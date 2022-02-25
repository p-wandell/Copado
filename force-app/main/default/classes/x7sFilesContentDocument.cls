/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesContentDocument {
	public static final String FILE_LOCATION = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
	public static final String FILE_PARAMS = '?rendition=THUMB720BY480&versionId=';
	public static final String PUBLISH_STATUS = 'U';
	public static String selectClause = 'SELECT ContentDocumentLink.LinkedEntityId'
	+ ', ContentDocument.LatestPublishedVersionId'
	+ ', ContentDocument.Title'
	+ ', ContentDocument.FileExtension'
	+ ', ContentDocument.FileType'
	+ ', ContentDocument.LastModifiedById'
	+ ', ContentDocument.LastViewedDate'
	+ ', ContentDocument.LastReferencedDate'
	+ ', ContentDocument.ContentSize'
	+ ', ContentDocument.Description'
	+ ', ContentDocument.ContentModifiedDate'
	+ ', ContentDocument.CreatedDate';

	public static String fromClause = ' FROM ContentDocumentLink ' ; 

	public static String whereClause = ' WHERE ContentDocument.PublishStatus != :PUBLISH_STATUS  AND ContentDocument.IsDeleted = false AND ContentDocument.IsArchived = false AND LinkedEntityId IN ';

	public static List<ContentDocumentLink> getContentDocumentLinks(List<Id> listIds, String sortString, Decimal filesOffset, Decimal recordLimit, String filterItems) {
		String contentQuery = '';
		List<ContentDocumentLink> links = new List<ContentDocumentLink>();

		if (listIds.size() > 0) {
			List<String> idParts = new List<String>();

			for (Id itemId : listIds) {
				idParts.add('\'' + itemId + '\'');
			}

			contentQuery += selectClause + fromClause + whereClause;
			contentQuery += ' (' + String.join(idParts, ',') + ') ';
			if(String.isNotBlank(filterItems)){
				contentQuery += ' AND '+filterItems ;
			}
			contentQuery += getOrderByClause(sortString);
			contentQuery += ' LIMIT ' + (Integer) recordLimit;
			contentQuery += ' OFFSET ' + (Integer) filesOffset;

			System.debug('getContentDocumentLinks query: ' + contentQuery);

			//PMD : False positive, All variables are checked
			Map<Id, ContentDocumentLink> ListMap = new Map<Id, ContentDocumentLink>();
			List<ContentDocumentLink> documentLinkList = (List<ContentDocumentLink>) Database.query(contentQuery); //NOPMD
			for (ContentDocumentLink link : documentLinkList) {
				links.add(link);
			}
		}
		return links;
	}


	Public static String getOrderByClause(String sortBy) {
        String sortByClause = '';

		System.debug('Content Document Sort String: ' + sortBy);

        switch on sortBy {
            when 'A to Z Name' { sortByClause += ' ORDER BY ContentDocument.Title'; }
            when 'Z to A Name' { sortByClause += ' ORDER BY ContentDocument.Title DESC'; }
            when 'A to Z Type' { sortByClause += ' ORDER BY ContentDocument.FileType'; }
            when 'Z to A Type' { sortByClause += ' ORDER BY ContentDocument.FileType DESC'; }
            when 'High to Low Size'{ sortByClause += ' ORDER BY ContentDocument.ContentSize DESC'; }
            when 'Low To High Size'{ sortByClause += ' ORDER BY ContentDocument.ContentSize'; }
            when 'High to Low Date'{ sortByClause += ' ORDER BY ContentDocument.CreatedDate DESC'; }
            when 'Low To High Date'{ sortByClause += ' ORDER BY ContentDocument.CreatedDate '; }
			when else { sortByClause += ' ORDER BY ContentDocument.Title'; }
        }
        return sortByClause;
    }

	public static Decimal getRecordCount(List<Id> listIds, String filterItems) {
		if (listIds != null && !(listIds.isEmpty())){
			String countQuery = '';
			countQuery = 'SELECT count() ' + fromClause + whereClause;
			String temp = ' (';
	
			for (Id itemId : listIds) {
				temp += '\'' + itemId + '\', ';
			}
	
			countQuery += temp.contains(', ') ? temp.substring(0, temp.lastIndexOf(', ')) + ')' : '';
			if(String.isNotBlank(filterItems)){
				countQuery += ' AND '+filterItems ;
			}
			System.debug('Content Document getRecordCount query: ' + countQuery);
			Decimal total = Database.countQuery(countQuery);
			return total;
		}
		else {
			return 0 ;
		}
    }

}