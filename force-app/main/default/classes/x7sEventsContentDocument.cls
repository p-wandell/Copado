/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sEventsContentDocument {
    
    public static final String FILE_LOCATION = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=';
	public static final String FILE_PARAMS   = '?rendition=THUMB720BY480&versionId=';

	public static List<ContentDocumentLink> getContentDocumentLinks(List<Id> listIds) {
		String contentQuery = 'SELECT ContentDocumentLink.LinkedEntityId'
			+ ', ContentDocument.LatestPublishedVersionId'
			+ ', ContentDocument.Title'
			+ ', ContentDocument.FileExtension'
			+ ' FROM ContentDocumentLink'
			+ ' WHERE ContentDocument.FileType IN (\'JPG\', \'PNG\', \'GIF\') AND LinkedEntityId IN ';

		String temp = ' (';

		for (Id itemId : listIds) {
			temp += '\'' + itemId + '\', ';
		}

		contentQuery += temp.contains(', ') ? temp.substring(0, temp.lastIndexOf(', ')) + ')' : '';
		contentQuery += ' ORDER BY ContentDocument.CreatedDate DESC';

		//PMD : False positive, All variables are checked
		List<ContentDocumentLink> documentLinkList = (List<ContentDocumentLink>) Database.query(contentQuery); //NOPMD
		return documentLinkList;
	}

	public static List<ContentDocumentLink> containsEntityId(List<ContentDocumentLink> documentList, Id searchId) {
		List<ContentDocumentLink> links = new List<ContentDocumentLink>();
		for (ContentDocumentLink link : documentList) {
			if (link.LinkedEntityId == searchId) {
				links.add(link);
			}
		}
		return links;
	}

}