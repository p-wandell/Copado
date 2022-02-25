/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesContentDocumentHelper {
	public static void onBeforeInsert(List<ContentDocumentLink> listOfContentDocLinks) {
		SObjectType fileType =  X7S_File_Folder__c.getSObjectType();
		for (ContentDocumentLink cdl : listOfContentDocLinks) {
			if (cdl.LinkedEntityId.getSobjectType() == fileType) { cdl.Visibility = 'AllUsers'; }
		}
	}
}