/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
public with sharing class x7sNewsDocumentLinkHelper
{
	public static void onBeforeInsert(List<ContentDocumentLink> listOfContentDocLinks)
	{
		for (ContentDocumentLink cdl : listOfContentDocLinks) {
			if (cdl.LinkedEntityId.getSobjectType() == X7S_News__c.getSObjectType()) { cdl.Visibility = 'AllUsers';}
		}
	}
}