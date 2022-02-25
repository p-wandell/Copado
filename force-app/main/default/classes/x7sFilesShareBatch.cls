/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

/*
 * To run this in the dev console anonymous window, enter:
 *  Id batchJobId = Database.executeBatch(new x7sFilesShareBatch(), 20);
 *  System.debug('batch job Id: ' + batchJobId);
 * (enable 'open log' to see the output)
 */
@SuppressWarnings('PMD.ApexSharingViolations, PMD.ApexCRUDViolation')
global class x7sFilesShareBatch implements Database.Batchable<SObject>, Database.Stateful {
	global String queryString { get; set; }
	global Integer Count { get; set; }

	global x7sFilesShareBatch() {
		queryString = 'SELECT Id, Name, Sharing_Setting__c FROM X7S_File_Folder__c';
		Count = 0;
	}

	global Database.QueryLocator start(Database.BatchableContext bc) {
		System.debug('start - Batch query: ' + queryString);
		return Database.getQueryLocator(queryString);
	}

	global void execute(Database.BatchableContext bc, List<SObject> scope) {
		List<X7S_File_Folder__c> folderList = (List<X7S_File_Folder__c>) scope;
		System.debug('execute - folders : ' + folderList.size());
		for (X7S_File_Folder__c folder : folderList) {
			x7sFilesShareController.applyFolderShare(folder); Count += 1;
		}
	}

	global void finish(Database.BatchableContext bc) {
		System.debug('finish - Folders processed: ' + Count);
	}
}