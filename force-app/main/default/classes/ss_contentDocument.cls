/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/10/17.
 */

public with sharing class ss_contentDocument
{
	public static final String CHATTER_FILE_LOCATION = '/sfc/servlet.shepherd/version/download/';
	public static final String CHATTER_FILE_PARAMS   = '?asPdf=false&operationContext=CHATTER';

	public static List<ContentDocumentLink> getContentDocumentLinks(List<Id> productIds) {
		String contentQuery = 'SELECT ContentDocumentLink.LinkedEntityId'
			+ ', ContentDocument.LatestPublishedVersionId'
			+ ' FROM ContentDocumentLink'
			+ ' WHERE LinkedEntityId IN ';

		String temp = ' (';

		for (Id itemId : productIds) {
			temp += '\'' + itemId + '\', ';
		}

		contentQuery += temp.contains(', ') ? temp.substring(0, temp.lastIndexOf(', ')) + ')' : '';
		contentQuery += ' ORDER BY ContentDocument.CreatedDate DESC';

		List<ContentDocumentLink> documentLinkList = (List<ContentDocumentLink>) Database.query(contentQuery);

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