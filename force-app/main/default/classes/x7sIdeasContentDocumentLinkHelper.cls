/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasContentDocumentLinkHelper {

	public static void onBeforeInsert(List<ContentDocumentLink> listOfContentDocLinks) {
		for (ContentDocumentLink cdl : listOfContentDocLinks) {
			if (cdl.LinkedEntityId.getSobjectType() == X7S_Ideas_Extension__c.getSObjectType()) {
				cdl.Visibility = 'AllUsers';
			}
		}
	}
}